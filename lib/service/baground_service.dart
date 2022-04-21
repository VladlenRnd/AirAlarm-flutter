import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:flutter_background_service_android/flutter_background_service_android.dart';

import '../screen/main/tools/eregion.dart';
import '../screen/main/tools/region_title.dart';
import '../tools/connection/connection.dart';
import '../tools/connection/response/alarm_response.dart';
import 'notification_service.dart';

enum StatusNotification {
  notShow,
  showWarning,
  showCanceled,
}

class BackgroundService {
  static final FlutterBackgroundService _service = FlutterBackgroundService();

  static Map<String, bool> _oldWarningMap = {};

  static Future<void> initializeService(bool isForegroundMode) async {
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

  static int _countError = 0;

  static Future<void> _isShowNotification(States states, bool initData) async {
    //  States statesv
    StatusNotification data = _isChekSubscribe(ERegion.dnepr, states.dnipro.enabled, initData);

    switch (data) {
      case StatusNotification.notShow:
        break;
      case StatusNotification.showWarning:
        await NotificationService.showAlertNotification(body: RegionTitle.getRegionByEnum(ERegion.dnepr), notificationId: ERegion.dnepr.index);
        break;
      case StatusNotification.showCanceled:
        await NotificationService.showCanceledAlertNotification(
            body: RegionTitle.getRegionByEnum(ERegion.dnepr), notificationId: ERegion.dnepr.index);
        break;
    }
  }

  static StatusNotification _isChekSubscribe(ERegion region, bool isAlarm, bool initData) {
    StatusNotification result = StatusNotification.notShow;

    bool? oldState = _oldWarningMap[region.name];
    print(initData);
    if (!initData) {
      if (oldState != null) {
        if (oldState != isAlarm) {
          if (isAlarm) {
            print("SHOW WARNING ALARM");
            result = StatusNotification.showWarning;
          } else {
            print("SHOW CANCELED WARNING ALARM");
            result = StatusNotification.showCanceled;
          }
        }
      } else {
        if (isAlarm) {
          print("SHOW WARNING ALARM INIT");
          result = StatusNotification.showWarning;
        }
      }
    }

    _oldWarningMap[region.name] = isAlarm;
    return result;
  }

  static void _onStart(ServiceInstance service) async {
    if (service is AndroidServiceInstance) {
      service.on('initServiceData').listen((event) {
        _oldWarningMap = event!["data"];
      });

      service.on('setAsForeground').listen((event) {
        service.setAsForegroundService();
      });

      service.on('setAsBackground').listen((event) {
        service.setAsBackgroundService();
      });

      service.on('stopService').listen((event) {
        service.stopSelf();
      });

      service.setForegroundNotificationInfo(
        title: "Мониторинг воздушной тревоги",
        content: "",
      );

      service.on('getData').listen((event) {
        _updateAlarmDataService(service, initData: true);
      });

      service.invoke('serviceReady');

      Timer.periodic(const Duration(seconds: 10), (timer) async {
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


      

    //   /// you can see this log in logcat
    //   // print('FLUTTER BACKGROUND SERVICE: ${DateTime.now()}');

    //   // test using external plugin

    //   // service.invoke(
    //   //   'update',
    //   //   {
    //   //     "current_date": DateTime.now().toIso8601String(),
    //   //     "device": "Data Invoke",
    //   //   },
    //   // );
    // });
  






// class MyApp extends StatefulWidget {
//   const MyApp({Key? key}) : super(key: key);

//   @override
//   _MyAppState createState() => _MyAppState();
// }

// class _MyAppState extends State<MyApp> {
//   String text = "Stop Service";
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       home: Scaffold(
//         appBar: AppBar(
//           title: const Text('Service App'),
//         ),
//         body: Column(
//           children: [
//             StreamBuilder<Map<String, dynamic>?>(
//               stream: FlutterBackgroundService().on('update'),
//               builder: (context, snapshot) {
//                 if (!snapshot.hasData) {
//                   return const Center(
//                     child: CircularProgressIndicator(),
//                   );
//                 }

//                 final data = snapshot.data!;
//                 String? device = data["device"];
//                 DateTime? date = DateTime.tryParse(data["current_date"]);
//                 return Column(
//                   children: [
//                     Text(device ?? 'Unknown'),
//                     Text(date.toString()),
//                   ],
//                 );
//               },
//             ),
//             ElevatedButton(
//               child: const Text("Foreground Mode"),
//               onPressed: () {
//                 FlutterBackgroundService().invoke("setAsForeground");
//               },
//             ),
//             ElevatedButton(
//               child: const Text("Background Mode"),
//               onPressed: () {
//                 FlutterBackgroundService().invoke("setAsBackground");
//               },
//             ),
//             ElevatedButton(
//               child: Text(text),
//               onPressed: () async {
//                 final service = FlutterBackgroundService();
//                 var isRunning = await service.isRunning();
//                 if (isRunning) {
//                   service.invoke("stopService");
//                 } else {
//                   service.startService();
//                 }

//                 if (!isRunning) {
//                   text = 'Stop Service';
//                 } else {
//                   text = 'Start Service';
//                 }
//                 setState(() {});
//               },
//             ),
//           ],
//         ),
//         floatingActionButton: FloatingActionButton(
//           onPressed: () {},
//           child: const Icon(Icons.play_arrow),
//         ),
//       ),
//     );
//   }
// }
