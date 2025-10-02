import 'dart:ui';

import 'package:flutter/material.dart';

import '../service/firebase_config_service.dart';
import '../tools/custom_color.dart';

Future<bool?> showUpdateDialog(BuildContext context) {
  return showDialog<bool?>(
    context: context,
    builder: (context) {
      return BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
          child: AlertDialog(
            title: _buildTitle(),
            content: _buildDescription(),
            actionsAlignment: MainAxisAlignment.spaceBetween,
            actions: <Widget>[
              TextButton(
                  onPressed: () => Navigator.of(context).pop(false),
                  child: Text('Закрыть'.toUpperCase(), style: const TextStyle(color: CustomColor.textColor))),
              ElevatedButton(
                onPressed: () => Navigator.of(context).pop(true),
                child: const Text("Обновить", style: TextStyle(color: CustomColor.textColor)),
              ),
            ],
          ));
    },
  );
}

Widget _buildDescription() {
  return Column(
    mainAxisSize: MainAxisSize.min,
    children: [
      const Text(
        "В этой версии",
        textAlign: TextAlign.center,
        style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
      ),
      Flexible(
        child: SingleChildScrollView(
          child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: Config.watNew?.discription == null ? [] : Config.watNew!.discription.map((data) => _buildTextDescription(data)).toList()),
        ),
      )
    ],
  );
}

Widget _buildTextDescription(String description) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 5),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 5,
          height: 5,
          margin: const EdgeInsets.only(top: 7),
          decoration: BoxDecoration(
            color: CustomColor.actionColor,
            borderRadius: BorderRadius.circular(15),
          ),
        ),
        const Padding(padding: EdgeInsets.only(right: 5)),
        Expanded(
          child: Text(
            description,
            textAlign: TextAlign.start,
          ),
        )
      ],
    ),
  );
}

Widget _buildTitle() {
  return Column(
    children: [
      const Text("Доступна новая версия", textAlign: TextAlign.center, style: TextStyle(fontSize: 21)),
      const Padding(padding: EdgeInsets.symmetric(vertical: 5)),
      Container(
          padding: const EdgeInsets.all(5),
          decoration: BoxDecoration(
            color: CustomColor.backgroundCard.withValues(alpha: (0.8)),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Center(
            child: Text(Config.watNew?.newVersion ?? "", style: const TextStyle(fontSize: 19)),
          )),
    ],
  );
}
