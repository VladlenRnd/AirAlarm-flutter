import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../service/shered_preferences_service.dart';
import '../../tools/custom_color.dart';

class SilentModeSettingScrean extends StatefulWidget {
  final Function(TimeOfDay newTimeStart, TimeOfDay newTimeEnd) onChange;
  final Function() onClear;
  const SilentModeSettingScrean({Key? key, required this.onChange, required this.onClear}) : super(key: key);

  @override
  State<SilentModeSettingScrean> createState() => _SilentModeSettingScreanState();
}

class _SilentModeSettingScreanState extends State<SilentModeSettingScrean> {
  late List<String> startList;
  late List<String> endList;

  TimeOfDay? silentStart;
  TimeOfDay? silentEnd;

  late bool _getInChangeTime;
  bool _isSilentModeOn = false;

  @override
  void initState() {
    startList = SheredPreferencesService.preferences.getStringList("siledStart")!;
    endList = SheredPreferencesService.preferences.getStringList("siledEnd")!;

    _isSilentModeOn = (startList.isNotEmpty && endList.isNotEmpty);
    _getInChangeTime = (silentStart != null && silentEnd != null);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _isSilentModeOn = (startList.isNotEmpty && endList.isNotEmpty);
    _getInChangeTime = (silentStart != null && silentEnd != null);
    return SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 20),
            child: Text("Режим тишины", textAlign: TextAlign.center, style: TextStyle(fontSize: 24)),
          ),
          _buildDescription(),
          _buildBody(context),
        ],
      ),
    );
  }

  Widget _buildBody(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 10),
      child: Container(
        width: double.infinity,
        color: CustomColor.background,
        child: Padding(
          padding: const EdgeInsets.only(top: 10),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: _buildInfoSilent(context, silentStart, silentEnd),
              ),
              const Padding(padding: EdgeInsets.symmetric(vertical: 10)),
              ElevatedButton(
                child: Text("Выбрать время", style: TextStyle(color: CustomColor.textColor)),
                style: ButtonStyle(backgroundColor: MaterialStateProperty.all<Color>(CustomColor.backgroundLight)),
                onPressed: () async {
                  TimeOfDay? startTime;
                  TimeOfDay? endTime;
                  startTime = await showTimePicker(
                      context: context,
                      initialTime: const TimeOfDay(hour: 0, minute: 0),
                      helpText: "Выберите время начала тихого режима",
                      hourLabelText: "Часы",
                      minuteLabelText: "Минуты",
                      initialEntryMode: TimePickerEntryMode.input,
                      cancelText: "Закрыть",
                      errorInvalidText: "Не правильно выбранно время",
                      confirmText: "Сохранить");

                  if (startTime != null) {
                    endTime = await showTimePicker(
                        context: context,
                        initialTime: TimeOfDay(hour: startTime.hour == 23 ? 0 : startTime.hour + 1, minute: startTime.minute),
                        helpText: "Выберите время конца тихого режима",
                        hourLabelText: "Часы",
                        minuteLabelText: "Минуты",
                        initialEntryMode: TimePickerEntryMode.input,
                        cancelText: "Закрыть",
                        errorInvalidText: "Не правильно выбранно время",
                        confirmText: "Сохранить");
                  }

                  if (startTime != null && endTime != null) {
                    setState(() {
                      silentStart = startTime;
                      silentEnd = endTime;
                    });
                    widget.onChange.call(startTime, endTime);
                  }
                },
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 15),
                child: _isSilentModeOn
                    ? CupertinoButton(
                        onPressed: () async {
                          widget.onClear.call();
                          silentStart = null;
                          silentEnd = null;
                          startList = [];
                          endList = [];
                          setState(() {});
                        },
                        child: const Text("Выключить тихий режим"),
                      )
                    : const SizedBox.shrink(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoSilent(BuildContext context, TimeOfDay? silentStart, TimeOfDay? silentEnd) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          _isSilentModeOn ? "Режим тишины включен" : "Режим тишины выключен",
          style: TextStyle(fontSize: 17, color: _isSilentModeOn ? Colors.green.withOpacity(0.7) : Colors.red.withOpacity(0.7)),
        ),
        const Padding(padding: EdgeInsets.symmetric(vertical: 5)),
        _isSilentModeOn
            ? Text(
                "Вам не будут приходить звуковые уведомления",
                style: TextStyle(fontSize: 12, color: Colors.white.withOpacity(0.7)),
                textAlign: TextAlign.center,
              )
            : const SizedBox.shrink(),
        const Padding(padding: EdgeInsets.symmetric(vertical: 5)),
        _buildTimeWidget(context, silentStart, silentEnd),
        _getInChangeTime ? const Padding(padding: EdgeInsets.symmetric(vertical: 5)) : const SizedBox.shrink(),
        _getInChangeTime
            ? const Text(
                "Для применнения новых значений нажмите 'Сохранить'",
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.amber, fontSize: 12),
              )
            : const SizedBox.shrink(),
      ],
    );
  }

  Widget _buildDescription() {
    return const ColoredBox(
      color: CustomColor.background,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24, vertical: 10),
        child: Text(
          "Этот режим позволяет убрать звук оповещение о тревоги и её отмене в определённый промежуток времени",
          style: TextStyle(fontSize: 13),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }

  String _getFormadedTime(String min, String hours, BuildContext context) =>
      TimeOfDay(hour: int.parse(min), minute: int.parse(hours)).format(context);

  Widget _buildTimeWidget(BuildContext context, TimeOfDay? silentStart, TimeOfDay? silentEnd) {
    if (_getInChangeTime) {
      return RichText(
        text: TextSpan(
          children: [
            const TextSpan(text: "с "),
            TextSpan(text: silentStart!.format(context), style: const TextStyle(color: Colors.amber)),
            const TextSpan(text: " по "),
            TextSpan(text: silentEnd!.format(context), style: const TextStyle(color: Colors.amber)),
          ],
        ),
      );
    } else if (_isSilentModeOn) {
      return RichText(
        text: TextSpan(
          children: [
            const TextSpan(text: "с "),
            TextSpan(text: _getFormadedTime(startList[0], startList[1], context)),
            const TextSpan(text: " по "),
            TextSpan(text: _getFormadedTime(endList[0], endList[1], context))
          ],
        ),
      );
    }
    return const SizedBox.shrink();
  }
}
