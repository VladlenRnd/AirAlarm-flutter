import 'package:flutter/material.dart';

import '../tools/custom_color.dart';

class CustomSnackBar {
  final String title;
  final BuildContext context;
  final Duration duration;
  static bool isOpen = false;

  CustomSnackBar.success(this.context, {required this.title, bool showIsHot = false, this.duration = const Duration(seconds: 4)}) {
    if (!isOpen || showIsHot) {
      isOpen = true;
      if (showIsHot) ScaffoldMessenger.of(context).removeCurrentSnackBar();
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            content: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.done_outline_sharp, color: CustomColor.textColor),
                const SizedBox(width: 15),
                Expanded(
                  child: Text(
                    title,
                    style: const TextStyle(color: CustomColor.textColor),
                  ),
                )
              ],
            ),
            duration: duration,
            backgroundColor: CustomColor.noAlert,
          ))
          .closed
          .then((value) => isOpen = false);
    }
  }

  CustomSnackBar.error(this.context, {required this.title, bool showIsHot = false, this.duration = const Duration(seconds: 4)}) {
    if (!isOpen || showIsHot) {
      isOpen = true;
      if (showIsHot) ScaffoldMessenger.of(context).removeCurrentSnackBar();
      ScaffoldMessenger.of(context)
          .showSnackBar(
            SnackBar(
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              content: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline, color: CustomColor.textColor),
                  const SizedBox(width: 15),
                  Expanded(
                    child: Text(
                      title,
                      style: const TextStyle(color: CustomColor.textColor),
                    ),
                  )
                ],
              ),
              duration: duration,
              backgroundColor: CustomColor.airAlert,
            ),
          )
          .closed
          .then((value) => isOpen = false);
    }
  }
}
