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
      SoundModel(name: "Сирена 1", fileName: "alarm", assetPath: "song/alarm/alarm.mp3"),
      SoundModel(name: "Сирена 2", fileName: "alarm2", assetPath: "song/alarm/alarm2.mp3"),
      SoundModel(name: "Сирена 3", fileName: "alarm3", assetPath: "song/alarm/alarm3.mp3"),
      SoundModel(name: "Сирена 4", fileName: "alarm4", assetPath: "song/alarm/alarm4.mp3"),
      SoundModel(name: "Сирена 5", fileName: "alarm5", assetPath: "song/alarm/alarm5.mp3"),
      SoundModel(name: "Сирена 6", fileName: "alarm6", assetPath: "song/alarm/alarm6.mp3"),
      SoundModel(name: "Сирена + Голос", fileName: "beep_fill_alarm", assetPath: "song/alarm/beep_fill_alarm.mp3"),
      SoundModel(name: "Голос 1", fileName: "fill_alarm", assetPath: "song/alarm/fill_alarm.mp3"),
      // SoundModel(name: "Голос 2 (UA)", fileName: "fill_alarm_ua", assetPath: "song/alarm/fill_alarm_ua.mp3"),
      SoundModel(name: "Сигнал", fileName: "beep", assetPath: "song/alarm/beep.mp3"),
      SoundModel(name: "Сигнал 2", fileName: "beep2", assetPath: "song/alarm/beep2.mp3"),
      SoundModel(name: "Сигнал 3", fileName: "beep3", assetPath: "song/alarm/beep3.mp3"),
      SoundModel(name: "Сигнал 4", fileName: "beep4", assetPath: "song/alarm/beep4.mp3"),
      SoundModel(name: "Сигнал 5", fileName: "beep5", assetPath: "song/alarm/beep5.mp3"),
      SoundModel(name: "Сигнал 6", fileName: "beep6", assetPath: "song/alarm/beep6.mp3"),
      SoundModel(name: "Сигнал 7", fileName: "beep7", assetPath: "song/alarm/beep7.mp3"),
    ];
  }

  static List<SoundModel> _getCancelSong() {
    return const [
      SoundModel(name: "Без звука", fileName: "", assetPath: ""),
      SoundModel(name: "Системная отмена", fileName: "cancel_alarm", assetPath: "song/cancel/cancel_alarm.mp3"),
      SoundModel(name: "Голос 1", fileName: "fill_cancel", assetPath: "song/cancel/fill_cancel.mp3"),
      //SoundModel(name: "Голос 2 (UA)", fileName: "fill_cancel_ua", assetPath: "song/cancel/fill_cancel_ua.mp3"),
      SoundModel(name: "Сигнал", fileName: "beep_cancel", assetPath: "song/cancel/beep_cancel.mp3"),
      SoundModel(name: "Сигнал 2", fileName: "beep_cancel2", assetPath: "song/cancel/beep_cancel2.mp3"),
      SoundModel(name: "Сигнал 3", fileName: "beep_cancel3", assetPath: "song/cancel/beep_cancel3.mp3"),
      SoundModel(name: "Сигнал 4", fileName: "beep_cancel4", assetPath: "song/cancel/beep_cancel4.mp3"),
      SoundModel(name: "Сигнал 5", fileName: "beep_cancel5", assetPath: "song/cancel/beep_cancel5.mp3"),
      SoundModel(name: "Сигнал 6", fileName: "beep_cancel6", assetPath: "song/cancel/beep_cancel6.mp3"),
      SoundModel(name: "Сигнал 7", fileName: "beep_cancel7", assetPath: "song/cancel/beep_cancel7.mp3"),
      SoundModel(name: "Сигнал 8", fileName: "beep_cancel8", assetPath: "song/cancel/beep_cancel8.mp3"),
    ];
  }
}
