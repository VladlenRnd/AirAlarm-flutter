import '../tools/edistricts.dart';

class DistrictModel {
  final String title;
  final EDistricts districts;
  final bool isAlarm;
  final String? timeStart;
  final String? timeDurationAlarm;
  final String? timeDurationCancelAlarm;
  final String? timeEnd;

  DistrictModel(
      {required this.title,
      required this.isAlarm,
      required this.timeDurationCancelAlarm,
      required this.timeDurationAlarm,
      required this.timeEnd,
      required this.timeStart,
      required this.districts});
}
