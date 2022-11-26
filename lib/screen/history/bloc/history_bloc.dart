import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../models/region_model.dart';

part 'history_event.dart';
part 'history_state.dart';

class HistoryBloc extends Bloc<HistoryEvent, HistoryState> {
  final RegionModel region;
  final DateTime _nowData = DateTime.now().toLocal();
  HistoryBloc({required this.region}) : super(HistoryInitial()) {
    on<HistoryEvent>((event, emit) async {
      if (event is HistoryLoadDataEvent) {
        emit.call(HistoryLoadedState(
          countAllAlarm: event.countAllAlarm,
          countMonthAlarm: event.countMonthAlarm,
          countSevenDayAlarm: event.countSevenDayAlarm,
          historyData: event.historyData,
          lognTimeAlarm: event.lognTimeAlarm,
          maxData: event.maxData,
          minDate: event.minDate,
          selectEndData: event.selectEndData,
          selectStartData: event.selectStartData,
          shortTimeAlarm: event.shortTimeAlarm,
          timeAllAlarm: event.timeAllAlarm,
          historyGraph: event.historyGraph,
        ));
      }
      if (event is HistoryChangeDataEvent) {
        emit.call(HistoryLoad());
        await _changeTimeData(event.selectStartDate, event.selectEndDate);
      }
    });
    _initData();
  }

  Future<void> _changeTimeData(DateTime selectStart, DateTime selectEnd) async {
    List<List<String>> alarmHistory = _getHistoryData(selectStart, selectEnd);
    add(
      HistoryLoadDataEvent(
        countAllAlarm: alarmHistory.length.toString(),
        minDate: DateTime.parse(region.allHistory.last[0]),
        maxData: DateTime.parse(region.allHistory.first[0]),
        selectStartData: selectStart,
        selectEndData: selectEnd,
        countMonthAlarm: _countMonthAlarm(region.allHistory),
        countSevenDayAlarm: _countSevenDayAlarm(region.allHistory),
        historyData: alarmHistory,
        timeAllAlarm: _getAllTimeAlarm(alarmHistory),
        lognTimeAlarm: _getLongAlarm(alarmHistory),
        shortTimeAlarm: _getShortAlarm(alarmHistory),
        historyGraph: _getHistoryGraph(region.allHistory),
      ),
    );
  }

  void _initData() {
    List<List<String>> alarmHistory = _getHistoryData(DateTime.parse(region.allHistory.last[0]), DateTime.parse(region.allHistory.first[0]));
    add(HistoryLoadDataEvent(
      countAllAlarm: alarmHistory.length.toString(),
      minDate: DateTime.parse(region.allHistory.last[0]),
      maxData: DateTime.parse(region.allHistory.first[0]),
      selectStartData: DateTime.parse(region.allHistory.last[0]),
      selectEndData: DateTime.parse(region.allHistory.first[0]),
      countMonthAlarm: _countMonthAlarm(region.allHistory),
      countSevenDayAlarm: _countSevenDayAlarm(region.allHistory),
      historyData: alarmHistory,
      timeAllAlarm: _getAllTimeAlarm(alarmHistory),
      lognTimeAlarm: _getLongAlarm(alarmHistory),
      shortTimeAlarm: _getShortAlarm(alarmHistory),
      historyGraph: _getHistoryGraph(alarmHistory),
    ));
  }

  Map<int, int> _getHistoryGraph(List<List<String>> alarmHistory) {
    Map<int, int> result = {};
    DateTime now = DateTime.now();

    for (var e in alarmHistory) {
      DateTime start = DateTime.parse(e[0]);
      if (start.year == now.year && start.month == now.month) {
        if (result[start.day] == null) {
          result[start.day] = 1;
        } else {
          int? value = result[start.day];
          result[start.day] = value! + 1;
        }
      }
    }

    return result;
  }

