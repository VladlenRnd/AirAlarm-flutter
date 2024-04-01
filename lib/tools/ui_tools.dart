import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';

import '../models/district_model.dart';
import '../models/region_model.dart';
import 'custom_color.dart';
import 'region/eregion.dart';

class UiTools {
  static List<RegionModel> getAlarmRegion(List<RegionModel> allRegion) {
    List<RegionModel> alarmRegion = [];
    for (RegionModel element in allRegion) {
      if (element.isAlarm) alarmRegion.add(element);
    }
    return alarmRegion;
  }

  static bool isGlobalAlarm(List<RegionModel> allRegion) {
    bool result = true;
    for (RegionModel element in allRegion) {
      if (!element.isAlarm) {
        return false;
      }
    }
    return result;
  }

  static Color getAlarmColor(RegionModel model) {
    bool isAlarmRegion = false;

    try {
      isAlarmRegion = model.districts.firstWhere((element) => element.isAlarm == true).isAlarm;
    } catch (e) {
      isAlarmRegion = false;
    }

    return model.isAlarm
        ? model.timeDurationAlarm.inDays > 1
            ? CustomColor.darkRed
            : CustomColor.red
        : isAlarmRegion
            ? CustomColor.atantion
            : model.timeDurationCancelAlarm.inDays > 2
                ? CustomColor.wihteGreen
                : CustomColor.green;
  }

  static String getAlarmStr(bool isAlarm, List<DistrictModel> listDistrict) {
    bool isAlarmRegion = false;

    try {
      isAlarmRegion = listDistrict.firstWhere((element) => element.isAlarm == true).isAlarm;
    } catch (e) {
      isAlarmRegion = false;
    }

    return isAlarm
        ? "Воздушная тревога"
        : isAlarmRegion
            ? "Опасность в области"
            : "Тревоги нет";
  }

  static bool isAlarmRegion(List<RegionModel> allRegion, ERegion selectRegion) {
    return allRegion.firstWhere((RegionModel e) => e.region == selectRegion).isAlarm;
  }

  static RegionModel getRegion(List<RegionModel> allRegion, ERegion selectRegion) {
    return allRegion.firstWhere((RegionModel e) => e.region == selectRegion);
  }

  static bool isAlarmDistrict(List<RegionModel> allRegion, ERegion selectRegion) {
    try {
      allRegion.firstWhere((RegionModel e) => e.region == selectRegion).districts.firstWhere((d) => d.isAlarm == true);
      return true;
    } catch (e) {
      return false;
    }
  }

  static bool isNoAlarm(List<RegionModel> allRegion) {
    bool result = true;
    for (RegionModel element in allRegion) {
      if (element.isAlarm) {
        return false;
      }
    }
    return result;
  }

  static int getCountWarningRegion(List<RegionModel> allRegion) {
    int warningCount = 0;
    for (RegionModel element in allRegion) {
      if (!element.isAlarm) {
        try {
          element.districts.firstWhere((d) => d.isAlarm == true);
          warningCount++;
          // ignore: empty_catches
        } catch (e) {}
      }
    }
    return warningCount;
  }

  static int getCountNoAlarmRegion(List<RegionModel> allRegion) {
    int noAlarmCount = 0;
    for (RegionModel element in allRegion) {
      if (!element.isAlarm) {
        noAlarmCount++;
      }
    }
    return noAlarmCount;
  }

  static int getCountAlarmRegion(List<RegionModel> allRegion) {
    int alarmCount = 0;
    for (RegionModel element in allRegion) {
      if (element.isAlarm) {
        alarmCount++;
      }
    }
    return alarmCount;
  }

  static int getPercentAlarm(List<RegionModel> allRegion) {
    double onePercent = 100 / allRegion.length;

    return (getAlarmRegion(allRegion).length * onePercent).toInt();
  }

  static Widget buildIconStatus(bool isAlarm, bool isAlarmDistrict, {double size = 65}) {
    return isAlarm
        ? SvgPicture.asset("assets/icons/alarm.svg", colorFilter: const ColorFilter.mode(CustomColor.red, BlendMode.srcIn), height: size, width: size)
        : isAlarmDistrict
            ? SvgPicture.asset("assets/icons/bomb.svg",
                colorFilter: const ColorFilter.mode(CustomColor.atantion, BlendMode.srcIn), height: size, width: size)
            : SvgPicture.asset("assets/icons/safety.svg",
                colorFilter: const ColorFilter.mode(CustomColor.green, BlendMode.srcIn), height: size, width: size);
  }

  static String? getDateToDay(DateTime date, bool showTime) {
    DateTime now = DateTime.now();
    switch (DateTime.utc(now.year, now.month, now.day).difference(DateTime.utc(date.year, date.month, date.day)).inDays) {
      case 0:
        return "Сегодня ${showTime ? DateFormat("HH:mm").format(date) : ""}";
      case 1:
        return "Вчера ${showTime ? DateFormat("HH:mm").format(date) : ""}";
      default:
        return null;
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
