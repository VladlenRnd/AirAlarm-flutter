import 'dart:ui';

import '../tools/custom_color.dart';
import 'package:flutter/material.dart';

Future<bool?> showConficrDialog(BuildContext context, {required String content, required String title,String? confirmBtn}) {
  return showDialog<bool?>(
    context: context,
    builder: (context) {
      return BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
          child: AlertDialog(
            title: Text(
              title,
              textAlign: TextAlign.center,
            ),
            content: Text(content),
            actionsAlignment: MainAxisAlignment.spaceBetween,
            actions: <Widget>[
              TextButton(
                  onPressed: () => Navigator.of(context).pop(false),
                  child: Text('Закрыть'.toUpperCase(), style: const TextStyle(color: CustomColor.textColor))),
              ElevatedButton(
                onPressed: () => Navigator.of(context).pop(true),
                child: Text( confirmBtn ?? "Подписаться", style: TextStyle(color: CustomColor.textColor)),
              ),
            ],
          ));
    },
  );
}
