import '../tools/region/eregion.dart';
import 'district_model.dart';

class RegionModel {
  final String title;
  final ERegion region;
  final bool isAlarm;
  final String? timeStart;
  final String? timeDurationAlarm;
  final String? timeDurationCancelAlarm;
  final String? timeEnd;
  final List<List<String>> allHistory;
  final List<List<String>> historyThreeDay;
  final List<DistrictModel> districts;

  RegionModel(
      {required this.title,
      required this.isAlarm,
      required this.timeDurationCancelAlarm,
      required this.timeDurationAlarm,
      required this.timeEnd,
      required this.timeStart,
      required this.districts,
      required this.allHistory,
      required this.historyThreeDay,
      required this.region});
}
