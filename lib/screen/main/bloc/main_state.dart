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

  MainLoadDataState({required this.listRegions});

  @override
  List<Object?> get props => [listRegions];
}

class MainErrorDataState extends MainState {}
