import 'dart:async';
import 'dart:ui';

import 'package:alarm/service/abstract_service.dart';
import 'package:alarm/service/notification_service.dart';
import 'package:alarm/service/settings_service.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';

import 'shered_preferences_service.dart';

FlutterBackgroundService? bservice;

@pragma('vm:entry-point')
class LocationService implements AService {
  static late final FlutterBackgroundService _service;

  LocationService._privateConstructor();
  static final LocationService _instance = LocationService._privateConstructor();
  factory LocationService() => _instance;
  static final Geocoding _geocoding = Geocoding();

  @override
  bool isInitDone = false;

  static Future<bool> _initConfig({required bool isBootStart, required FlutterBackgroundService service}) async {
    return await service.configure(
      androidConfiguration: AndroidConfiguration(
        // this will executed when app is in foreground or background in separated isolate
        onStart: _onStart,
        initialNotificationContent: "Приложение автоматически определяет область",
        initialNotificationTitle: "Автопоиск области",

        // auto start service
        autoStart: false, // await FlutterBackgroundService().isRunning(),
        isForegroundMode: true,
        autoStartOnBoot: isBootStart,
      ),
      iosConfiguration: IosConfiguration(
        // auto start service
        autoStart: false,

        // this will executed when app is in foreground in separated isolate
        onForeground: ((service) => {}),

        // you have to enable background fetch capability on xcode project
        onBackground: (service) => true,
      ),
    );
  }

  @override
  Future<bool> init() async {
    if (isInitDone) return true;
    _service = FlutterBackgroundService();
    isInitDone = true;
    return true;
  }

  static void _subscribeServiceListeners() {
    _service.on('updateLocation').listen((event) async {
      await SheredPreferencesService().init();
    });

    _service.on('locationIsDisabled').listen((event) async {
      disabledAutoLocation();
      SettingsService.setParametr(isAutoSearchParam: false);
    });
  }

  static Future<bool> enableAutoLocation() async {
    if (!await Geolocator.isLocationServiceEnabled()) {
      return false;
    }

    _subscribeServiceListeners();

    await _initConfig(service: _service, isBootStart: true);

    await _service.startService();
    return true;
  }

  static void disabledAutoLocation() async {
    FlutterBackgroundService().invoke("stopService");
    await _initConfig(service: _service, isBootStart: false);
  }

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
      List<Placemark> placemarks = await _geocoding.placemarkFromCoordinates(latitude, longitude);
      if (placemarks.isNotEmpty) {
        String? regionUID = _getRegionByGeolocation(placemarks[0].administrativeArea ?? "", placemarks[0].locality ?? "");
        if (regionUID != null) {
          if (SettingsService.subscribeRegions! != regionUID) {
            //  await FirebaseMessaging.instance.unsubscribeFromTopic(SettingsService.subscribeRegions!);
          }

          await FirebaseMessaging.instance.subscribeToTopic(regionUID);
          // await SettingsService.setParametr(subscribeRegionParam: regionUID);

          return true;
        } else {
          return false;
        }
      }
      return false;
    } catch (e) {
      return false;
    }
  }

  @pragma('vm:entry-point')
  static String? _getRegionByGeolocation(String address, String locality) {
    String findBy = address.isNotEmpty ? address : locality;

    switch (findBy) {
      case "Luhans'ka oblast":
      case "Luhansk Oblast":
      case "Луганск":
      case "Луганськ":
        return "16";

      case "Donets'ka oblast":
      case "Donetsk Oblast":
      case "Донецьк":
      case "Донецк":
        return "28";

      case "Kharkivs'ka oblast":
      case "Kharkiv oblast":
        return "22";

      case "Dnipropetrovs'ka oblast":
      case "Dnipropetrovsk Oblast":
        return "9";

      case "Zaporiz'ka oblast":
      case "Zaporizhia Oblast":
        return "12";

      case "Sums'ka oblast":
      case "Sumy oblast":
        return "20";

      case "Poltavs'ka oblast":
      case "Poltava oblast":
        return "19";

      case "Khersons'ka oblast":
      case "Kherson oblast":
        return "23";

      case "Chernihivs'ka oblast":
      case "Chernihiv oblast":
        return "25";

      case "Kyivs'ka oblast":
      case "Kyiv Oblast":
      case "Kyiv":
      case "Киев":
        return "14";

      case "Cherkas'ka oblast":
      case "Cherkasy Oblast":
        return "24";

      case "Kirovohrads'ka oblast":
      case "Kirovohrad Oblast":
        return "15";

      case "Mykolaivs'ka oblast":
      case "Mykolaiv oblast":
        return "17";

      case "Zhytomyrs'ka oblast":
      case "Zhytomyr oblast":
        return "10";

      case "Vinnyts'ka oblast":
      case "Vinnytsia Oblast":
        return "4";

      case "Odes'ka oblast":
      case "Odesa Oblast":
        return "18";

      case "Rivnens'ka oblast":
      case "Rivne Oblast":
        return "5";

      case "Khmel'nyts'ka oblast":
      case "Khmelnytskyi Oblast":
        return "3";

      case "Ternopil's'ka oblast":
      case "Ternopil Oblast":
        return "21";

      case "Ivano-Frankivs'ka oblast":
      case "Ivano-Frankivsk Oblast":
        return "13";

      case "Chernivets'ka oblast":
      case "Chernivtsi Oblast":
        return "26";

      case "Zakarpattia Oblast":
      case "Zakarpats'ka oblast":
        return "11";

      case "Lviv Oblast":
      case "L'vivs'ka oblast":
        return "27";

      case "Volyns'ka oblast":
      case "Volyn Oblast":
        return "8";

      default:
        return null;
    }
  }

  static Future<bool> setRegionByLocation() async {
    if (await Geolocator.isLocationServiceEnabled()) {
      Position pos = await Geolocator.getCurrentPosition();

      print("POS : ${pos.latitude} - ${pos.longitude}");
      return _changeLocation(pos.latitude, pos.longitude);
    }
    return Future.error('Location services are disabled.');
  }

  static Future<void> _location(ServiceInstance service) async {
    if (!await Geolocator.isLocationServiceEnabled()) {
      service.invoke("locationIsDisabled");
      return Future.error('Location services are disabled.');
    }

    if (await setRegionByLocation()) {
      service.invoke("updateLocation");
    }

    Timer.periodic(const Duration(minutes: 15), (timer) async {
      try {
        if (await setRegionByLocation()) {
          service.invoke("updateLocation");
        }
      } catch (e) {
        service.invoke("locationIsDisabled");
      }
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
