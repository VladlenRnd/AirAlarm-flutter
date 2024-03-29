class SoundModel {
  final String name;
  final String fileName;

  SoundModel({required this.name, required this.fileName});
}

class SoundService {
  static List<SoundModel> get alarmSound => _getAlarmSong();
  static List<SoundModel> get cancelSound => _getCancelSong();

  static List<SoundModel> _getAlarmSong() {
    return [
      SoundModel(name: "Без звука", fileName: ""),
      SoundModel(name: "Сирена", fileName: "alarm"),
      SoundModel(name: "Сирена 2", fileName: "alarm2"),
      SoundModel(name: "Сирена 3", fileName: "alarm3"),
      SoundModel(name: "Филл Бот тревога", fileName: "fill_alarm"),
      SoundModel(name: "Филл Бот тревога (UA)", fileName: "fill_alarm_ua"),
      SoundModel(name: "Сигнал", fileName: "beep"),
      SoundModel(name: "Сигнал 2", fileName: "beep2"),
      SoundModel(name: "Сигнал + бот", fileName: "beep_fill_alarm"),
    ];
  }

  static List<SoundModel> _getCancelSong() {
    return [
      SoundModel(name: "Без звука", fileName: ""),
      SoundModel(name: "Системная отмена", fileName: "cancel_alarm"),
      SoundModel(name: "Филл Бот отмена", fileName: "fill_cancel"),
      SoundModel(name: "Филл Бот отмена (UA)", fileName: "fill_cancel_ua"),
      SoundModel(name: "Сигнал", fileName: "beep_cancel"),
      SoundModel(name: "Сигнал 2", fileName: "beep_cancel2"),
    ];
  }
}
