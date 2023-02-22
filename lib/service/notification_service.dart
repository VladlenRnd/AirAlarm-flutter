import 'dart:typed_data';

import 'package:alarm/service/abstract_service.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import '../tools/custom_color.dart';

class NotificationService implements AService {
  //Main notification
  static final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  NotificationService._privateConstructor();
  static final NotificationService _instance = NotificationService._privateConstructor();
  factory NotificationService() => _instance;

  @override
  bool isInitDone = false;

  @override
  Future<bool> init() async {
    if (isInitDone) return true;
    try {
      const InitializationSettings initializationSettings =
          InitializationSettings(android: AndroidInitializationSettings('ic_start_alarm'), macOS: null);
      await _flutterLocalNotificationsPlugin.initialize(initializationSettings);
      isInitDone = true;
      return true;
    } catch (e) {
      return false;
    }

    // final IOSInitializationSettings initializationSettingsIOS = IOSInitializationSettings(
    //   requestSoundPermission: false,
    //   requestBadgePermission: false,
    //   requestAlertPermission: false,
    //   onDidReceiveLocalNotification: onDidReceiveLocalNotification,
    // );
  }

  static Future<bool> requestPermission() async =>
      await _flutterLocalNotificationsPlugin.resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()?.requestPermission() ??
      false;

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
    NotificationDetails platformChannelSpecifics = NotificationDetails(
        android: AndroidNotificationDetails(
      pathSong + isSound.toString(),
      "Воздушная тревога",
      importance: Importance.max,
      sound: RawResourceAndroidNotificationSound(pathSong),
      playSound: pathSong.isNotEmpty ? isSound : false,
      priority: Priority.max,
      subText: "Внимание!",
      icon: "ic_start_alarm",
      color: CustomColor.red,
      visibility: NotificationVisibility.public,
      vibrationPattern: vibrationPattern,
      autoCancel: false,
    ));

    await _flutterLocalNotificationsPlugin.show(notificationId, "Воздушная тревога!", body, platformChannelSpecifics, payload: 'test');
  }

  static Future<void> _showCanceledAlertNotification(
      {String body = "", required int notificationId, required String pathSong, required bool isSound}) async {
    cancelNotification(notificationId: notificationId);
    //Notification seting
    NotificationDetails platformChannelSpecifics = NotificationDetails(
        android: AndroidNotificationDetails(
      pathSong + isSound.toString(),
      "Отмена воздушной тревоги",
      importance: Importance.max,
      sound: RawResourceAndroidNotificationSound(pathSong),
      playSound: pathSong.isNotEmpty ? isSound : false,
      priority: Priority.max,
      enableLights: true,
      subText: "Внимание!",
      autoCancel: true,
      color: CustomColor.green,
      visibility: NotificationVisibility.public,
      timeoutAfter: 120000,
      icon: "ic_cancel_alarm",
    ));

    await _flutterLocalNotificationsPlugin.show(notificationId + 100, "Отмена воздушной тревоги", body, platformChannelSpecifics, payload: 'test');
  }

  static Future<void> showUpdateNotification({String body = "", required int notificationId}) async {
    cancelNotification(notificationId: notificationId);
    //Notification seting
    NotificationDetails platformChannelSpecifics = const NotificationDetails(
        android: AndroidNotificationDetails(
      "3",
      "Update notification",
      importance: Importance.max,
      playSound: true,
      sound: RawResourceAndroidNotificationSound("update"),
      icon: "ic_update",
      priority: Priority.max,
      enableLights: true,
      color: CustomColor.systemSecondary,
      autoCancel: true,
      visibility: NotificationVisibility.public,
    ));

    await _flutterLocalNotificationsPlugin.show(222, "Доступна новая версия! $body", "Доступно обновление для приложения", platformChannelSpecifics,
        payload: 'update');
  }

  static Future<void> showTestNotification({String body = "", required int notificationId}) async {
    cancelNotification(notificationId: notificationId);
    //Notification seting
    NotificationDetails platformChannelSpecifics = const NotificationDetails(
        android: AndroidNotificationDetails(
      "234",
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

    await _flutterLocalNotificationsPlugin.show(notificationId + 100, "Тестовое оповещение", body, platformChannelSpecifics, payload: 'test');
  }

  static void cancelNotification({required int notificationId}) async {
    await _flutterLocalNotificationsPlugin.cancel(notificationId);
  }
}
