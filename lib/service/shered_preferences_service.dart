import 'package:shared_preferences/shared_preferences.dart';

import '../tools/eregion.dart';

class SheredPreferencesService {
  static late final SharedPreferences _preferences;

  static SharedPreferences get preferences => _preferences;

  static Future<void> init() async {
    _preferences = await SharedPreferences.getInstance();
    await _initDefaultData();
  }

  static Future<void> _initDefaultData() async {
    _preferences.getStringList("subscribe") ?? await _preferences.setStringList("subscribe", [ERegion.dnipro.name]);
  }
}
