import 'package:alarm/tools/ui_tools.dart';
import 'package:flutter/material.dart';

import '../../../models/region_model.dart';
import '../../../tools/custom_color.dart';

class CardList extends StatefulWidget {
  final RegionModel model;
  const CardList({Key? key, required this.model}) : super(key: key);

  @override
  State<CardList> createState() => _CardListState();
}

class _CardListState extends State<CardList> {
  double boxSize = 0;
  late bool isAlarmDistrict;
  @override
  Widget build(BuildContext context) {
    isAlarmDistrict = widget.model.districts.any((element) => element.isAlarm);
    return Container(
      height: 155,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            widget.model.isAlarm
                ? CustomColor.listCardColor.withRed(35)
                : isAlarmDistrict
                    ? CustomColor.listCardColor.withRed(40).withGreen(40)
                    : CustomColor.listCardColor.withGreen(35),
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
                    widget.model.region.title,
                    style: const TextStyle(
                      color: CustomColor.textColor,
                      fontSize: 13,
                    ),
                  ),
                  Text(
                    widget.model.isAlarm
                        ? "Воздушная тревога"
                        : isAlarmDistrict
                            ? "Повышенная опасность"
                            : "Тревоги нет",
                    style: TextStyle(
                      color: widget.model.isAlarm
                          ? CustomColor.red
                          : isAlarmDistrict
                              ? CustomColor.colorMapAtantion
                              : CustomColor.green,
                      fontSize: 16,
                    ),
                  ),
                  const Padding(padding: EdgeInsets.symmetric(vertical: 2)),
                  if (!isAlarmDistrict || widget.model.isAlarm) _buildTimer(widget.model.timeDurationAlarm, widget.model.timeDurationCancelAlarm),
                  const Divider(),
                  _buildDate(widget.model.timeStart, widget.model.timeEnd),
                ],
              ),
            ),
            Expanded(
              flex: 2,
              child: Align(
                alignment: Alignment.centerRight,
                child: UiTools.buildIconStatus(widget.model.isAlarm, isAlarmDistrict),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDate(String? timeStart, String? timeEnd) {
    if (timeStart != null) {
      return Text(
        "Начало тревоги: \n$timeStart",
        style: const TextStyle(color: CustomColor.textColor),
      );
    } else if (timeEnd != null) {
      return Text(
        "Конец тревоги: \n$timeEnd",
        style: const TextStyle(color: CustomColor.textColor),
      );
    } else {
      return const SizedBox.shrink();
    }
  }

  Widget _buildTimer(String? startAlarm, String? endAlarm) {
    if (startAlarm != null) {
      return Text(startAlarm == "0:00" ? "Только что" : "Тревога в области длится: \n$startAlarm",
          textAlign: TextAlign.start, style: const TextStyle(fontSize: 14, color: CustomColor.red));
    } else if (endAlarm != null) {
      return Text(endAlarm == "0:00" ? "Только что" : "Без тревоги по области: \n$endAlarm",
          textAlign: TextAlign.start, style: const TextStyle(fontSize: 14, color: CustomColor.green));
    } else {
      return const SizedBox.shrink();
    }
  }
}
