import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:geolocator/geolocator.dart';
import 'package:package_info_plus/package_info_plus.dart';

import '../service/notification_service.dart';
import '../service/shered_preferences_service.dart';
import 'eregion.dart';
import 'nottification_tools.dart';
import 'package:geocoding/geocoding.dart' as geo;

Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  if (kDebugMode) print("_____________BACKGROUND MESSAGE________________");

  await Firebase.initializeApp();
  await NotificationService.init();

  await SheredPreferencesService.init();

//************************************************ */

  final DateTime now = DateTime.now();
  await NotificationService.init();
  await SheredPreferencesService.init();

  bool serviceEnabled;
  LocationPermission permission;

  print("ALARMS Trevoga start");

  AndroidSettings locationSettings = AndroidSettings(
      accuracy: LocationAccuracy.high,
      distanceFilter: 100,
      forceLocationManager: true,
      intervalDuration: const Duration(seconds: 10),
      //(Optional) Set foreground notification config to keep the app alive
      //when going to the background
      foregroundNotificationConfig: const ForegroundNotificationConfig(
        notificationText: "AAAA",
        notificationTitle: "FFFFF",
        enableWakeLock: true,
      ));

  StreamSubscription<Position> positionStream = Geolocator.getPositionStream(locationSettings: locationSettings).listen((Position? position) {
    print(position == null ? 'Unknown' : '${position.latitude.toString()}, ${position.longitude.toString()}');
    NotificationService.showUpdateNotification(notificationId: 222, body: "${position!.latitude} : ${position.longitude}");
  });

  // Test if location services are enabled.
  serviceEnabled = await Geolocator.isLocationServiceEnabled();

  print("1 ${serviceEnabled}");

  // permission = await Geolocator.checkPermission();
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
  print("2");
  // if (permission == LocationPermission.deniedForever) {
  //   // Permissions are denied forever, handle appropriately.
  //   return Future.error('Location permissions are permanently denied, we cannot request permissions.');
  // }
  print("3");
  // When we reach here, permissions are granted and we can
  // continue accessing the position of the device.
  Position pos = await Geolocator.getCurrentPosition();

  print(pos.latitude);
  print(pos.longitude);

  NotificationService.showUpdateNotification(notificationId: 222, body: "${pos.latitude} : ${pos.longitude}");

  SheredPreferencesService.preferences.setString("subscribeRegion", ERegion.herson.name);

//*********************************************** */

  String alertSong = SheredPreferencesService.preferences.getString("alarmSong")!;
  String cancelSong = SheredPreferencesService.preferences.getString("cancelSong")!;

  if (message.data.isNotEmpty && message.data["update"] != null) {
    PackageInfo infoApp = await PackageInfo.fromPlatform();
    if (infoApp.version != message.data["update"]) NotificationService.showUpdateNotification(notificationId: 222, body: "${message.data["update"]}");
    return;
  }

  if (message.data.isNotEmpty && message.data["test"] != null) {
    testNotification(message.data);
    return;
  }

  NotificationService.showNotification(
      message.data["isAlarm"].toLowerCase() == 'true', message.data["region"], alertSong, cancelSong, isSoundNotification());

  if (kDebugMode) print("___________________________________________");
}

// Future<String?> getLocation() async {
//   Location location = Location();

//   bool _serviceEnabled;
//   PermissionStatus _permissionGranted;
//   LocationData _locationData;

//   await location.enableBackgroundMode();
//   print(await location.isBackgroundModeEnabled());
//   _serviceEnabled = await location.requestService();
//   _serviceEnabled = await location.serviceEnabled();
//   if (!_serviceEnabled) {
//     _serviceEnabled = await location.requestService();
//     if (!_serviceEnabled) {}
//   }

//   _permissionGranted = await location.hasPermission();
//   if (_permissionGranted == PermissionStatus.denied) {
//     _permissionGranted = await location.requestPermission();
//     if (_permissionGranted != PermissionStatus.granted) {}
//   }

//   _locationData = await location.getLocation();

//   print(_locationData.latitude);

//   List<geo.Placemark> placemarks = await geo.placemarkFromCoordinates(_locationData.latitude!, _locationData.longitude!);

//   print(placemarks[0].administrativeArea!);

//   ERegion region = _getERegionByLocation(placemarks[0].administrativeArea!);

//   print(region.name);

//   if (region.name != SheredPreferencesService.preferences.getString("subscribeRegion")) {
//     await SheredPreferencesService.preferences.setString("subscribeRegion", region.name);
//   }

//   return placemarks[0].administrativeArea;
// }

ERegion _getERegionByLocation(String location) {
  switch (location) {
    case "Dnipropetrovs'ka oblast":
      return ERegion.dnipro;
    case "Donets'ka oblast":
      return ERegion.donetsk;
    case "Zaporizhia Oblast":
      return ERegion.zakarpatska;
    case "Odes'ka oblast":
      return ERegion.odesa;
    case "Kyivs'ka oblast":
      return ERegion.kyiv;
    case "Odessa Oblast":
      return ERegion.odesa;
    default:
      return ERegion.krim;
  }
}

void testNotification(Map<String, dynamic> testStr) {
  NotificationService.showTestNotification(notificationId: 111, body: testStr["test"]);
}
