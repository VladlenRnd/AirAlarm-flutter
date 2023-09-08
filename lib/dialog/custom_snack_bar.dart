import 'package:flutter/material.dart';

import '../tools/custom_color.dart';

class CustomSnackBar {
  final String title;
  final BuildContext context;
  final Duration duration;

  CustomSnackBar.success(this.context, {required this.title, this.duration = const Duration(seconds: 4)}) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Row(
        children: [
          const Icon(Icons.done_outline_sharp, color: CustomColor.green),
          const SizedBox(width: 15),
          Expanded(
              child: Text(
            title,
            style: const TextStyle(color: CustomColor.green),
          )),
        ],
      ),
      duration: duration,
      backgroundColor: CustomColor.backgroundLight,
    ));
  }

  CustomSnackBar.error(this.context, {required this.title, this.duration = const Duration(seconds: 4)}) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Row(
        children: [
          const Icon(Icons.error_outline, color: CustomColor.red),
          const SizedBox(width: 15),
          Expanded(
              child: Text(
            title,
            style: const TextStyle(color: CustomColor.red),
          )),
        ],
      ),
      backgroundColor: CustomColor.backgroundLight,
    ));
  }
}
