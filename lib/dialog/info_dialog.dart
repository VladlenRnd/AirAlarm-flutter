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
    return AlertDialog(
      title: Text(title, textAlign: TextAlign.center),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          icon ?? const SizedBox.shrink(),
          const SizedBox(height: 15),
          Text(contenInfo, textAlign: TextAlign.center),
        ],
      ),
      actions: [
        TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text(
              closeButtonStr,
            )),
        MaterialButton(
            onPressed: () async {
              Navigator.of(context).pop(true);
            },
            color: CustomColor.primaryGreen.withOpacity(0.5),
            child: Text(actionButtonStr)),
      ],
    );
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
