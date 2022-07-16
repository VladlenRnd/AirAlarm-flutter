import 'dart:async';

import 'package:alarm/tools/custom_color.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'screen/main/main_screen.dart';
import 'service/notification_service.dart';
import 'service/shered_preferences_service.dart';
import 'tools/background_hendler.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(statusBarColor: CustomColor.backgroundLight));

  await NotificationService.init();
  await SheredPreferencesService.init();

  await _initFirebaseService();

  runApp(const MyApp());
}

Future<void> _initFirebaseService() async {
  await Firebase.initializeApp();
  FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);
  FirebaseMessaging.instance.subscribeToTopic(SheredPreferencesService.preferences.getString("subscribeRegion")!);

  if (kDebugMode) {
    FirebaseMessaging.instance.subscribeToTopic("debug");
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
