import 'dart:async';
import 'dart:isolate';
import 'dart:ui';

import 'package:alarm/tools/custom_color.dart';
import 'package:alarm/tools/eregion.dart';
// import 'package:background_locator/background_locator.dart';
// import 'package:background_locator/location_dto.dart';
import 'package:background_locator_2/settings/android_settings.dart' as setAd;
import 'package:background_locator_2/background_locator.dart';
import 'package:background_locator_2/location_dto.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'screen/main/main_screen.dart';
import 'service/notification_service.dart';
import 'service/shered_preferences_service.dart';
import 'tools/background_hendler.dart';
import 'tools/nottification_tools.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(statusBarColor: CustomColor.backgroundLight));

  await NotificationService.init();
  await SheredPreferencesService.init();

  await _initFirebaseService();

  await startLocationService();

  // Be sure to add this line if initialize() call happens before runApp()
  WidgetsFlutterBinding.ensureInitialized();
//***************************************** */

//******************************************************* */

  // await AndroidAlarmManager.initialize();
  // final int helloAlarmID = 0;
  // await AndroidAlarmManager.periodic(const Duration(minutes: 1), helloAlarmID, printHello);

  runApp(const MyApp());
}

const String _isolateName = "LocatorIsolate";

void _initLocator() async {
  ReceivePort port = ReceivePort();

  IsolateNameServer.registerPortWithName(port.sendPort, _isolateName);
  port.listen((dynamic data) {
    // do something with data
  });
  await BackgroundLocator.initialize();
}

void calback(LocationDto data) {
  print("${data.latitude} : ${data.longitude}");
}

Future<void> startLocationService() async {
  await BackgroundLocator.registerLocationUpdate(calback,
      //initCallback: LocationCallbackHandler.initCallback,
      // initDataCallback: data,
      // disposeCallback: LocationCallbackHandler.disposeCallback,
      autoStop: false,
      // iosSettings: IOSSettings(accuracy: LocationAccuracy.NAVIGATION, distanceFilter: 0),
      androidSettings: const setAd.AndroidSettings(
          distanceFilter: 0,
          androidNotificationSettings: setAd.AndroidNotificationSettings(
              notificationChannelName: 'Location tracking',
              notificationTitle: 'Start Location Tracking',
              notificationMsg: 'Track location in background',
              notificationBigMsg:
                  'Background location is on to keep the app up-tp-date with your location. This is required for main features to work properly when the app is not running.',
              notificationIcon: '',
              notificationIconColor: Colors.grey)));
}

void _initOnMessage() {
  FirebaseMessaging.onMessage.listen((RemoteMessage event) async {
    print("==========FOREGROUND MESSAGE============");

//************************************************ */

    final DateTime now = DateTime.now();
    await NotificationService.init();
    await SheredPreferencesService.init();

    bool serviceEnabled;
    LocationPermission permission;

    print("ALARMS Trevoga start");

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

    SheredPreferencesService.preferences.setString("subscribeRegion", ERegion.herson.name);

    NotificationService.showUpdateNotification(notificationId: 222, body: "${pos.latitude} : ${pos.longitude}");

//*********************************************** */

    String alertSong = SheredPreferencesService.preferences.getString("alarmSong")!;
    String cancelSong = SheredPreferencesService.preferences.getString("cancelSong")!;

    if (event.data.isNotEmpty && event.data["update"] != null) {
      PackageInfo infoApp = await PackageInfo.fromPlatform();
      if (infoApp.version != event.data["update"]) NotificationService.showUpdateNotification(notificationId: 222, body: "${event.data["update"]}");
      return;
    }

    if (event.data.isNotEmpty && event.data["test"] != null) {
      testNotification(event.data);
      return;
    }
    NotificationService.showNotification(
        event.data["isAlarm"].toLowerCase() == 'true', event.data["region"], alertSong, cancelSong, isSoundNotification());

    print("========================================");
  });
}

Future<void> _initFirebaseService() async {
  await Firebase.initializeApp();
  _initOnMessage();
  FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);
  FirebaseMessaging.instance.subscribeToTopic(SheredPreferencesService.preferences.getString("subscribeRegion")!);
  FirebaseMessaging.instance.subscribeToTopic("update");
  FirebaseMessaging.instance.subscribeToTopic("location");

  if (kDebugMode) {
    await FirebaseMessaging.instance.subscribeToTopic("debug");
  }
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: const MainScreen(),
        theme: ThemeData(
            fontFamily: "Days",
            colorScheme: ThemeData.dark().colorScheme.copyWith(
                  secondary: CustomColor.backgroundLight.withOpacity(0.1),
                )));
  }
}
