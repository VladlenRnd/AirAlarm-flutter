import '../connection/connection.dart';
import '../connection/response/config_response.dart';

class ConfigRepository {
  late final ConfigResponse _config;
  static ConfigRepository get instance => _instance;
  ConfigResponse get config => _config;

  ConfigRepository._privateConstructor();

  static final ConfigRepository _instance = ConfigRepository._privateConstructor();

  Future<void> init() async {
    _config = await Conectrion.getRemoteConfig();
  }
}
