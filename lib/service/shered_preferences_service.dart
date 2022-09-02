import 'package:shared_preferences/shared_preferences.dart';

import '../tools/region/eregion.dart';

class SheredPreferencesService {
  static SharedPreferences? _preferences;

  static SharedPreferences get preferences => _preferences!;

  static Future<void> init() async {
    _preferences = await SharedPreferences.getInstance();

    await _initDefaultData();
  }

  static Future<void> _initDefaultData() async {
    _preferences!.getString("subscribeRegion") ?? await _preferences!.setString("subscribeRegion", ERegion.dnipro.name);
    _preferences!.getString("alarmSong") ?? await _preferences!.setString("alarmSong", "alarm");
    _preferences!.getString("cancelSong") ?? await _preferences!.setString("cancelSong", "cancel_alarm");
    _preferences!.getStringList("siledStart") ?? await _preferences!.setStringList("siledStart", []);
    _preferences!.getStringList("siledEnd") ?? await _preferences!.setStringList("siledEnd", []);
  }
}
