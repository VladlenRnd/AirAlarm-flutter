import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_background_service/flutter_background_service.dart';

import 'screen/main/main_screan.dart';
import 'service/baground_service.dart';
import 'service/notification_service.dart';
import 'service/shered_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);

  await NotificationService.init();
  await SheredPreferencesService.init();

  await BackgroundService.initializeService(SheredPreferencesService.preferences.getBool("backgroundSercive")!);

  _backgroundServiceInitData();

  runApp(MyApp());
}

void _backgroundServiceInitData() {
  if (!SheredPreferencesService.preferences.getBool("backgroundSercive")!) {
    FlutterBackgroundService().on('serviceReady').listen((event) {
      try {
        var data = jsonDecode(SheredPreferencesService.preferences.getString("serviceData")!);
        print("onLOad === $data");
        FlutterBackgroundService().invoke("initServiceData", {"data": data});
      } catch (e) {
        print(e);
      }
    });
  }

  FlutterBackgroundService().on('saveData').listen((event) {
    print("onSAVE === $event");
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
        FlutterBackgroundService().invoke("stopService");
      }
      if (state == AppLifecycleState.resumed) {
        if (!await FlutterBackgroundService().isRunning()) {
          BackgroundService.initializeService(SheredPreferencesService.preferences.getBool("backgroundSercive")!);
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
