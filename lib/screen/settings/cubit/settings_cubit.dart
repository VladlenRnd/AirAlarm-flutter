import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:package_info_plus/package_info_plus.dart';

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

    emit(SettingsDataLoad(
      version: infoApp.version,
      autoSearch: SettingsService.isAutoSearch ?? false,
      alarmSoundSelect:
          SoundService.getModelByFileName(SettingsService.alarmSoundFilaName ?? "", SoundService.alarmSounds) ?? SoundService.alarmSounds[0],
      cancelSoundSelect:
          SoundService.getModelByFileName(SettingsService.cancelSoundFilaName ?? "", SoundService.cancelSounds) ?? SoundService.cancelSounds[0],
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

  void setAlarmSound(SoundModel as) async {
    await SettingsService.setParametr(alarmSongParam: as.fileName);
    _setEmit(alarmSoundSelect: as);
  }

  void setCancelSound(SoundModel as) async {
    await SettingsService.setParametr(cancelSongParam: as.fileName);
    _setEmit(cancelSoundSelect: as);
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

  void _setEmit({bool? autoSearch, SoundModel? alarmSoundSelect, SoundModel? cancelSoundSelect, String? silenceTime}) {
    SettingsDataLoad oldState = state as SettingsDataLoad;

    emit(SettingsDataLoad(
      version: oldState.version,
      autoSearch: autoSearch ?? oldState.autoSearch,
      alarmSoundSelect: alarmSoundSelect ?? oldState.alarmSoundSelect,
      cancelSoundSelect: cancelSoundSelect ?? oldState.cancelSoundSelect,
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
