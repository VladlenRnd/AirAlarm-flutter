part of 'main_bloc.dart';

@immutable
abstract class MainEvent {}

class MainUpdateEvent extends MainEvent {
  final AlarmRespose alarm;

  MainUpdateEvent({required this.alarm});
}

class MainErrorEvent extends MainEvent {}
