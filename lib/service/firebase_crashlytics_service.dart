import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';

import 'abstract_service.dart';

class FirebaseCrashlyticsService implements AService {
  @override
  bool isInitDone = false;

  @override
  Future<bool> init() async {
    FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterFatalError;
    isInitDone = true;
    return true;
  }
}
