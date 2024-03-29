import 'dart:ui';

import 'package:flutter/material.dart';

import '../tools/custom_color.dart';
import '../tools/update_info.dart';

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
              TextButton(onPressed: () => Navigator.of(context).pop(false), child: Text('Закрыть'.toUpperCase())),
              MaterialButton(
                  onPressed: () => Navigator.of(context).pop(true), color: CustomColor.primaryGreen.withOpacity(0.5), child: const Text("Обновить")),
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
      Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: UpdateInfo.infoUpdate.descroption.map((data) => _buildTextDescription(data)).toList()),
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
            color: Colors.grey,
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
      const Text("Доступна новая версия", textAlign: TextAlign.center),
      const Padding(padding: EdgeInsets.symmetric(vertical: 5)),
      Container(
          width: 80,
          height: 30,
          decoration: BoxDecoration(
            color: CustomColor.primaryGreen.withOpacity(0.5),
            borderRadius: BorderRadius.circular(15),
          ),
          child: Center(
            child: Text(UpdateInfo.infoUpdate.newVersion),
          )),
    ],
  );
}
