import 'package:alarm/service/abstract_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../tools/region/eregion.dart';

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
    if (isInitDone) return true;
    try {
      _preferences = await SharedPreferences.getInstance();
      await _initDefaultData();
      isInitDone = true;
      return true;
    } catch (e) {
      return false;
    }
  }

  static Future<void> _initDefaultData() async {
    _preferences!.getString("subscribeRegion") ?? await _preferences!.setString("subscribeRegion", ERegion.dnipro.name);
    _preferences!.getString("alarmSong") ?? await _preferences!.setString("alarmSong", "alarm");
    _preferences!.getString("cancelSong") ?? await _preferences!.setString("cancelSong", "cancel_alarm");
    _preferences!.getStringList("siledStart") ?? await _preferences!.setStringList("siledStart", []);
    _preferences!.getStringList("siledEnd") ?? await _preferences!.setStringList("siledEnd", []);
    _preferences!.getBool("isAutoSearch") ?? await _preferences!.setBool("isAutoSearch", false);
    _preferences!.getInt("sort") ?? await _preferences!.setInt("sort", 0);
  }
}
