import 'package:flutter/material.dart';

import '../../../tools/custom_color.dart';
import '../../../models/region_model.dart';

class CardListSmall extends StatelessWidget {
  final RegionModel region;
  const CardListSmall({required this.region, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        width: 140,
        height: 50,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              CustomColor.listCardColor.withRed(60),
              CustomColor.listCardColor,
            ],
          ),
          borderRadius: const BorderRadius.all(Radius.circular(5)),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 5),
          child: Column(
            children: [
              Text(region.region.title, style: const TextStyle(fontSize: 12), textAlign: TextAlign.center),
              const Spacer(),
              Text(
                region.timeDurationAlarm == "0:00" ? "Только что" : "Тревога длится",
                style: const TextStyle(color: CustomColor.red),
              ),
              Text(
                region.timeDurationAlarm == "0:00" ? "" : region.timeDurationAlarm ?? "",
                style: const TextStyle(color: CustomColor.red),
              ),
            ],
          ),
        ));
  }
}
