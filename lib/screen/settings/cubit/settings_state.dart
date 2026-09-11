part of 'settings_cubit.dart';

sealed class SettingsState extends Equatable {
  const SettingsState();

  @override
  List<Object> get props => [];
}

final class SettingsInitial extends SettingsState {}

final class SettingsDataLoaded extends SettingsState {
  final bool autoSearch;
  final List<SubscribeAlertModel> subscribeList;

  // final List<SoundModel> alarmSoundList = SoundService.alarmSounds;
  // final SoundModel alarmSoundSelect;
  // final List<SoundModel> cancelSoundList = SoundService.cancelSounds;
  // final SoundModel cancelSoundSelect;

  final String silenceTime;
  final String version;

  const SettingsDataLoaded({
    required this.subscribeList,
    required this.autoSearch,
    required this.silenceTime,
    required this.version,
  });

  @override
  List<Object> get props => [autoSearch, silenceTime, version, subscribeList];
}
