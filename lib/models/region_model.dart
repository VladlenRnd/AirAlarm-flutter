import 'package:equatable/equatable.dart';

import '../tools/region/eregion.dart';
import 'district_model.dart';

class RegionModel extends Equatable {
  final String title;
  final ERegion region;
  final bool isAlarm;
  final String? timeStartStr;
  final String? timeDurationAlarmStr;
  final Duration timeDurationAlarm;
  final Duration timeDurationCancelAlarm;
  final String? timeDurationCancelAlarmStr;
  final String? timeEndStr;
  final List<List<DateTime>> allHistory;
  final List<List<DateTime>> historyThreeDay;
  final List<DistrictModel> districts;
  final String? curfewStr;
  final bool? isCurfew;

  const RegionModel({
    required this.title,
    required this.isAlarm,
    required this.timeDurationCancelAlarmStr,
    required this.timeDurationCancelAlarm,
    required this.timeDurationAlarmStr,
    required this.timeDurationAlarm,
    required this.timeEndStr,
    required this.timeStartStr,
    required this.districts,
    required this.allHistory,
    required this.historyThreeDay,
    required this.region,
    required this.curfewStr,
    required this.isCurfew,
  });

  @override
  List<Object?> get props => [
        title,
        region,
        isAlarm,
        timeStartStr,
        timeDurationAlarmStr,
        timeDurationAlarm,
        timeDurationCancelAlarmStr,
        timeEndStr,
        allHistory,
        historyThreeDay,
        districts,
        curfewStr,
        isCurfew,
      ];
}
