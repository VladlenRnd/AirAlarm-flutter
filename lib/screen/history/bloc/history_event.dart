part of 'history_bloc.dart';

abstract class HistoryEvent extends Equatable {
  const HistoryEvent();

  @override
  List<Object> get props => [];
}

class HistoryChangeDataEvent extends HistoryEvent {
  final DateTime selectStartDate;
  final DateTime selectEndDate;

  const HistoryChangeDataEvent({required this.selectStartDate, required this.selectEndDate});

  @override
  List<Object> get props => [selectStartDate, selectEndDate];
}

class HistoryLoadDataEvent extends HistoryEvent {
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

  final List<List<DateTime>> historyData;

  const HistoryLoadDataEvent({
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
