import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../tools/custom_color.dart';
import '../../../widget/history_list_widget.dart';
import '../bloc/history_bloc.dart';

class TabListHistoryWidget extends StatelessWidget {
  final HistoryLoadedState state;
  final Function(DateTimeRange)? onChangeData;
  const TabListHistoryWidget({super.key, required this.state, this.onChangeData});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildCalendar(state.minDate, state.maxData, state.selectStartData, state.selectEndData, context),
        Container(
          height: 160,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            color: CustomColor.listCardColor,
          ),
          margin: const EdgeInsets.symmetric(horizontal: 5, vertical: 10),
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 5),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: _buildTitleData("Количество тревог за ", "период", Colors.purple.shade300, state.countAllAlarm),
                  ),
                  Expanded(
                    child: _buildTitleData("Общее время тревог за ", "период", Colors.purple.shade300, state.timeAllAlarm),
                  ),
                  Expanded(
                      child: Tooltip(
                    triggerMode: TooltipTriggerMode.tap,
                    showDuration: const Duration(seconds: 3),
                    message: state.lognTimeAlarm.date == null ? "-" : DateFormat("dd/MM/yyyy").format(state.lognTimeAlarm.date!),
                    child: _buildTitleData("Самая длиная тревога за ", "период", Colors.purple.shade300, state.lognTimeAlarm.value ?? "-"),
                  )),
                ],
              ),
              Container(height: 1, color: Colors.black),
              Row(
                children: [
                  Expanded(
                    child: _buildTitleData("Количество тревог за ", "текущий месяц", Colors.green.shade600, state.countMonthAlarm),
                  ),
                  Expanded(
                    child: _buildTitleData("Количество тревог за ", "текущую неделю", Colors.blue.shade600, state.countSevenDayAlarm),
                  ),
                  Expanded(
                      child: Tooltip(
                    triggerMode: TooltipTriggerMode.tap,
                    showDuration: const Duration(seconds: 3),
                    message: state.shortTimeAlarm.date == null ? "-" : DateFormat("dd/MM/yyyy").format(state.shortTimeAlarm.date!),
                    child: _buildTitleData("Самая короткая тревога за ", "период", Colors.purple.shade300, state.shortTimeAlarm.value ?? "-"),
                  ))
                ],
              ),
            ],
          ),
        ),
        Container(
          color: Colors.black,
          height: 5,
        ),
        Expanded(
          child: HistoryListWidget(historyData: state.historyData),
        ),
      ],
    );
  }

  Widget _buildCalendar(DateTime first, DateTime last, DateTime selectFirst, DateTime selectLast, BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 24),
      child: Column(
        children: [
          Text("Период", style: TextStyle(fontSize: 15, color: CustomColor.textColor)),
          OutlinedButton(
              onPressed: () async {
                await showDateRangePicker(
                  context: context,
                  firstDate: first,
                  lastDate: last,
                  initialEntryMode: DatePickerEntryMode.calendarOnly,
                  initialDateRange: DateTimeRange(start: selectFirst, end: selectLast),
                ).then((value) {
                  if (value != null) onChangeData?.call(value);
                });
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    DateFormat("dd/MM/yyyy").format(selectFirst),
                    style: TextStyle(fontSize: 18, color: CustomColor.textColor, fontFamily: "Days"),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 5),
                    child: Text(
                      "-",
                      style: TextStyle(fontSize: 18, color: CustomColor.textColor, fontFamily: "Days"),
                    ),
                  ),
                  Text(
                    DateFormat("dd/MM/yyyy").format(selectLast),
                    style: TextStyle(fontSize: 18, color: CustomColor.textColor, fontFamily: "Days"),
                  ),
                ],
              )),
        ],
      ),
    );
  }

  Widget _buildTitleData(String title, String titleTwo, Color titleTwoColor, String data) {
    return SizedBox(
      height: 50,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          RichText(
            textAlign: TextAlign.center,
            text: TextSpan(
              text: title,
              style: TextStyle(fontSize: 12, color: CustomColor.textColor.withOpacity(0.6), fontFamily: "Days"),
              children: [
                TextSpan(
                  text: titleTwo,
                  style: TextStyle(fontSize: 12, color: titleTwoColor),
                ),
              ],
            ),
          ),
          const SizedBox(height: 5),
          Text(data, style: TextStyle(fontSize: 14, fontFamily: "Days", color: CustomColor.textColor)),
        ],
      ),
    );
  }
}
