import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:package_info_plus/package_info_plus.dart';

import '../service/notification_service.dart';
import '../service/shered_preferences_service.dart';
import 'nottification_tools.dart';

Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  if (kDebugMode) print("_____________BACKGROUND MESSAGE________________");

  await Firebase.initializeApp();
  await NotificationService.init();

  await SheredPreferencesService.init();
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
