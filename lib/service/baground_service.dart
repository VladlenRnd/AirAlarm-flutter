import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:flutter_background_service_android/flutter_background_service_android.dart';

import '../screen/main/tools/eregion.dart';
import '../screen/main/tools/region_title.dart';
import '../tools/connection/connection.dart';
import '../tools/connection/response/alarm_response.dart';
import 'notification_service.dart';

enum _StatusNotification {
  notShow,
  showWarning,
  showCanceled,
}

class BackgroundService {
  static late FlutterBackgroundService _service;
  static int _countError = 0;
  static Map<String, dynamic> _oldWarningMap = {};

  static Future<bool> get isRunning async => await _service.isRunning();

  static void invoke(String method, {Map<String, dynamic>? arg}) => _service.invoke(method, arg);

  static Stream<Map<String, dynamic>?> on(String method) => _service.on(method);

  static Future<void> initializeService(bool isForegroundMode) async {
    _service = FlutterBackgroundService();
    await _service.configure(
      androidConfiguration: AndroidConfiguration(
        onStart: _onStart,
        autoStart: false,
        isForegroundMode: isForegroundMode,
      ),
      iosConfiguration: IosConfiguration(
        autoStart: false,
        onForeground: _onStart,
        onBackground: onIosBackground,
      ),
    );

    _service.startService();
  }

// to ensure this executed
// run app from xcode, then from xcode menu, select Simulate Background Fetch
  static bool onIosBackground(ServiceInstance service) {
    WidgetsFlutterBinding.ensureInitialized();
    return true;
  }

  static Future<void> _isShowNotification(States states, bool initData) async {
    //  States statesv
    _StatusNotification data = _isChekSubscribe(ERegion.dnepr, states.dnipro.enabled, initData);

    switch (data) {
      case _StatusNotification.notShow:
        print("==DONT SHOW MESSAGE==");
        break;
      case _StatusNotification.showWarning:
        await NotificationService.showAlertNotification(body: RegionTitle.getRegionByEnum(ERegion.dnepr), notificationId: ERegion.dnepr.index);
        break;
      case _StatusNotification.showCanceled:
        await NotificationService.showCanceledAlertNotification(
            body: RegionTitle.getRegionByEnum(ERegion.dnepr), notificationId: ERegion.dnepr.index);
        break;
    }
  }

  static _StatusNotification _isChekSubscribe(ERegion region, bool isAlarm, bool initData) {
    _StatusNotification result = _StatusNotification.notShow;

    bool? oldState = _oldWarningMap[region.name];
    if (!initData) {
      if (oldState != null) {
        if (oldState != isAlarm) {
          if (isAlarm) {
            print("SHOW WARNING ALARM");
            result = _StatusNotification.showWarning;
          } else {
            print("SHOW CANCELED WARNING ALARM");
            result = _StatusNotification.showCanceled;
          }
        }
      } else {
        if (isAlarm) {
          print("SHOW WARNING ALARM INIT");
          result = _StatusNotification.showWarning;
        }
      }
    }

    _oldWarningMap[region.name] = isAlarm;
    return result;
  }

  static void _onStart(ServiceInstance service) async {
    Timer? timer;

    if (service is AndroidServiceInstance) {
      service.on('initServiceData').listen((event) {
        print("INIT SERVICE");
        if (event != null) {
          print(event["data"]);
          _oldWarningMap = jsonDecode(event["data"]) as Map<String, dynamic>;
        }
      });

      service.on('setAsForeground').listen((event) {
        service.setAsForegroundService();
      });

      service.on('setAsBackground').listen((event) {
        service.setAsBackgroundService();
      });

      service.on('stopService').listen((event) async {
        timer?.cancel();
        await service.stopSelf();
      });

      service.setForegroundNotificationInfo(
        title: "Мониторинг воздушной тревоги",
        content: "",
      );

      service.on('getData').listen((event) {
        _updateAlarmDataService(service, initData: true);
      });

      service.invoke('serviceReady');

      timer = Timer.periodic(const Duration(seconds: 10), (timer) async {
        _updateAlarmDataService(service);
      });
    }
  }

  static void _updateAlarmDataService(AndroidServiceInstance service, {bool initData = false}) async {
    try {
      AlarmRespose alarm = await _getAlarm();

      service.invoke(
        'update',
        {
          "alarm": alarm,
        },
      );

      await _isShowNotification(alarm.states, initData);

      service.invoke('saveData', {"data": _oldWarningMap});

      service.setForegroundNotificationInfo(
        title: "Мониторинг воздушной тревоги",
        content: "",
      );
      _countError = 0;
    } catch (e) {
      _countError++;
      if (_countError > 4) {
        service.setForegroundNotificationInfo(
          title: "Потерянно соединение с сервером",
          content: "проверьте интернет-соединение",
        );
      }

      service.invoke('error');
    }
  }

  static Future<AlarmRespose> _getAlarm() async {
    try {
      return await Conectrion.getAlarm();
    } catch (e) {
      throw Exception("Not data Alarm");
    }
  }
}
