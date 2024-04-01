import 'dart:convert';

import '../models/sound_model.dart';
import '../tools/region/eregion.dart';
import 'shered_preferences_service.dart';

class SettingsService {
  static String? subscribeRegion;
  static String? alarmSoundFilaName;
  static String? cancelSoundFilaName;
  static bool? isAutoSearch;
  static String? siledStart;
  static String? siledEnd;
  static List<String>? filterList;

  static void setDefault() {
    subscribeRegion = ERegion.dnipro.name;
    alarmSoundFilaName = SoundService.alarmSounds[1].fileName;
    cancelSoundFilaName = SoundService.cancelSounds[1].fileName;
    isAutoSearch = false;
    siledStart = "";
    siledEnd = "";
    filterList = [EFilter.alarm.name, EFilter.noAlarm.name, EFilter.warning.name];
  }

  static Future<bool> setParametr(
      {String? subscribeRegionParam,
      String? alarmSongParam,
      String? cancelSongParam,
      String? siledStartParam,
      String? siledEndParam,
      bool? isAutoSearchParam,
      List<String>? filterListParam}) async {
    subscribeRegion = subscribeRegionParam ?? subscribeRegion;
    alarmSoundFilaName = alarmSongParam ?? alarmSoundFilaName;
    cancelSoundFilaName = cancelSongParam ?? cancelSoundFilaName;
    siledStart = siledStartParam ?? siledStart;
    siledEnd = siledEndParam ?? siledEnd;
    isAutoSearch = isAutoSearchParam ?? isAutoSearch;
    filterList = filterListParam ?? filterList;

    return await SheredPreferencesService.preferences.setString("settings", json.encode(toJson()));
  }

  static Map<String, Object?> toJson() {
    return {
      "subscribeRegion": subscribeRegion,
      "alarmSong": alarmSoundFilaName,
      "cancelSong": cancelSoundFilaName,
      "isAutoSearch": isAutoSearch,
      "siledStart": siledStart,
      "siledEnd": siledEnd,
      "filterList": filterList,
    };
  }

  static void fromJson(Map<String, dynamic> json) {
    subscribeRegion = json['subscribeRegion'];
    alarmSoundFilaName = json['alarmSong'];
    cancelSoundFilaName = json['cancelSong'];
    isAutoSearch = json['isAutoSearch'];
    siledEnd = json['siledEnd'];
    siledStart = json['siledStart'];
    filterList = json['filterList'].cast<String>();
  }
}

enum EFilter {
  alarm,
  warning,
  noAlarm,
}
