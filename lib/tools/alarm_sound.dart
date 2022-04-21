import 'package:assets_audio_player/assets_audio_player.dart';

class AlarmSound {
  static final AssetsAudioPlayer _alarmSound = AssetsAudioPlayer.newPlayer();

  static void init() {
    _alarmSound.open(
      Audio("assets/sound/alarm.mp3"),
      autoStart: false,
      volume: 1.0,
      showNotification: false,
      loopMode: LoopMode.single,
    );
  }

  static void startAlarm() {
    if (!_alarmSound.isPlaying.value) {
      _alarmSound.play();
    }
  }

  static void stopAparm() {
    _alarmSound.stop();
  }
}
