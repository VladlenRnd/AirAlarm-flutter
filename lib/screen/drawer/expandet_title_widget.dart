import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import '../../tools/custom_color.dart';

class ExpandedTitleWidget extends StatelessWidget {
  final String title;
  final IconData icons;
  final Color iconColor;
  final Widget child;

  const ExpandedTitleWidget(
      {required this.title, required this.icons, required this.iconColor, required this.child, super.key});

  @override
  Widget build(BuildContext context) {
    return ExpandablePanel(
      collapsed: const SizedBox.shrink(),
      expanded: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 0),
        child: child,
      ),
      header: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Row(
            children: [
              Icon(icons, color: iconColor),
              const Padding(padding: EdgeInsets.symmetric(horizontal: 8)),
              Text(
                title,
                style: Theme.of(context).textTheme.titleLarge!.copyWith(color: Colors.white),
              ),
            ],
          )),
      theme: const ExpandableThemeData(
        iconColor: CustomColor.textColor,
        headerAlignment: ExpandablePanelHeaderAlignment.center,
        iconPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      ),
    );
  }
}
