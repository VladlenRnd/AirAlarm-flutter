import 'package:collection/collection.dart';
import 'package:equatable/equatable.dart';

class SoundModel extends Equatable {
  final String name;
  final String fileName;
  final String assetPath;

  const SoundModel({required this.name, required this.fileName, required this.assetPath});

  @override
  List<Object?> get props => [name, fileName];
}

class SoundService {
  static List<SoundModel> get alarmSounds => _getAlarmSong();
  static List<SoundModel> get cancelSounds => _getCancelSong();
  static SoundModel? getModelByFileName(String fileName, List<SoundModel> modelList) =>
      modelList.firstWhereOrNull((element) => element.fileName == fileName);

  static List<SoundModel> _getAlarmSong() {
    return const [
      SoundModel(name: "Без звука", fileName: "", assetPath: ""),
      SoundModel(name: "Сирена", fileName: "alarm", assetPath: "song/alarm/alarm.mp3"),
      SoundModel(name: "Сирена 2", fileName: "alarm2", assetPath: "song/alarm/alarm2.mp3"),
      SoundModel(name: "Сирена 3", fileName: "alarm3", assetPath: "song/alarm/alarm3.mp3"),
      SoundModel(name: "Филл Бот тревога", fileName: "fill_alarm", assetPath: "song/alarm/fill_alarm.mp3"),
      SoundModel(name: "Филл Бот тревога (UA)", fileName: "fill_alarm_ua", assetPath: "song/alarm/fill_alarm_ua.mp3"),
      SoundModel(name: "Сигнал", fileName: "beep", assetPath: "song/alarm/beep.mp3"),
      SoundModel(name: "Сигнал 2", fileName: "beep2", assetPath: "song/alarm/beep2.mp3"),
      SoundModel(name: "Сигнал + бот", fileName: "beep_fill_alarm", assetPath: "song/alarm/beep_fill_alarm.mp3"),
    ];
  }

  static List<SoundModel> _getCancelSong() {
    return const [
      SoundModel(name: "Без звука", fileName: "", assetPath: ""),
      SoundModel(name: "Системная отмена", fileName: "cancel_alarm", assetPath: "song/cancel/cancel_alarm.mp3"),
      SoundModel(name: "Филл Бот отмена", fileName: "fill_cancel", assetPath: "song/cancel/fill_cancel.mp3"),
      SoundModel(name: "Филл Бот отмена (UA)", fileName: "fill_cancel_ua", assetPath: "song/cancel/fill_cancel_ua.mp3"),
      SoundModel(name: "Сигнал", fileName: "beep_cancel", assetPath: "song/cancel/beep_cancel.mp3"),
      SoundModel(name: "Сигнал 2", fileName: "beep_cancel2", assetPath: "song/cancel/beep_cancel2.mp3"),
    ];
  }
}
