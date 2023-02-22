part of 'main_bloc.dart';

abstract class MainEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class MainUpdateEvent extends MainEvent {
  final AlarmRespose alarm;

  MainUpdateEvent({required this.alarm});

  @override
  List<Object?> get props => [alarm];
}

class MainErrorEvent extends MainEvent {}

class MainChangeSort extends MainEvent {
  final int sortIndex;

  MainChangeSort({required this.sortIndex});

  @override
  List<Object?> get props => [sortIndex];
}
