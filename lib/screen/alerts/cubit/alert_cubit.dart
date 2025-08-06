import 'dart:async';

import 'package:collection/collection.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logger/logger.dart';

import '../../../models/region_model.dart';
import '../../../service/settings_service.dart';
import '../../../tools/connection/connection.dart';

part 'alert_state.dart';

class AlertCubit extends Cubit<AlertState> {
  List<RegionModel> _globalAlert = [];
  String? _selectRegionUID;
  Timer? _timer;

  AlertCubit() : super(AlertLoadingState()) {
    _updateData();

    _timer = Timer.periodic(
      Duration(seconds: 10),
      (timer) => _updateData(),
    );
  }

//****** EVENTS ********* */

  Future<bool> subscribeRegion(String? regionUID) async {
    if (regionUID == null) return false;

    try {
      if (SettingsService.subscribeRegion != null && (SettingsService.subscribeRegion?.isNotEmpty ?? false)) {
        await FirebaseMessaging.instance.unsubscribeFromTopic(SettingsService.subscribeRegion!);
      }

      await FirebaseMessaging.instance.subscribeToTopic(regionUID);
      await SettingsService.setParametr(subscribeRegionParam: regionUID);

      _updateEmit();
      return true;
    } catch (e) {
      Logger().e("subscribe exeption", error: e);
    }

    return false;
  }

  void selectRegion({required String? selectUID}) {
    _selectRegionUID = selectUID;
    _updateEmit();
  }

//*************************************** */

  void _updateEmit() {
    emit(AlertLoadedDataState(
      regionList: _globalAlert,
      subscribeRegion: _getSubscribeRegion(allRegion: _globalAlert),
      selectRegion: _globalAlert.firstWhereOrNull((e) => e.uid == _selectRegionUID),
    ));
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

  RegionModel? _getSubscribeRegion({required List<RegionModel> allRegion}) {
    String? uidSub = SettingsService.subscribeRegion;

    if (uidSub == null) return null;

    return allRegion.firstWhereOrNull((e) => e.uid == uidSub);
  }

  @override
  Future<void> close() {
    _timer?.cancel();
    return super.close();
  }
}
