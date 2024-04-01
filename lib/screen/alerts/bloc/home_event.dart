part of 'home_bloc.dart';

abstract class HomeEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class HomeUpdateEvent extends HomeEvent {
  final AlarmRespose data;

  HomeUpdateEvent({required this.data});

  @override
  List<Object?> get props => [data];
}

class HomeSaveRegionEvent extends HomeEvent {}

class HomeErrorEvent extends HomeEvent {}

class HomeChangeSort extends HomeEvent {
  final int sortIndex;

  HomeChangeSort({required this.sortIndex});

  @override
  List<Object?> get props => [sortIndex];
}
