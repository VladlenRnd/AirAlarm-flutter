import 'dart:typed_data';

import 'package:alarm/screen/main/tools/color.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationService {
  //Main notification
  static final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  static Future<void> init() async {
    const InitializationSettings initializationSettings =
        InitializationSettings(android: AndroidInitializationSettings('ic_start_alarm'), macOS: null);
    await _flutterLocalNotificationsPlugin.initialize(initializationSettings, onSelectNotification: _selectNotification);

    // final IOSInitializationSettings initializationSettingsIOS = IOSInitializationSettings(
    //   requestSoundPermission: false,
    //   requestBadgePermission: false,
    //   requestAlertPermission: false,
    //   onDidReceiveLocalNotification: onDidReceiveLocalNotification,
    // );
  }

  static void cancelNotification({required int notificationId}) async {
    await _flutterLocalNotificationsPlugin.cancel(notificationId);
  }

  static Future<void> showCanceledAlertNotification({String body = "", required int notificationId}) async {
    cancelNotification(notificationId: notificationId);
    //Notification seting
    NotificationDetails _platformChannelSpecifics = NotificationDetails(
        android: AndroidNotificationDetails(
      "1",
      "Отмена воздушной тревоги",
      fullScreenIntent: true,
      importance: Importance.high,
      sound: const RawResourceAndroidNotificationSound("alarm"),
      playSound: false,
      priority: Priority.high,
      enableLights: true,
      subText: "Внимание!",
      autoCancel: true,
      color: CustomColor.green,
      timeoutAfter: 30000,
      icon: "ic_cancel_alarm",
    ));

    await _flutterLocalNotificationsPlugin.show(notificationId + 100, "Отмена воздушной тревоги", body, _platformChannelSpecifics, payload: 'test');
  }

  static Future<void> showAlertNotification({String body = "", required int notificationId}) async {
    cancelNotification(notificationId: notificationId + 100);
    final Int64List vibrationPattern = Int64List(6);
    vibrationPattern[0] = 0;
    vibrationPattern[1] = 1500;
    vibrationPattern[2] = 250;
    vibrationPattern[3] = 1500;
    vibrationPattern[4] = 250;
    vibrationPattern[5] = 1500;

    //

    //Notification seting
    NotificationDetails _platformChannelSpecifics = NotificationDetails(
        android: AndroidNotificationDetails(
      "0",
      "Воздушная тревога",
      fullScreenIntent: true,
      importance: Importance.high,
      sound: const RawResourceAndroidNotificationSound("alarm"),
      playSound: true,
      priority: Priority.high,
      subText: "Внимание!",
      icon: "ic_start_alarm",
      color: CustomColor.red,
      vibrationPattern: vibrationPattern,
      autoCancel: false,
    ));

    await _flutterLocalNotificationsPlugin.show(notificationId, "Воздушная тревога!", body, _platformChannelSpecifics, payload: 'test');
  }

  static void _selectNotification(String? payload) {
    //TODO Bitch
  }
}
