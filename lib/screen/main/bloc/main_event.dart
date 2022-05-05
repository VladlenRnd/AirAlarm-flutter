part of 'main_bloc.dart';

@immutable
abstract class MainEvent {}

class MainUpdateEvent extends MainEvent {
  final AlarmRespose alarm;

  MainUpdateEvent({required this.alarm});
}

class MainErrorEvent extends MainEvent {}

class MainForcedUpdateEvent extends MainEvent {}

class MainReorderableEvent extends MainEvent {
  final int oldIndex;
  final int newIndex;

  MainReorderableEvent({required this.oldIndex, required this.newIndex});
}
