import 'eregion.dart';

class RegionModel {
  final String title;
  final ERegion region;
  final bool isAlarm;
  final String? timeStart;
  final String? timeDuration;
  final String? timeEnd;

  RegionModel(
      {required this.title, required this.isAlarm, required this.timeDuration, required this.timeEnd, required this.timeStart, required this.region});
}
