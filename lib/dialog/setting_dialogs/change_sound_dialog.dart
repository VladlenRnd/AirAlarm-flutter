import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

import '../../models/sound_model.dart';
import '../../service/notification_service.dart';
import '../../service/shered_preferences_service.dart';
import '../../tools/custom_color.dart';

String _selectValue = "";
AudioCache? _player;
AudioPlayer? _controller;

Future<void> showChangeSoundDialog(BuildContext context, bool isAlarmSound) async {
  bool _isSave = false;
  _selectValue = SheredPreferencesService.preferences.getString(isAlarmSound ? "alarmSong" : "cancelSong")!;
  _player = AudioCache(prefix: "assets/song/" + (isAlarmSound ? "alarm/" : "cancel/"));
  await showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) {
      return StatefulBuilder(
        builder: ((BuildContext context, void Function(Function()) setState) {
          if (!_isSave) {
            return AlertDialog(
              title: Text(isAlarmSound ? "Звук тревоги" : "Звук отмены тревоги", textAlign: TextAlign.center),
              backgroundColor: CustomColor.background,
              contentPadding: const EdgeInsets.only(top: 15),
              content: _buildSelectSound(isAlarmSound, setState),
              actionsAlignment: MainAxisAlignment.spaceBetween,
              actions: <Widget>[
                TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: Text(
                      'Закрыть'.toUpperCase(),
                    )),
                MaterialButton(
                    onPressed: () async {
                      setState(() => _isSave = true);
                      SheredPreferencesService.preferences.setString(isAlarmSound ? "alarmSong" : "cancelSong", _selectValue);
                      NotificationService.init();
                      Navigator.of(context).pop();
                    },
                    child: const Text("Сохранить"),
                    color: CustomColor.primaryGreen.withOpacity(0.5)),
              ],
            );
          }
          return _buildSaveLoad();
        }),
      );
    },
  ).then((value) async {
    _controller?.stop();
    _controller?.dispose();
    await _player?.clearAll();
    _controller = null;
    _player = null;
  });
}

Widget _buildItem(String title, String fileName, void Function(Function()) setState) {
  return Container(
    margin: const EdgeInsets.symmetric(vertical: 5),
    padding: const EdgeInsets.symmetric(horizontal: 12),
    height: 50,
    color: CustomColor.backgroundLight,
    child: CupertinoButton(
      padding: EdgeInsets.zero,
      onPressed: () {
        setState(() {
          _selectValue = fileName;
        });
      },
      child: Row(
        children: [
          fileName == _selectValue ? const Icon(Icons.done, color: CustomColor.green, size: 24) : const SizedBox(height: 24, width: 24),
          const Padding(padding: EdgeInsets.symmetric(horizontal: 5)),
          Text(
            title,
            style: TextStyle(fontSize: 15, color: CustomColor.textColor, fontFamily: "Days"),
          ),
          const Spacer(),
          if (fileName.isNotEmpty)
            IconButton(
              onPressed: () async {
                await _controller?.stop();
                _controller = await _player?.play("$fileName.mp3", mode: PlayerMode.LOW_LATENCY, volume: 0.1);
              },
              splashRadius: 25,
              icon: Icon(Icons.play_arrow_rounded, color: CustomColor.textColor),
            )
        ],
      ),
    ),
  );
}

Widget _buildSelectSound(bool isAlarmSound, void Function(Function()) setState) {
  return SingleChildScrollView(
    child: Column(
      children: isAlarmSound
          ? SoundService.alarmSound.map((e) => _buildItem(e.name, e.fileName, setState)).toList()
          : SoundService.cancelSound.map((e) => _buildItem(e.name, e.fileName, setState)).toList(),
    ),
  );
}

Widget _buildSaveLoad() {
  return Center(
    child: SizedBox(
        height: 200,
        child: Column(
          children: [
            const Text("Сохранение...", style: TextStyle(fontSize: 30)),
            SizedBox(
              height: 100,
              width: 100,
              child: Lottie.asset(
                'assets/lottie/load.json',
                width: 100,
                height: 100,
                frameRate: FrameRate(60),
              ),
            )
          ],
        )),
  );
}
