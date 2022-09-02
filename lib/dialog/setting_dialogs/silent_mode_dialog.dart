import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

import '../../screen/settings/sillent_mode_setting_screan.dart';
import '../../service/shered_preferences_service.dart';
import '../../tools/custom_color.dart';

Future<void> showSilentModeDialog(BuildContext context) async {
  bool _isSave = false;
  TimeOfDay? newStartTime;
  TimeOfDay? newEndTime;

  await showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) {
      return StatefulBuilder(
        builder: ((BuildContext context, void Function(Function()) setState) {
          if (!_isSave) {
            return AlertDialog(
              titlePadding: EdgeInsets.zero,
              contentPadding: EdgeInsets.zero,
              content: SilentModeSettingScrean(
                onChange: (TimeOfDay timeStart, TimeOfDay timeEnd) {
                  newStartTime = timeStart;
                  newEndTime = timeEnd;
                },
                onClear: () async {
                  await SheredPreferencesService.preferences.setStringList("siledStart", []);
                  await SheredPreferencesService.preferences.setStringList("siledEnd", []);
                },
              ),
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
                      await _onSave(newStartTime, newEndTime);
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
  ).then((value) async {});
}

Future<void> _onSave(TimeOfDay? newStartTime, TimeOfDay? newEndTime) async {
  if (newStartTime != null && newEndTime != null) {
    await SheredPreferencesService.preferences.setStringList("siledStart", [newStartTime.hour.toString(), newStartTime.minute.toString()]);
    await SheredPreferencesService.preferences.setStringList("siledEnd", [newEndTime.hour.toString(), newEndTime.minute.toString()]);
  }
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
