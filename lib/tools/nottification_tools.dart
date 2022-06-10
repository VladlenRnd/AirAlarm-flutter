import 'package:flutter/material.dart';

import '../service/shered_preferences_service.dart';

bool isSoundNotification() {
  List<String> startTime = SheredPreferencesService.preferences.getStringList("siledStart")!;
  List<String> endTime = SheredPreferencesService.preferences.getStringList("siledEnd")!;

  if (startTime.isNotEmpty && endTime.isNotEmpty) {
    TimeOfDay now = TimeOfDay.now();

    bool start = _compareTime(now.hour, now.minute, int.parse(startTime[0]), int.parse(startTime[1]));
    bool end = (int.parse(startTime[0]) > int.parse(endTime[0]))
        ? _compareTime(now.hour, now.minute, int.parse(endTime[0]), int.parse(endTime[1]))
        : _compareTime(int.parse(endTime[0]), int.parse(endTime[1]), now.hour, now.minute);

    if (start && end) return false;
  }

  return true;
}

bool _compareTime(int hour1, int minute1, int hour2, int minute2) {
  if (hour1 > hour2) {
    return true;
  } else if (hour1 == hour2) {
    if (minute1 >= minute2) return true;
  }

  return false;
}
