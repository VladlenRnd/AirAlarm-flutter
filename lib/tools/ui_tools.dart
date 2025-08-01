import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';

import '../models/region_model.dart';
import 'custom_color.dart';
import 'region/eregion.dart';

class UiTools {
  static List<RegionModel> getAlarmRegion(List<RegionModel> allRegion) {
    List<RegionModel> alarmRegion = [];
    for (RegionModel element in allRegion) {
      if (element.isAlert) alarmRegion.add(element);
    }
    return alarmRegion;
  }

  static bool isGlobalAlarm(List<RegionModel> allRegion) {
    bool result = true;
    for (RegionModel element in allRegion) {
      if (!element.isAlert) {
        return false;
      }
    }
    return result;
  }

  static Color getAlarmColor(RegionModel model) {
    return model.isAlert ? CustomColor.airAlert : CustomColor.noAlert;
  }

  static int getPercentAlarm(List<RegionModel> allRegion) {
    double onePercent = 100 / allRegion.length;

    return (getAlarmRegion(allRegion).length * onePercent).toInt();
  }

  static Widget buildIconStatus(bool isAlarm, bool isAlarmDistrict, {double size = 65}) {
    return isAlarm
        ? SvgPicture.asset("assets/icons/alarm.svg",
            colorFilter: const ColorFilter.mode(CustomColor.airAlert, BlendMode.srcIn), height: size, width: size)
        : isAlarmDistrict
            ? SvgPicture.asset("assets/icons/bomb.svg",
                colorFilter: const ColorFilter.mode(CustomColor.atantion, BlendMode.srcIn), height: size, width: size)
            : SvgPicture.asset("assets/icons/safety.svg",
                colorFilter: const ColorFilter.mode(CustomColor.noAlert, BlendMode.srcIn), height: size, width: size);
  }

  static String getElapsedTimeFormatted(DateTime from) {
    final difference = DateTime.now().difference(from);

    if (difference.inDays >= 1) {
      final days = difference.inDays;
      final suffix = declinationWordByNumber(days, "День", "Дня", "Дней");
      return '($days $suffix)';
    } else {
      final hours = difference.inHours.toString().padLeft(2, '0');
      final minutes = (difference.inMinutes % 60).toString().padLeft(2, '0');
      return '$hours:$minutes';
    }
  }

  static String getDateToDay(DateTime date, bool showTime) {
    DateTime now = DateTime.now();
    if (!showTime) return "";
    switch (DateTime.utc(now.year, now.month, now.day).difference(DateTime.utc(date.year, date.month, date.day)).inDays) {
      case 0:
        return "Сегодня ${DateFormat("HH:mm").format(date)}";
      case 1:
        return "Вчера ${DateFormat("HH:mm").format(date)}";
      default:
        return DateFormat("dd/MM/yyyy HH:mm").format(date);
    }
  }

  static String declinationWordByNumber(int number, String word1, String word2, String word3) {
    int num = (number % 20).abs();
    if (num > 10 && num < 20) {
      return word3;
    }
    if (num > 1 && num < 5) {
      return word2;
    }
    if (num == 1) {
      return word1;
    }
    return word3;
  }
}
