import 'package:alarm/service/permission_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../screen/main/tools/eregion.dart';

class SheredPreferencesService {
  static late final SharedPreferences _preferences;

  static SharedPreferences get preferences => _preferences;

  static Future<void> init() async {
    _preferences = await SharedPreferences.getInstance();
    await _initDefaultData();
  }

  static Future<void> _initDefaultData() async {
    _preferences.getBool("backgroundSercive") ?? await _preferences.setBool("backgroundSercive", await PermissonService.permissionBattary());

    _preferences.getStringList("subscribe") ?? await _preferences.setStringList("subscribe", [ERegion.dnipro.name]);
  }
}
