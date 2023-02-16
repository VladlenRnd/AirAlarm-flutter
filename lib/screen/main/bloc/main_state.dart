part of 'main_bloc.dart';

@immutable
class MainState extends Equatable {
  @override
  List<Object?> get props => [];
}

class MainInitialState extends MainState {}

class MainLoadedDataState extends MainState {}

class MainLoadDataState extends MainState {
  final List<RegionModel> listRegions;
  final int sortIndex;

  MainLoadDataState({required this.listRegions, required this.sortIndex});

  @override
  List<Object?> get props => [listRegions, sortIndex];
}

class MainErrorDataState extends MainState {}
