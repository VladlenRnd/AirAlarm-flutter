import 'package:shared_preferences/shared_preferences.dart';

import '../screen/main/tools/eregion.dart';

class SheredPreferencesService {
  static late final SharedPreferences _preferences;

  static SharedPreferences get preferences => _preferences;

  static Future<void> init() async {
    _preferences = await SharedPreferences.getInstance();
    _initDefaultData();
  }

  static void _initDefaultData() {
    _preferences.getBool("backgroundSercive") ?? SheredPreferencesService.preferences.setBool("backgroundSercive", true);
    _preferences.getStringList("subscribe") ?? _preferences.setStringList("subscribe", [ERegion.dnipro.name]);
  }
}
