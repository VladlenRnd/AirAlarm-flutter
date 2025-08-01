import 'dart:convert';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'abstract_service.dart';
import 'shered_preferences_service.dart';

class FirebaseConfigService implements AService {
  @override
  bool isInitDone = false;

  static final FirebaseRemoteConfig _remoteConfig = FirebaseRemoteConfig.instance;

  @override
  Future<bool> init() async {
    isInitDone = true;

    await _remoteConfig.setConfigSettings(RemoteConfigSettings(
      fetchTimeout: const Duration(seconds: 25),
      minimumFetchInterval: const Duration(seconds: 1),
    ));
    _remoteConfig.fetchAndActivate();

    if (_remoteConfig.lastFetchStatus == RemoteConfigFetchStatus.success) {
      Config.init();
    } else {
      Config.getSaveConfig();
    }

    try {
      return true;
    } catch (e) {
      return false;
    }
  }

  static String getString(EConfigKey key) => _remoteConfig.getString(key.name);
  static bool getBool(EConfigKey key) => _remoteConfig.getBool(key.name);
  static double getDouble(EConfigKey key) => _remoteConfig.getDouble(key.name);
  static int getInt(EConfigKey key) => _remoteConfig.getInt(key.name);
  static RemoteConfigFetchStatus get lastFetchStatus => _remoteConfig.lastFetchStatus;
}

enum EConfigKey {
  endWarDate,
  isTechnicalWork,
  isWar,
  startWarDate,
  baseUrl,
  watNew,
}

class Config {
  static DateTime? endWarDate;
  static bool? isTechnicalWork;
  static bool? isWar;
  static DateTime? startWarDate;
  static String? baseUrl;
  static String? watNew;

  Config.init() {
    isTechnicalWork = FirebaseConfigService.getBool(EConfigKey.isTechnicalWork);
    isWar = FirebaseConfigService.getBool(EConfigKey.isWar);
    baseUrl = FirebaseConfigService.getString(EConfigKey.baseUrl);
    watNew = FirebaseConfigService.getString(EConfigKey.watNew);
    startWarDate = DateTime.tryParse(FirebaseConfigService.getString(EConfigKey.startWarDate));
    endWarDate = DateTime.tryParse(FirebaseConfigService.getString(EConfigKey.endWarDate));

    SheredPreferencesService.preferences.setString("saveConfig", toJson());
  }

  Config.getSaveConfig() {
    String? saveConfig = SheredPreferencesService.preferences.getString("saveConfig");

    if (saveConfig != null) {
      Map<String, dynamic> mapCfg = jsonDecode(saveConfig);
      isTechnicalWork = mapCfg["isTechnicalWork"];
      isWar = mapCfg["isWar"];
      baseUrl = mapCfg["baseUrl"];
      watNew = mapCfg["watNew"];
      startWarDate = DateTime.tryParse(mapCfg["startWarDate"]);
      endWarDate = DateTime.tryParse(mapCfg["endWarDate"]);
    } else {
      isTechnicalWork = false;
      isWar = true;
      baseUrl = "http://192.168.0.111:3100";
      watNew = "";
      startWarDate = DateTime.parse("2022-02-24 00:00:00.000Z");
      endWarDate = null;
    }
  }

  static String toJson() {
    final map = <String, dynamic>{
      'isTechnicalWork': isTechnicalWork,
      'isWar': isWar,
      'baseUrl': baseUrl,
      'watNew': watNew,
      'startWarDate': startWarDate?.toIso8601String(),
      'endWarDate': endWarDate?.toIso8601String(),
    };

    return jsonEncode(map);
  }
}
