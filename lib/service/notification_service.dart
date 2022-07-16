import 'dart:typed_data';

import 'package:alarm/tools/custom_color.dart';
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

  static Future<void> showNotification(bool isAlarm, String region, String alarmPath, String cancelPath, bool isSound) async {
    isAlarm
        ? await _showAlertNotification(notificationId: 1, body: region, pathSong: alarmPath, isSound: isSound)
        : await _showCanceledAlertNotification(notificationId: 1, body: region, pathSong: cancelPath, isSound: isSound);
  }

  static Future<void> _showAlertNotification({String body = "", required int notificationId, required String pathSong, required bool isSound}) async {
    cancelNotification(notificationId: notificationId + 100);

    final Int64List vibrationPattern = Int64List(6);
    vibrationPattern[0] = 0;
    vibrationPattern[1] = 1500;
    vibrationPattern[2] = 250;
    vibrationPattern[3] = 1500;
    vibrationPattern[4] = 250;
    vibrationPattern[5] = 1500;

    //Notification seting
    NotificationDetails _platformChannelSpecifics = NotificationDetails(
        android: AndroidNotificationDetails(
      pathSong + isSound.toString(),
      "Воздушная тревога",
      fullScreenIntent: true,
      importance: Importance.max,
      sound: RawResourceAndroidNotificationSound(pathSong),
      playSound: isSound,
      priority: Priority.max,
      subText: "Внимание!",
      icon: "ic_start_alarm",
      color: CustomColor.red,
      visibility: NotificationVisibility.public,
      vibrationPattern: vibrationPattern,
      autoCancel: false,
    ));

    await _flutterLocalNotificationsPlugin.show(notificationId, "Воздушная тревога!", body, _platformChannelSpecifics, payload: 'test');
  }

  static Future<void> _showCanceledAlertNotification(
      {String body = "", required int notificationId, required String pathSong, required bool isSound}) async {
    cancelNotification(notificationId: notificationId);
    //Notification seting
    NotificationDetails _platformChannelSpecifics = NotificationDetails(
        android: AndroidNotificationDetails(
      pathSong + isSound.toString(),
      "Отмена воздушной тревоги",
      importance: Importance.max,
      sound: RawResourceAndroidNotificationSound(pathSong),
      playSound: isSound,
      priority: Priority.max,
      enableLights: true,
      subText: "Внимание!",
      autoCancel: true,
      color: CustomColor.green,
      visibility: NotificationVisibility.public,
      timeoutAfter: 120000,
      icon: "ic_cancel_alarm",
    ));

    await _flutterLocalNotificationsPlugin.show(notificationId + 100, "Отмена воздушной тревоги", body, _platformChannelSpecifics, payload: 'test');
  }

  static Future<void> showTestNotification({String body = "", required int notificationId}) async {
    cancelNotification(notificationId: notificationId);
    //Notification seting
    NotificationDetails _platformChannelSpecifics = const NotificationDetails(
        android: AndroidNotificationDetails(
      "2",
      "Тестовое оповещение",
      fullScreenIntent: true,
      importance: Importance.max,
      playSound: true,
      priority: Priority.max,
      enableLights: true,
      autoCancel: true,
      visibility: NotificationVisibility.public,
      timeoutAfter: 10000,
    ));

    await _flutterLocalNotificationsPlugin.show(notificationId + 100, "Тестовое оповещение", body, _platformChannelSpecifics, payload: 'test');
  }

  static void cancelNotification({required int notificationId}) async {
    await _flutterLocalNotificationsPlugin.cancel(notificationId);
  }

  static void _selectNotification(String? payload) {
    //TODO Bitch
  }
}