  AlarmTimeModel _getShortAlarm(List<List<String>> alarmHistory) {
    int inSecond = -1;
    String resultValue;
    DateTime resultDate = DateTime.now();

    for (var e in alarmHistory) {
      DateTime start = DateTime.parse(e[0]);
      DateTime end = DateTime.parse(e[1]);
      Duration duration = end.difference(start);

      if (inSecond > duration.inSeconds || inSecond == -1) {
        inSecond = duration.inSeconds;
        resultDate = start;
      }
    }

    if (inSecond == -1) return const AlarmTimeModel(date: null, value: "-");

    Duration newDuration = Duration(seconds: inSecond);

    String dayStr = newDuration.inDays.toString();
    String horsStr = (newDuration.inHours % 24).toString().padLeft(2, '0');
    String minStr = (newDuration.inMinutes % 60).toString().padLeft(2, '0');
    String secStr = (newDuration.inSeconds % 60).toString().padLeft(2, '0');

    if (dayStr == '0' && horsStr == '00' && minStr == '00') {
      resultValue = "$secStrс";
    } else if (dayStr == '0' && horsStr == '00') {
      resultValue = "$minStrм";
    } else if (dayStr == '0') {
      resultValue = "$horsStrч $minStrм";
    } else {
      resultValue = "$dayStrд $horsStrч $minStrм";
    }

    return AlarmTimeModel(date: resultDate, value: resultValue);
  }

  AlarmTimeModel _getLongAlarm(List<List<String>> alarmHistory) {
    int inSecond = -1;
    String resultValue;
    DateTime resultDate = DateTime.now();

    for (var e in alarmHistory) {
      DateTime start = DateTime.parse(e[0]);
      DateTime end = DateTime.parse(e[1]);
      Duration duration = end.difference(start);

      if (inSecond < duration.inSeconds || inSecond == -1) {
        inSecond = duration.inSeconds;
        resultDate = start;
      }
    }

    if (inSecond == -1) return const AlarmTimeModel(date: null, value: "-");

    Duration newDuration = Duration(seconds: inSecond);

    String dayStr = newDuration.inDays.toString();
    String horsStr = (newDuration.inHours % 24).toString().padLeft(2, '0');
    String minStr = (newDuration.inMinutes % 60).toString().padLeft(2, '0');
    String secStr = (newDuration.inSeconds % 60).toString().padLeft(2, '0');

    if (dayStr == '0' && horsStr == '00' && minStr == '00') {
      resultValue = "$secStrс";
    } else if (dayStr == '0' && horsStr == '00') {
      resultValue = "$minStrм";
    } else if (dayStr == '0') {
      resultValue = "$horsStrч $minStrм";
    } else {
      resultValue = "$dayStrд $horsStrч $minStrм";
    }

    return AlarmTimeModel(date: resultDate, value: resultValue);
  }

  String _getAllTimeAlarm(List<List<String>> alarmHistory) {
    int inMinutes = -1;

    for (var e in alarmHistory) {
      DateTime start = DateTime.parse(e[0]);
      DateTime end = DateTime.parse(e[1]);
      Duration duration = end.difference(start);

      inMinutes += duration.inMinutes;
    }

    if (inMinutes == -1) return "-";

    Duration newDuration = Duration(minutes: inMinutes);

    String dayStr = newDuration.inDays.toString();
    String horsStr = (newDuration.inHours % 24).toString().padLeft(2, '0');
    String minStr = (newDuration.inMinutes % 60).toString().padLeft(2, '0');

    if (dayStr == '0') {
      return "$horsStrч $minStrм";
    } else {
      return "$dayStrд $horsStrч $minStrм";
    }
  }

  List<List<String>> _getHistoryData(DateTime startData, DateTime endData) {
    try {
      return region.allHistory.where((e) {
        DateTime data = DateTime.parse(e[0]);
        if (data.day == startData.day && data.month == startData.month && data.year == startData.year) return true;
        if (data.day == endData.day && data.month == endData.month && data.year == endData.year) return true;
        if (data.isAfter(startData) && data.isBefore(endData)) return true;

        return false;
      }).toList();
    } catch (e) {
      return [];
    }
  }

  String _countSevenDayAlarm(List<List<String>> alarmHistory) {
    return alarmHistory
        .where((element) {
          DateTime date = DateTime.parse(element[0]);
          DateTime dateNow = _nowData.add(Duration(days: -(_nowData.weekday + 1)));

          if (dateNow.isBefore(date)) return true;

          return false;
        })
        .length
        .toString();
  }

  String _countMonthAlarm(List<List<String>> alarmHistory) {
    return alarmHistory
        .where((element) {
          DateTime curData = DateTime.parse(element[0]);
          if (curData.month == _nowData.month && curData.year == _nowData.year) return true;
          return false;
        })
        .length
        .toString();
  }
}

class AlarmTimeModel extends Equatable {
  final DateTime? date;
  final String? value;

  const AlarmTimeModel({required this.date, required this.value});

  @override
  List<Object?> get props => [date, value];
}
