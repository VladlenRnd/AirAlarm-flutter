import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:package_info_plus/package_info_plus.dart';

import '../tools/nottification_tools.dart';
import 'abstract_service.dart';
import 'notification_service.dart';
import 'shered_preferences_service.dart';

class FirebaseService implements AService {
  FirebaseService._privateConstructor();
  static final FirebaseService _instance = FirebaseService._privateConstructor();
  factory FirebaseService() => _instance;

  @override
  bool isInitDone = false;

  @override
  Future<bool> init() async {
    if (isInitDone) return true;
    try {
      await Firebase.initializeApp();
      _initOnMessage();
      FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
      FirebaseMessaging.instance.subscribeToTopic(SheredPreferencesService.preferences.getString("subscribeRegion")!);
      FirebaseMessaging.instance.subscribeToTopic("update");

      if (kDebugMode) {
        FirebaseMessaging.instance.subscribeToTopic("debug");
      }
      isInitDone = true;
      return true;
    } catch (e) {
      return false;
    }
  }

  static void _initOnMessage() {
    FirebaseMessaging.onMessage.listen((RemoteMessage event) async {
      if (kDebugMode) {
        print("==========FOREGROUND MESSAGE============");
      }

      String alertSong = SheredPreferencesService.preferences.getString("alarmSong")!;
      String cancelSong = SheredPreferencesService.preferences.getString("cancelSong")!;

      if (event.data.isNotEmpty) {
        if (event.data["test"] != null) {
          testNotification(event.data);
          return;
        }

        if (event.data["update"] != null) {
          PackageInfo infoApp = await PackageInfo.fromPlatform();
          if (infoApp.version != event.data["update"]) {
            NotificationService.showUpdateNotification(notificationId: 222, body: "${event.data["update"]}");
          }
          return;
        }

        NotificationService.showNotification(
            event.data["isAlarm"].toLowerCase() == 'true', event.data["region"], alertSong, cancelSong, isSoundNotification());
      }

      if (kDebugMode) {
        print("========================================");
      }
    });
  }
}

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  if (kDebugMode) print("_____________BACKGROUND MESSAGE________________");

  await Firebase.initializeApp();
  await NotificationService().init();

  await SheredPreferencesService().init();
  String alertSong = SheredPreferencesService.preferences.getString("alarmSong")!;
  String cancelSong = SheredPreferencesService.preferences.getString("cancelSong")!;

  if (message.data.isNotEmpty) {
    if (message.data["test"] != null) {
      testNotification(message.data);
      return;
    }
    if (message.data["update"] != null) {
      PackageInfo infoApp = await PackageInfo.fromPlatform();
      if (infoApp.version != message.data["update"]) {
        NotificationService.showUpdateNotification(notificationId: 222, body: "${message.data["update"]}");
      }

      return;
    }

    NotificationService.showNotification(
        message.data["isAlarm"].toLowerCase() == 'true', message.data["region"], alertSong, cancelSong, isSoundNotification());
  }

  if (kDebugMode) print("___________________________________________");
}

void testNotification(Map<String, dynamic> testStr) {
  NotificationService.showTestNotification(notificationId: 111, body: testStr["test"]);
}
