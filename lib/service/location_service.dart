import 'dart:async';
import 'dart:ui';

import 'package:alarm/service/abstract_service.dart';
import 'package:alarm/service/notification_service.dart';
import 'package:alarm/tools/region/region_title_tools.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';

import '../tools/region/eregion.dart';
import 'shered_preferences_service.dart';

FlutterBackgroundService? bservice;

class LocationService implements AService {
  static late final FlutterBackgroundService _service;

  LocationService._privateConstructor();
  static final LocationService _instance = LocationService._privateConstructor();
  factory LocationService() => _instance;

  @override
  bool isInitDone = false;

  @override
  Future<bool> init() async {
    if (isInitDone) return true;
    try {
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
      isInitDone = true;
      return true;
    } catch (e) {
      return false;
    }
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
  }

  static void gotoSettingLocation() {
    Geolocator.openAppSettings();
  }

  static Future<bool> _changeLocation(double latitude, double longitude) async {
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(latitude, longitude, localeIdentifier: "ru_RU");
      if (placemarks.isNotEmpty) {
        ERegion? region = RegionTitleTools.getRegionByGeolocation(placemarks[0].administrativeArea ?? "", placemarks[0].locality ?? "");
        if (region != null) {
          ERegion subscribeRegion = RegionTitleTools.getEnumByEnumName(SheredPreferencesService.preferences.getString("subscribeRegion")!);
          if (subscribeRegion != region) {
            await FirebaseMessaging.instance.unsubscribeFromTopic(subscribeRegion.name);
            await SheredPreferencesService.preferences.setString("subscribeRegion", region.name);
            await FirebaseMessaging.instance.subscribeToTopic(region.name);
            return true;
          }
        } else {
          return false;
        }
      }
      return false;
    } catch (e) {
      return false;
    }
  }

  static Future<void> _location(ServiceInstance service) async {
    if (!await Geolocator.isLocationServiceEnabled()) {
      return Future.error('Location services are disabled.');
    }

    Position pos = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    _changeLocation(pos.latitude, pos.longitude);

    Timer.periodic(const Duration(minutes: 15), (timer) async {
      Position pos = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
      _changeLocation(pos.latitude, pos.longitude);
    });
  }

  @pragma('vm:entry-point')
  static void _onStart(ServiceInstance service) async {
    DartPluginRegistrant.ensureInitialized();
    await NotificationService().init();
    await SheredPreferencesService().init();
    await Firebase.initializeApp();
    _location(service);
    service.on('stopService').listen((event) {
      service.stopSelf();
    });
  }
}
