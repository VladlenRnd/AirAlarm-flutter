import 'dart:ui';

import 'package:alarm/tools/custom_color.dart';
import 'package:app_settings/app_settings.dart';
import 'package:flutter/material.dart';

void showPermissionDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (context) {
      return BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
          child: AlertDialog(
            title: Row(
              children: const [
                Icon(Icons.notifications_off_outlined),
                Expanded(
                    child: Text(
                  "Нет разрешения на уведомления",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 22, color: CustomColor.red),
                )),
                Icon(Icons.notifications_off_outlined),
              ],
            ),
            contentPadding: const EdgeInsets.only(top: 15),
            content: Container(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
              color: CustomColor.systemTextBox,
              child: const Text("Что бы получать уведомления о начале и конце тревоги, нужно предоставить разрешения на уведомления в настройках",
                  style: TextStyle(fontSize: 18), textAlign: TextAlign.center),
            ),
            actionsAlignment: MainAxisAlignment.center,
            actions: <Widget>[
              ElevatedButton(
                onPressed: () => AppSettings.openNotificationSettings(callback: () => Navigator.pop(context)),
                style: ButtonStyle(backgroundColor: MaterialStateProperty.all<Color>(CustomColor.systemSecondary)),
                child: const Text("Перейти в настройки"),
              )
            ],
          ));
    },
  );
}
