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
  final List<DistrictModel> districts;

  RegionModel(
      {required this.title,
      required this.isAlarm,
      required this.timeDurationCancelAlarm,
      required this.timeDurationAlarm,
      required this.timeEnd,
      required this.timeStart,
      required this.districts,
      required this.region});
}
