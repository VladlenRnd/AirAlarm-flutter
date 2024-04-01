import 'dart:convert';

import 'package:alarm/service/abstract_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'settings_service.dart';

class SheredPreferencesService implements AService {
  static SharedPreferences? _preferences;
  static SharedPreferences get preferences => _preferences!;

  SheredPreferencesService._privateConstructor();
  static final SheredPreferencesService _instance = SheredPreferencesService._privateConstructor();
  factory SheredPreferencesService() => _instance;

  @override
  bool isInitDone = false;

  @override
  Future<bool> init() async {
    try {
      _preferences = await SharedPreferences.getInstance();
      await _preferences!.reload();
      await _initData();
      isInitDone = true;
      return true;
    } catch (e) {
      return false;
    }
  }

  static Future<void> _initData() async {
    if (_preferences!.getString("settings") == null) {
      SettingsService.setDefault();
      await _preferences!.setString("settings", json.encode(SettingsService.toJson()));
    }
    SettingsService.fromJson(json.decode(_preferences!.getString("settings")!));
  }
}
