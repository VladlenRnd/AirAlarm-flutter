import 'dart:async';

import 'package:collection/collection.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logger/logger.dart';

import '../../../models/alert_setting_model.dart';
import '../../../models/region_model.dart';
import '../../../service/settings_service.dart';
import '../../../service/shered_preferences_service.dart';
import '../../../tools/connection/connection.dart';

part 'alert_state.dart';

class AlertCubit extends Cubit<AlertState> {
  List<RegionModel> _globalAlert = [];
  String? _selectRegionUID;
  Timer? _timer;

  AlertCubit() : super(AlertLoadingState()) {
    _updateData();

    _selectRegionUID = SheredPreferencesService.preferences.getString("selectRegionUID");

    _timer = Timer.periodic(
      Duration(seconds: 10),
      (timer) => _updateData(),
    );
  }

//****** EVENTS ********* */

  Future<bool> unsubscribeRegion(String? regionUID) async {
    if (regionUID == null) return false;

    List<SubscribeAlertModel> subAll = SettingsService.subscribeRegions ?? [];

    if (subAll.firstWhereOrNull((e) => e.regionUID == regionUID) != null) {
      try {
        subAll.removeWhere((e) => e.regionUID == regionUID);
        await FirebaseMessaging.instance.unsubscribeFromTopic(regionUID);
        await SettingsService.setParametr(subscribeRegionsParam: subAll);
        _updateEmit();
        return true;
      } catch (e) {
        Logger().e("UnSubscribe exeption", error: e);
      }
    }
    return false;
  }

  Future<bool> subscribeRegion(String? regionUID) async {
    if (regionUID == null) return false;

    List<SubscribeAlertModel> subScribe = SettingsService.subscribeRegions ?? [];

    try {
      subScribe.add(SubscribeAlertModel.create(regionUID: regionUID));
      await FirebaseMessaging.instance.subscribeToTopic(regionUID);
      await SettingsService.setParametr(subscribeRegionsParam: subScribe);

      _updateEmit();
      return true;
    } catch (e) {
      Logger().e("subscribe exeption", error: e);
    }

    return false;
  }

  void selectRegion({required String? selectUID}) {
    _selectRegionUID = selectUID;

    if (_selectRegionUID != null) {
      SheredPreferencesService.preferences.setString("selectRegionUID", _selectRegionUID!);
    }

    _updateEmit();
  }

//*************************************** */

  void _updateEmit() {
    RegionModel? selectReg = _globalAlert.firstWhereOrNull((e) => e.uid == _selectRegionUID);

    if (selectReg != null) {
      selectReg.listDistrict!.sort(
        (a, b) {
          if (a.isAlert == b.isAlert) return 0;
          return a.isAlert ? -1 : 1;
        },
      );
    }

    emit(AlertLoadedDataState(regionList: _globalAlert, subscribeRegions: _getSubscribeRegions(allRegion: _globalAlert), selectRegion: selectReg));
  }

  Future<void> _updateData() async {
    if (isClosed) {
      _timer?.cancel();
      return;
    }

    try {
      _globalAlert = await Connection.getAllAlert();
      _updateEmit();
    } catch (e) {
      Logger().e("Error get alert:", error: e);
      emit(AlertErrorDataState());
    }
  }

  List<RegionModel>? _getSubscribeRegions({required List<RegionModel> allRegion}) {
    final uidSub = SettingsService.subscribeRegions;

    if (uidSub == null || uidSub.isEmpty) return null;

    final allDistricts = allRegion.expand((e) => e.listDistrict ?? <RegionModel>[]).toList();
    final result = uidSub.map((sub) => allDistricts.firstWhereOrNull((district) => district.uid == sub.regionUID)).whereType<RegionModel>().toList();

    return result.isEmpty ? null : result;
  }

  @override
  Future<void> close() {
    _timer?.cancel();
    return super.close();
  }
}
