// ignore_for_file: use_build_context_synchronously

import 'dart:ui';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

import '../../screen/select_region/select_region_screen.dart';
import '../../service/shered_preferences_service.dart';
import '../../tools/custom_color.dart';

String _selectValue = "";

Future<void> showSubscribeDialog(BuildContext context) async {
  bool isSave = false;
  await showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) {
      return StatefulBuilder(
        builder: ((BuildContext context, void Function(Function()) setState) {
          if (!isSave) {
            return BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                child: AlertDialog(
                  title: const Text("Отслеживание тревоги", textAlign: TextAlign.center),
                  contentPadding: const EdgeInsets.only(top: 15),
                  backgroundColor: CustomColor.backgroundLight,
                  insetPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
                  content: SelectRegionWidget(
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
                          setState(() => isSave = true);
                          await _saveSubscribe();
                          Navigator.of(context).pop();
                        },
                        color: CustomColor.primaryGreen.withOpacity(0.5),
                        child: const Text("Сохранить")),
                  ],
                ));
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
