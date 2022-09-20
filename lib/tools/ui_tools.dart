import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../models/region_model.dart';
import 'custom_color.dart';

class UiTools {
  static List<RegionModel> getAlarmRegion(List<RegionModel> allRegion) {
    List<RegionModel> alarmRegion = [];
    for (RegionModel element in allRegion) {
      if (element.isAlarm) alarmRegion.add(element);
    }
    return alarmRegion;
  }

  static int getPercentAlarm(List<RegionModel> allRegion) {
    double onePercent = 100 / allRegion.length;

    return (getAlarmRegion(allRegion).length * onePercent).toInt();
  }

  static Widget buildIconStatus(bool isAlarm, bool isAlarmDistrict, {double size = 65}) {
    return isAlarm
        ? SvgPicture.asset("assets/icons/alarm.svg", color: CustomColor.red, height: size, width: size)
        : isAlarmDistrict
            ? SvgPicture.asset("assets/icons/bomb.svg", color: CustomColor.colorMapAtantion, height: size, width: size)
            : SvgPicture.asset("assets/icons/safety.svg", color: CustomColor.green, height: size, width: size);
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
