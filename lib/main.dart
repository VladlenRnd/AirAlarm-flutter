import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'screen/main/main_screen.dart';
import 'service/baground_service.dart';
import 'service/notification_service.dart';
import 'service/shered_preferences.dart';

StreamSubscription? serviceReadyListener;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);

  await NotificationService.init();
  await SheredPreferencesService.init();
  //await BackgroundService.initializeService(SheredPreferencesService.preferences.getBool("backgroundSercive")!);
  _backgroundServiceInitData();

  Future.delayed(Duration(seconds: 5), () {
    NotificationService.showAlertNotification(notificationId: 1, body: "AAAAA");
  });

  Future.delayed(Duration(seconds: 10), () {
    NotificationService.showCanceledAlertNotification(notificationId: 444, body: "BBBBB");
  });

  runApp(MyApp());
}

void _backgroundServiceInitData() {
  if (!SheredPreferencesService.preferences.getBool("backgroundSercive")!) {
    serviceReadyListener?.cancel();
    serviceReadyListener = BackgroundService.on('serviceReady').listen((event) {
      try {
        BackgroundService.invoke("initServiceData", arg: {"data": SheredPreferencesService.preferences.getString("serviceData")});
      } catch (e) {
        print(e);
      }
    });
  }

  BackgroundService.on('saveData').listen((event) {
    SheredPreferencesService.preferences.setString("serviceData", json.encode(event!["data"]));
  });
}

class MyApp extends StatelessWidget with WidgetsBindingObserver {
  MyApp({Key? key}) : super(key: key) {
    WidgetsBinding.instance?.addObserver(this);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) async {
    if (!SheredPreferencesService.preferences.getBool("backgroundSercive")!) {
      if (state == AppLifecycleState.paused) {
        BackgroundService.invoke("stopService");
      }
      if (state == AppLifecycleState.resumed) {
        if (!await BackgroundService.isRunning) {
          await BackgroundService.initializeService(SheredPreferencesService.preferences.getBool("backgroundSercive")!);
          _backgroundServiceInitData();
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MainScreen(),
    );
  }
}
