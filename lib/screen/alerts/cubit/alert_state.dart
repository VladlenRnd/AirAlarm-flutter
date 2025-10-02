part of 'alert_cubit.dart';

sealed class AlertState extends Equatable {
  const AlertState();

  @override
  List<Object?> get props => [];
}

final class AlertLoadingState extends AlertState {}

final class AlertErrorDataState extends AlertState {}

final class AlertLoadedDataState extends AlertState {
  final List<RegionModel> regionList;
  final RegionModel? subscribeRegion;
  final RegionModel? selectRegion;

  const AlertLoadedDataState({required this.regionList,required this.subscribeRegion,required this.selectRegion});

  @override
  List<Object?> get props => [regionList,subscribeRegion,selectRegion];
}
