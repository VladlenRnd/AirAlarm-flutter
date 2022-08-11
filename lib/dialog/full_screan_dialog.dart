import 'package:flutter/material.dart';

void showFullScreanDialog(BuildContext context, String img) {
  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        content: _buildDescription(img),
        contentPadding: EdgeInsets.zero,
        insetPadding: EdgeInsets.zero,
        actionsAlignment: MainAxisAlignment.spaceBetween,
        actions: <Widget>[
          TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(
                'Закрыть'.toUpperCase(),
              )),
        ],
      );
    },
  );
}

Widget _buildDescription(String url) {
  return InteractiveViewer(
      maxScale: 4,
      minScale: 1,
      child: Image.network(
        url,
        fit: BoxFit.fill,
        errorBuilder: (context, error, stackTrace) => const SizedBox.shrink(),
      ));
}
