import 'package:alarm/service/settings_service.dart';
import 'package:collection/collection.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:package_info_plus/package_info_plus.dart';

import '../models/alert_setting_model.dart';
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

      for (var e in SettingsService.subscribeRegions ?? []) {
        FirebaseMessaging.instance.subscribeToTopic(e);
      }

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
  SubscribeAlertModel? model = SettingsService.subscribeRegions?.firstWhereOrNull((e) => e.regionUID == message.data["id"]);

  String alertSong = "";
  String cancelSong = "";
  bool isMuted = false;

  if (model != null) {
    alertSong = model.alarmSoundFilaName;
    cancelSong = model.cancelSoundFilaName;
    isMuted = model.isMuted;
  }

  switch (message.data["noti_type"]) {
    case "isAlert":
      if (isMuted) return;
      await NotificationService.showNotification(
          id: message.data["id"],
          alertType: message.data["type"],
          isAlarm: getValue<bool>(message.data["isAlarm"])!,
          region: message.data["region"] ?? "",
          alarmPath: alertSong,
          cancelPath: cancelSong,
          isSound: isSoundNotification(
            DateTime.tryParse(SettingsService.siledStart ?? ""),
            DateTime.tryParse(SettingsService.siledEnd ?? ""),
          ));

      break;
    case "isUpdate":
      PackageInfo infoApp = await PackageInfo.fromPlatform();
      if (infoApp.version != message.data["newVersion"]) {
        await NotificationService.showUpdateNotification(notificationId: 123321, body: "${message.data["newVersion"]}");
      }
      break;
    case "isTest":
      testNotification(message.data);
      break;
  }
}
