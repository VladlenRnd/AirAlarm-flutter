import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'screen/main/main_screen.dart';
import 'service/notification_service.dart';
import 'service/shered_preferences_service.dart';
import 'tools/background_hendler.dart';
import 'tools/custom_color.dart';
import 'tools/nottification_tools.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(statusBarColor: CustomColor.backgroundLight));

  await NotificationService.init();
  await SheredPreferencesService.init();

  await _initFirebaseService();

  runApp(const MyApp());
}

void _initOnMessage() {
  FirebaseMessaging.onMessage.listen((RemoteMessage event) async {
    print("==========FOREGROUND MESSAGE============");

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
