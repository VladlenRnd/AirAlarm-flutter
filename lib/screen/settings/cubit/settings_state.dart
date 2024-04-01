part of 'settings_cubit.dart';

sealed class SettingsState extends Equatable {
  const SettingsState();

  @override
  List<Object> get props => [];
}

final class SettingsInitial extends SettingsState {}

final class SettingsDataLoad extends SettingsState {
  final bool autoSearch;
  final List<SoundModel> alarmSoundList = SoundService.alarmSounds;
  final SoundModel alarmSoundSelect;

  final List<SoundModel> cancelSoundList = SoundService.cancelSounds;
  final SoundModel cancelSoundSelect;

  final String silenceTime;
  final String version;

  SettingsDataLoad(
      {required this.autoSearch, required this.alarmSoundSelect, required this.cancelSoundSelect, required this.silenceTime, required this.version});

  @override
  List<Object> get props => [autoSearch, alarmSoundList, alarmSoundSelect, cancelSoundList, cancelSoundSelect, silenceTime, version];
}
