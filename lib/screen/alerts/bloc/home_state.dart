part of 'home_bloc.dart';

@immutable
class HomeState extends Equatable {
  @override
  List<Object?> get props => [];
}

class HomeLoadingState extends HomeState {}

class HomeUpdateState extends HomeState {
  final List<RegionModel> listRegions;

  HomeUpdateState({required this.listRegions});

  @override
  List<Object?> get props => [listRegions];
}

class HomeErrorDataState extends HomeState {}
