import 'package:alarm/service/settings_service.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:package_info_plus/package_info_plus.dart';

import '../tools/notification_tools.dart';
import 'abstract_service.dart';
import 'notification_service.dart';
import 'shered_preferences_service.dart';

class FirebaseNotificationService implements AService {
  FirebaseNotificationService._privateConstructor();
  static final FirebaseNotificationService _instance = FirebaseNotificationService._privateConstructor();
  factory FirebaseNotificationService() => _instance;

  @override
  bool isInitDone = false;

  @override
  Future<bool> init() async {
    if (isInitDone) return true;
    try {
      await Firebase.initializeApp();
      _initOnMessage();
      FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
      FirebaseMessaging.instance.subscribeToTopic(SettingsService.subscribeRegion!);
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
    FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
      if (kDebugMode) print("========== FOREGROUND MESSAGE ============");
      _messageCallBack(message);
    });
  }
}

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  if (kDebugMode) print("_____________BACKGROUND MESSAGE________________");

  await Firebase.initializeApp();
  await NotificationService().init();
  await SheredPreferencesService().init();
  _messageCallBack(message);
}

void testNotification(Map<String, dynamic> testStr) {
  NotificationService.showTestNotification(notificationId: 111, body: testStr["testStr"] ?? "testStr NULL");
}

T? getValue<T>(dynamic data) {
  if (data == null) return null;

  if (T == String) return data.toString() as T;
  if (T == int) return int.tryParse(data.toString()) as T?;
  if (T == double) return double.tryParse(data.toString()) as T?;
  if (T == bool) {
    final value = data.toString().toLowerCase();
    return (value == 'true' || value == '1') as T;
  }

  return null;
}

//============Message logic ======================
Future<void> _messageCallBack(RemoteMessage message) async {
  String alertSong = SettingsService.alarmSoundFilaName!;
  String cancelSong = SettingsService.cancelSoundFilaName!;

  if (message.data.isNotEmpty) {
    if (getValue<bool>(message.data["isTest"]) ?? false) {
      testNotification(message.data);
      return;
    }

    if (getValue<bool>(message.data["isUpdate"]) ?? false) {
      PackageInfo infoApp = await PackageInfo.fromPlatform();
      if (infoApp.version != message.data["newVersion"]) {
        NotificationService.showUpdateNotification(notificationId: 222, body: "${message.data["newVersion"]}");
      }
      return;
    }

    if (message.data["isAlarm"] != null) {
      NotificationService.showNotification(
          getValue<bool>(message.data["isAlarm"])!,
          message.data["region"] ?? "",
          alertSong,
          cancelSong,
          isSoundNotification(
            DateTime.tryParse(SettingsService.siledStart ?? ""),
            DateTime.tryParse(SettingsService.siledEnd ?? ""),
          ));
    }
  }
}
