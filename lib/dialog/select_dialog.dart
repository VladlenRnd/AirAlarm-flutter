import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../tools/custom_color.dart';

class _SelectDialog<T> extends StatelessWidget {
  final String title;
  final List<T> elementList;
  final T selectElement;
  final Function(T, bool) elementWidget;

  const _SelectDialog({required this.title, required this.elementList, required this.elementWidget, required this.selectElement});

  @override
  Widget build(BuildContext context) {
    return BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
      child: AlertDialog(
          contentPadding: const EdgeInsets.only(top: 15),
          titlePadding: const EdgeInsets.only(top: 20, right: 24, left: 24),
          titleTextStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
          actions: [
            TextButton(onPressed: () => Navigator.of(context).pop(), child: const Text("ЗАКРЫТЬ", style: TextStyle(color: CustomColor.textColor)))
          ],
          title: Text(title, textAlign: TextAlign.center),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: elementList
                  .map((e) => CupertinoButton(
                      padding: EdgeInsets.zero, child: elementWidget.call(e, e == selectElement), onPressed: () => Navigator.of(context).pop(e)))
                  .toList(),
            ),
          )),
    );
  }
}

Future<T?> showSelectDialog<T>(
  BuildContext context, {
  required String title,
  required Function(T element, bool isSelected) widgetElement,
  required List<T> elementList,
  required T selectElement,
}) async {
  return await showDialog<T>(
    context: context,
    builder: (context) => _SelectDialog(
      title: title,
      elementList: elementList,
      elementWidget: widgetElement,
      selectElement: selectElement,
    ),
  );
}
