import 'package:collection/collection.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:package_info_plus/package_info_plus.dart';

import '../../../models/alert_setting_model.dart';
import '../../../models/sound_model.dart';
import '../../../service/location_service.dart';
import '../../../service/settings_service.dart';

part 'settings_state.dart';

class SettingsCubit extends Cubit<SettingsState> {
  SettingsCubit() : super(SettingsInitial()) {
    _initSettings();
  }

  void _initSettings() async {
    PackageInfo infoApp = await PackageInfo.fromPlatform();

    emit(SettingsDataLoaded(
      version: infoApp.version,
      autoSearch: SettingsService.isAutoSearch ?? false,
      subscribeList: SettingsService.subscribeRegions ?? [],

      // alarmSoundSelect:
      //     SoundService.getModelByFileName(SettingsService.alarmSoundFilaName ?? "", SoundService.alarmSounds) ?? SoundService.alarmSounds[0],
      // cancelSoundSelect:
      //     SoundService.getModelByFileName(SettingsService.cancelSoundFilaName ?? "", SoundService.cancelSounds) ?? SoundService.cancelSounds[0],

      silenceTime:
          _getSilenceTimeStr(start: DateTime.tryParse(SettingsService.siledStart ?? ""), end: DateTime.tryParse(SettingsService.siledEnd ?? "")),
    ));
  }

  //Set AutoSearch Parametr
  Future<bool> setAutoSearch(bool isAutoSearch) async {
    if (isAutoSearch) {
      if (await LocationService.enableAutoLocation()) {
        SettingsService.setParametr(isAutoSearchParam: isAutoSearch);
        _setEmit(autoSearch: isAutoSearch);
      } else {
        return false;
      }
    } else {
      LocationService.disabledAutoLocation();
      SettingsService.setParametr(isAutoSearchParam: isAutoSearch);
      _setEmit(autoSearch: isAutoSearch);
    }
    return true;
  }

  void setAlarmSound({required String uid, required SoundModel sound}) async {
    List<SubscribeAlertModel> list = List<SubscribeAlertModel>.from(SettingsService.subscribeRegions ?? []);

    final index = list.indexWhere((e) => e.regionUID == uid);
    if (index == -1) return;
    list[index] = list[index].copyWith(alarmSoundFilaName: sound.fileName);

    _setEmit(subscribeAlert: list);
    await SettingsService.setParametr(subscribeRegionsParam: list);
  }

  void setCancelSound({required String uid, required SoundModel sound}) async {
    List<SubscribeAlertModel> list = List<SubscribeAlertModel>.from(SettingsService.subscribeRegions ?? []);

    final index = list.indexWhere((e) => e.regionUID == uid);
    if (index == -1) return;
    list[index] = list[index].copyWith(cancelSoundFilaName: sound.fileName);

    _setEmit(subscribeAlert: list);
    await SettingsService.setParametr(subscribeRegionsParam: list);
  }

  Future<void> setNewPosition({required List<SubscribeAlertModel> newPosition}) async {
    _setEmit(subscribeAlert: newPosition);

    await SettingsService.setParametr(
      subscribeRegionsParam: newPosition,
    );
  }

  void setMuteMode({required String uid, required bool isMuted}) async {
    List<SubscribeAlertModel> list = List<SubscribeAlertModel>.from(SettingsService.subscribeRegions ?? []);

    final index = list.indexWhere((e) => e.regionUID == uid);
    if (index == -1) return;

    list[index] = list[index].copyWith(isMuted: isMuted);

    _setEmit(subscribeAlert: list);
    await SettingsService.setParametr(subscribeRegionsParam: list);
  }

  void removeSilenceTime() {
    SettingsService.setParametr(siledStartParam: "");
    SettingsService.setParametr(siledEndParam: "");

    _setEmit(silenceTime: _getSilenceTimeStr(start: null, end: null));
  }

  void setSilenceTime(TimeOfDay start, TimeOfDay end) {
    DateTime dateStart = DateTime(0, 1, 1, start.hour, start.minute);
    DateTime dateEnd = DateTime(0, 1, 1, end.hour, end.minute);

    SettingsService.setParametr(siledStartParam: dateStart.toString());
    SettingsService.setParametr(siledEndParam: dateEnd.toString());

    _setEmit(silenceTime: _getSilenceTimeStr(start: dateStart, end: dateEnd));
  }

  void _setEmit({bool? autoSearch, String? silenceTime, List<SubscribeAlertModel>? subscribeAlert}) {
    SettingsDataLoaded oldState = state as SettingsDataLoaded;

    emit(SettingsDataLoaded(
      version: oldState.version,
      autoSearch: autoSearch ?? oldState.autoSearch,
      subscribeList: subscribeAlert ?? oldState.subscribeList,
      silenceTime: silenceTime ?? oldState.silenceTime,
    ));
  }

  String _getSilenceTimeStr({required DateTime? start, required DateTime? end}) {
    if (start == null || end == null) {
      return "Нет";
    }
    return "${DateFormat("HH:mm").format(start)} - ${DateFormat("HH:mm").format(end)}";
  }
}
