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
      SoundModel(name: "Филл Бот тревога", fileName: "fill_alarm"),
    ];
  }

  static List<SoundModel> _getCancelSong() {
    return [
      SoundModel(name: "Без звука", fileName: ""),
      SoundModel(name: "Системная отмена", fileName: "cancel_alarm"),
      SoundModel(name: "Филл Бот отмена", fileName: "fill_cancel"),
    ];
  }
}
