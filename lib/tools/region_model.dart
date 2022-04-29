import 'eregion.dart';

class RegionModel {
  final String title;
  final ERegion region;
  final bool isAlarm;
  final String? timeStart;
  final String? timeDurationAlarm;
  final String? timeDurationCancelAlarm;
  final String? timeEnd;

  RegionModel(
      {required this.title,
      required this.isAlarm,
      required this.timeDurationCancelAlarm,
      required this.timeDurationAlarm,
      required this.timeEnd,
      required this.timeStart,
      required this.region});
}
