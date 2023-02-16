import '../connection/connection.dart';
import '../connection/response/config_response.dart';

class ConfigRepository {
  ConfigResponse? _config;
  static ConfigRepository get instance => _instance;
  ConfigResponse get config => _config!;

  ConfigRepository._privateConstructor();
  static final ConfigRepository _instance = ConfigRepository._privateConstructor();

  Future<bool> init() async {
    try {
      _config ??= await Connection.getRemoteConfig();
      return true;
    } catch (e) {
      return false;
    }
  }
}
