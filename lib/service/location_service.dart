import 'dart:async';
import 'dart:ui';

import 'package:alarm/service/notification_service.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:geolocator/geolocator.dart';

FlutterBackgroundService? bservice;

class LocationService {
  static late final FlutterBackgroundService _service;

  static Future<void> init() async {
    _service = FlutterBackgroundService();

    await _service.configure(
      androidConfiguration: AndroidConfiguration(
        // this will executed when app is in foreground or background in separated isolate
        onStart: _onStart,
        initialNotificationContent: "",
        initialNotificationTitle: "Автоопределение области запущено",

        // auto start service
        autoStart: await FlutterBackgroundService().isRunning(),
        isForegroundMode: true,
      ),
      iosConfiguration: IosConfiguration(
        // auto start service
        autoStart: true,

        // this will executed when app is in foreground in separated isolate
        onForeground: ((service) => {}),

        // you have to enable background fetch capability on xcode project
        onBackground: (service) => true,
      ),
    );
  }

  static Future<bool> enableAutoLocation() async => await _service.startService();

  static void disabledAutoLocation() => FlutterBackgroundService().invoke("stopService");

  static Future<bool> requestingPermission() async {
    switch (await Geolocator.requestPermission()) {
      case LocationPermission.denied:
      case LocationPermission.deniedForever:
      case LocationPermission.whileInUse:
      case LocationPermission.unableToDetermine:
        return false;
      case LocationPermission.always:
        return true;
    }
  }

  static Future<bool> checkPermission() async {
    LocationPermission permission;
    permission = await Geolocator.checkPermission();

    switch (permission) {
      case LocationPermission.denied:
      case LocationPermission.deniedForever:
      case LocationPermission.whileInUse:
      case LocationPermission.unableToDetermine:
        return false;
      case LocationPermission.always:
        return true;
    }
    // if (permission == LocationPermission.denied) {
    //   permission = await Geolocator.requestPermission();
    //   if (permission == LocationPermission.denied) {
    //     // Permissions are denied, next time you could try
    //     // requesting permissions again (this is also where
    //     // Android's shouldShowRequestPermissionRationale
    //     // returned true. According to Android guidelines
    //     // your App should show an explanatory UI now.
    //     return Future.error('Location permissions are denied');
    //   }
    // }

    // if (permission == LocationPermission.deniedForever) {
    //   // Permissions are denied forever, handle appropriately.
    //   return false;
    // }
  }

  static void gotoSettingLocation() {
    Geolocator.openAppSettings();
  }

  static Future<void> _location(ServiceInstance service) async {
    bool serviceEnabled;
    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }

    Timer.periodic(const Duration(seconds: 15), (timer) async {
      Position pos = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
      print("STREAM");
      print(pos.latitude);
      print(pos.longitude);
      service.invoke("getPosition", {"position": pos});
    });

    // Geolocator.getPositionStream(
    //     locationSettings: const LocationSettings(
    //   accuracy: LocationAccuracy.high,
    //   distanceFilter: 1000 * 20,
    // )).listen((Position pos) {
    //   print("STREAM");
    //   print(pos.latitude);
    //   print(pos.longitude);
    // });
  }

  @pragma('vm:entry-point')
  static void _onStart(ServiceInstance service) async {
    DartPluginRegistrant.ensureInitialized();
    await NotificationService.init();
    _location(service);
    service.on('stopService').listen((event) {
      service.stopSelf();
    });
  }
}
