import 'dart:typed_data';

import 'package:alarm/models/region_model.dart';
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
      await _flutterLocalNotificationsPlugin.initialize(settings: initializationSettings);
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
      await _flutterLocalNotificationsPlugin
          .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
          ?.requestNotificationsPermission() ??
      false;

  static Future<void> showNotification({
    required String id,
    required String alertType,
    required bool isAlarm,
    required String region,
    required String alarmPath,
    required String cancelPath,
    required bool isSound,
  }) async {
    if (isAlarm) {
      await _showAlertNotification(
        notificationId: int.tryParse(id) ?? 1,
        body: region,
        pathSong: alarmPath,
        isSound: isSound,
        type: EAlertType.getEnumByType(type: alertType),
      );
    } else {
      await _showCanceledAlertNotification(
        notificationId: int.tryParse(id) ?? 1,
        body: region,
        pathSong: cancelPath,
        isSound: isSound,
      );
    }
  }

  static Future<void> _showAlertNotification({
    String body = "",
    required int notificationId,
    required EAlertType type,
    required String pathSong,
    required bool isSound,
  }) async {
    cancelNotification(notificationId: notificationId);

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
      "Тревога",
      importance: Importance.max,
      sound: RawResourceAndroidNotificationSound(pathSong),
      playSound: pathSong.isNotEmpty ? isSound : false,
      priority: Priority.max,
      subText: "Внимание!",
      icon: "ic_start_alarm",
      color: CustomColor.airAlert,
      visibility: NotificationVisibility.public,
      vibrationPattern: vibrationPattern,
      autoCancel: false,
    ));

    await _flutterLocalNotificationsPlugin.show(
      id: notificationId,
      title: body,
      body: type.title,
      notificationDetails: platformChannelSpecifics,
    );
  }

  static Future<void> _showCanceledAlertNotification(
      {String body = "", required int notificationId, required String pathSong, required bool isSound}) async {
    cancelNotification(notificationId: notificationId);

    NotificationDetails platformChannelSpecifics = NotificationDetails(
        android: AndroidNotificationDetails(
      pathSong + isSound.toString(),
      "Отмена тревоги",
      importance: Importance.max,
      sound: RawResourceAndroidNotificationSound(pathSong),
      playSound: pathSong.isNotEmpty ? isSound : false,
      priority: Priority.max,
      enableLights: true,
      // subText: "Внимание!",
      autoCancel: true,
      color: CustomColor.noAlert,
      visibility: NotificationVisibility.public,
      timeoutAfter: 120000,
      icon: "ic_cancel_alarm",
    ));

    await _flutterLocalNotificationsPlugin.show(
      id: notificationId,
      title: "Отмена тревоги",
      body: body,
      notificationDetails: platformChannelSpecifics,
      // payload: 'test',
    );
  }

  static Future<void>showUpdateNotification({String body = "", required int notificationId}) async {
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
      color: CustomColor.colorMapDefault,
      autoCancel: true,
      visibility: NotificationVisibility.public,
    ));

    await _flutterLocalNotificationsPlugin.show(
        id: 222,
        title: "Новая версия! $body",
        body: "Доступно обновление для приложения",
        notificationDetails: platformChannelSpecifics,
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

    await _flutterLocalNotificationsPlugin.show(
      id: notificationId + 100,
      title: "Тестовое оповещение",
      body: body,
      notificationDetails: platformChannelSpecifics,
      payload: 'test',
    );
  }

  static void cancelNotification({required int notificationId}) async {
    await _flutterLocalNotificationsPlugin.cancel(id: notificationId);
  }
}
