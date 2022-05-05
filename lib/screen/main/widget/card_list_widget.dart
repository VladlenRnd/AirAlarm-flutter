import 'package:alarm/tools/custom_color.dart';
import 'package:flutter/material.dart';

import '../../../tools/region_model.dart';
import '../../../tools/region_title.dart';

class CardList extends StatefulWidget {
  final RegionModel model;
  const CardList({Key? key, required this.model}) : super(key: key);

  @override
  State<CardList> createState() => _CardListState();
}

class _CardListState extends State<CardList> {
  double boxSize = 0;
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 150,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            widget.model.isAlarm ? CustomColor.listCardColor.withRed(35) : CustomColor.listCardColor.withGreen(35),
            CustomColor.listCardColor,
          ],
        ),
        borderRadius: const BorderRadius.all(Radius.circular(5)),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 13),
        child: Row(
          children: [
            Expanded(
              flex: 5,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    RegionTitle.getRegionByEnum(widget.model.region),
                    style: TextStyle(
                      color: CustomColor.textColor,
                      fontSize: 15,
                    ),
                  ),
                  Text(
                    widget.model.isAlarm ? "Воздушная тревога" : "Тревоги нет",
                    style: TextStyle(
                      color: widget.model.isAlarm ? CustomColor.red : CustomColor.green,
                      fontSize: 23,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Padding(padding: EdgeInsets.symmetric(vertical: 2)),
                  _buildTimer(widget.model.timeDurationAlarm, widget.model.timeDurationCancelAlarm),
                  const Divider(),
                  _buildDate(widget.model.timeStart, widget.model.timeEnd),
                ],
              ),
            ),
            Expanded(
                flex: 2,
                child: Align(
                  alignment: Alignment.centerRight,
                  child: _buildIcon(widget.model.isAlarm),
                ))
          ],
        ),
      ),
    );
  }

  Widget _buildDate(String? timeStart, String? timeEnd) {
    if (timeStart != null) {
      return Text(
        "Начало тревоги: \n$timeStart",
        style: TextStyle(color: CustomColor.textColor),
      );
    } else if (timeEnd != null) {
      return Text(
        "Конец тревоги: \n$timeEnd",
        style: TextStyle(color: CustomColor.textColor),
      );
    } else {
      return const SizedBox.shrink();
    }
  }

  Widget _buildTimer(String? startAlarm, String? endAlarm) {
    if (startAlarm != null) {
      return Text("Тревога длится: $startAlarm", textAlign: TextAlign.center, style: TextStyle(fontSize: 16, color: CustomColor.red));
    } else if (endAlarm != null) {
      return Text("Без тревоги: $endAlarm", textAlign: TextAlign.center, style: TextStyle(fontSize: 16, color: CustomColor.green));
    } else {
      return const SizedBox.shrink();
    }
  }

  Widget _buildIcon(bool isAlarm) {
    return Icon(
      isAlarm ? Icons.warning_amber_rounded : Icons.gpp_good_outlined,
      color: isAlarm ? CustomColor.red : CustomColor.green,
      size: 60,
    );
  }
}
