import 'package:alarm/tools/custom_color.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

import '../../screen/select_region/select_region_screen.dart';
import '../../service/shered_preferences_service.dart';

String _selectValue = "";

Future<void> showSubscribeDialog(BuildContext context) async {
  bool _isSave = false;
  await showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) {
      return StatefulBuilder(
        builder: ((BuildContext context, void Function(Function()) setState) {
          if (!_isSave) {
            return AlertDialog(
              title: const Text("Отслеживание тревоги", textAlign: TextAlign.center),
              contentPadding: const EdgeInsets.only(top: 15),
              content: SelectRegionScreen(
                selectRegion: (String selectValue) {
                  _selectValue = selectValue;
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

                      await _saveSubscribe();

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

Future<void> _saveSubscribe() async {
  String saveRegion = SheredPreferencesService.preferences.getString("subscribeRegion")!;
  if (saveRegion != _selectValue && _selectValue.isNotEmpty) {
    await FirebaseMessaging.instance.unsubscribeFromTopic(saveRegion);
    await SheredPreferencesService.preferences.setString("subscribeRegion", _selectValue);
    await FirebaseMessaging.instance.subscribeToTopic(_selectValue);
  }
}
