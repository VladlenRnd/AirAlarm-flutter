import 'package:flutter/material.dart';

bool isSoundNotification(DateTime? startTime, DateTime? endTime) {
  if (startTime != null && endTime != null) {
    TimeOfDay now = TimeOfDay.now();

    bool isNewDay = (endTime.hour < startTime.hour);
    bool start = false;
    bool end = false;

    if (startTime == endTime) {
      return false;
    }

    if (isNewDay) {
      if (now.hour >= startTime.hour) {
        start = _isMoreStart(now, startTime);
        end = !_isLessEnd(now, endTime);
      } else {
        start = !_isMoreStart(now, startTime);
        end = _isLessEnd(now, endTime);
      }
    } else {
      start = _isMoreStart(now, startTime);
      end = _isLessEnd(now, endTime);
    }

    if (start) {
      if (end) {
        return false;
      }
    }
  }
  return true;
}

bool _isLessEnd(TimeOfDay now, DateTime end) {
  if (now.hour < end.hour) return true;
  if (now.hour == end.hour) {
    if (now.minute < end.minute) return true;
  }
  return false;
}

bool _isMoreStart(TimeOfDay now, DateTime start) {
  if (now.hour > start.hour) return true;
  if (now.hour == start.hour) {
    if (now.minute > start.minute) return true;
  }
  return false;
}
