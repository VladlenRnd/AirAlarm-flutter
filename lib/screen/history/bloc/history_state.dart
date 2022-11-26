part of 'history_bloc.dart';

abstract class HistoryState extends Equatable {
  const HistoryState();

  @override
  List<Object> get props => [];
}

class HistoryInitial extends HistoryState {}

class HistoryLoad extends HistoryState {}

class HistoryLoadedState extends HistoryState {
  final String countAllAlarm;
  final String timeAllAlarm;
  final AlarmTimeModel lognTimeAlarm;
  final String countMonthAlarm;
  final String countSevenDayAlarm;
  final AlarmTimeModel shortTimeAlarm;
  final DateTime maxData;
  final DateTime minDate;
  final DateTime selectStartData;
  final DateTime selectEndData;
  final Map<int, int> historyGraph;

  final List<List<String>> historyData;

  const HistoryLoadedState({
    required this.countAllAlarm,
    required this.countMonthAlarm,
    required this.countSevenDayAlarm,
    required this.historyData,
    required this.lognTimeAlarm,
    required this.shortTimeAlarm,
    required this.maxData,
    required this.minDate,
    required this.selectStartData,
    required this.selectEndData,
    required this.timeAllAlarm,
    required this.historyGraph,
  });

  @override
  List<Object> get props => [
        countAllAlarm,
        timeAllAlarm,
        lognTimeAlarm,
        countMonthAlarm,
        countSevenDayAlarm,
        shortTimeAlarm,
        maxData,
        minDate,
        selectStartData,
        selectEndData,
        historyGraph
      ];
}
