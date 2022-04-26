import 'package:permission_handler/permission_handler.dart';

class PermissonService {
  static Future<bool> permissionBattary() async {
    await Permission.ignoreBatteryOptimizations.request();
    return await Permission.ignoreBatteryOptimizations.status.isGranted;
  }
}
