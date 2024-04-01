import 'dart:ui';

import 'package:flutter/material.dart';

import '../tools/custom_color.dart';

class _InfoDialog extends StatelessWidget {
  final String title;
  final String contenInfo;
  final String actionButtonStr;
  final String closeButtonStr;

  const _InfoDialog({required this.title, required this.contenInfo, required this.actionButtonStr, required this.closeButtonStr});

  @override
  Widget build(BuildContext context) {
    return BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
        child: AlertDialog(
          title: Text(title, textAlign: TextAlign.center),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(contenInfo, textAlign: TextAlign.center),
            ],
          ),
          actionsAlignment: MainAxisAlignment.spaceBetween,
          actionsOverflowAlignment: OverflowBarAlignment.center,
          actions: [
            TextButton(
                onPressed: () => Navigator.of(context).pop(false), child: Text(closeButtonStr, style: const TextStyle(color: CustomColor.textColor))),
            if (actionButtonStr.isNotEmpty)
              ElevatedButton(
                  onPressed: () async {
                    Navigator.of(context).pop(true);
                  },
                  child: Text(actionButtonStr, style: const TextStyle(color: CustomColor.textColor))),
          ],
        ));
  }
}

Future<bool?> showInfoDialog(
  BuildContext context, {
  required String title,
  required String contentInfo,
  required String actionButtonStr,
  String closeButtonStr = "ЗАКРЫТЬ",
}) async {
  return await showDialog(
    context: context,
    builder: (context) => _InfoDialog(title: title, actionButtonStr: actionButtonStr, closeButtonStr: closeButtonStr, contenInfo: contentInfo),
  );
}
