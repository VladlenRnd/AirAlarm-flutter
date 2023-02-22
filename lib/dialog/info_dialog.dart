import 'dart:ui';

import 'package:flutter/material.dart';

import '../tools/custom_color.dart';

class _InfoDialog extends StatelessWidget {
  final String title;
  final String contenInfo;
  final String actionButtonStr;
  final String closeButtonStr;
  final Widget? icon;

  const _InfoDialog({required this.title, required this.contenInfo, required this.actionButtonStr, required this.closeButtonStr, required this.icon});

  @override
  Widget build(BuildContext context) {
    return BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
        child: AlertDialog(
          title: Text(title, textAlign: TextAlign.center),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              icon ?? const SizedBox.shrink(),
              const SizedBox(height: 15),
              Text(contenInfo, textAlign: TextAlign.center),
            ],
          ),
          actionsAlignment: MainAxisAlignment.center,
          actionsOverflowAlignment: OverflowBarAlignment.center,
          actions: [
            ElevatedButton(
                onPressed: () async {
                  Navigator.of(context).pop(true);
                },
                style: ButtonStyle(backgroundColor: MaterialStateProperty.all<Color>(CustomColor.systemSecondary)),
                child: Text(actionButtonStr)),
            TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: Text(
                  closeButtonStr,
                )),
          ],
        ));
  }
}

Future<bool> showInfoDialog(BuildContext context,
    {required String title, required String contenInfo, required String actionButtonStr, String closeButtonStr = "ЗАКРЫТЬ", Widget? icon}) async {
  return await showDialog(
    context: context,
    builder: (context) =>
        _InfoDialog(title: title, actionButtonStr: actionButtonStr, closeButtonStr: closeButtonStr, contenInfo: contenInfo, icon: icon),
  );
}
