import 'dart:convert';

import '../models/alert_setting_model.dart';
import 'shered_preferences_service.dart';

class SettingsService {
  static List<SubscribeAlertModel>? subscribeRegions;
  static bool? isAutoSearch;
  static String? siledStart;
  static String? siledEnd;
  static List<String>? filterList;

  static void setDefault() {
    subscribeRegions = [];
    isAutoSearch = false;
    siledStart = "";
    siledEnd = "";
    filterList = [EFilter.alarm.name, EFilter.noAlarm.name, EFilter.warning.name];
  }

  static Future<bool> setParametr({
    List<SubscribeAlertModel>? subscribeRegionsParam,
    String? siledStartParam,
    String? siledEndParam,
    bool? isAutoSearchParam,
    List<String>? filterListParam,
  }) async {
    subscribeRegions = subscribeRegionsParam ?? subscribeRegions;
    siledStart = siledStartParam ?? siledStart;
    siledEnd = siledEndParam ?? siledEnd;
    isAutoSearch = isAutoSearchParam ?? isAutoSearch;
    filterList = filterListParam ?? filterList;

    return await SheredPreferencesService.preferences.setString("settings", json.encode(toJson()));
  }

  static Map<String, Object?> toJson() {
    return {
      "subscribeRegionList": subscribeRegions?.map((e) => e.toJson()).toList(),
      "isAutoSearch": isAutoSearch,
      "siledStart": siledStart,
      "siledEnd": siledEnd,
      "filterList": filterList,
    };
  }

  static void fromJson(Map<String, dynamic> json) {
    subscribeRegions = (json['subscribeRegionList'] as List<dynamic>).map((e) => SubscribeAlertModel.fromJson(e as Map<String, dynamic>)).toList();
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
