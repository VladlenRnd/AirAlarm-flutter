import 'package:flutter/material.dart';

import '../../../../models/region_model.dart';
import '../../../../service/firebase_config_service.dart';
import '../../../../service/settings_service.dart';
import '../../../../tools/custom_color.dart';
import '../../../../tools/ui_tools.dart';

enum EInfoWidgetType { main, auxiliary, globalAlarm }

class InfoWidget extends StatelessWidget {
  final RegionModel? selectRegion;

  final Function()? onClose;
  final Function()? onSave;

  final EInfoWidgetType widgetType;

  const InfoWidget.infoWidget({super.key, required this.selectRegion})
      : widgetType = EInfoWidgetType.main,
        onClose = null,
        onSave = null;

  const InfoWidget.auxiliaryInfoWidget({super.key, required this.selectRegion, required this.onSave, required this.onClose})
      : widgetType = EInfoWidgetType.auxiliary;

  const InfoWidget.globalAlarmWidget({super.key})
      : widgetType = EInfoWidgetType.globalAlarm,
        onClose = null,
        onSave = null,
        selectRegion = null;

  @override
  Widget build(BuildContext context) {
    switch (widgetType) {
      case EInfoWidgetType.main:
        return Column(
          children: [
            _buildContaner(_buildMainInfo()),
            const SizedBox(height: 10),
            if (Config.isWar == true && Config.startWarDate != null) _buildContaner(_buildDayWar()),
          ],
        );
      case EInfoWidgetType.auxiliary:
        return _buildContaner(_buildAuxiliaryWidget());
      case EInfoWidgetType.globalAlarm:
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: _buildContaner(
            const Text("Масштабная воздушная тревога", textAlign: TextAlign.center, style: TextStyle(color: CustomColor.airAlert, fontSize: 16)),
          ),
        );
    }
  }

  Widget _buildAuxiliaryWidget() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Text("TEST1", style: TextStyle(fontSize: 24, fontWeight: FontWeight.w700, color: UiTools.getAlarmColor(selectRegion!))),
        Text("TEST2", style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w400)),
        const SizedBox(height: 15),
        const Divider(),
        // _buildAtantion(selectRegion!.districts, selectRegion!.isAlarm),
        // selectRegion!.isAlarm ? _buildAlertData() : _buildNoAlertData(),
        const Divider(),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            TextButton(onPressed: () => onClose?.call(), child: Text('Закрыть'.toUpperCase(), style: const TextStyle(color: CustomColor.textColor))),
            if (!_isAutoSearch())
              ElevatedButton(
                onPressed: () => onSave?.call(),
                child: const Text("Отслеживать", style: TextStyle(color: CustomColor.textColor)),
              ),
          ],
        ),
      ],
    );
  }

  bool _isAutoSearch() => (SettingsService.isAutoSearch ?? false);

  Widget _buildDayWar() {
    int warDay = DateTime.now().difference(Config.startWarDate!).inDays + 1;
    return Text("$warDay день войны", textAlign: TextAlign.center, style: const TextStyle(color: CustomColor.airAlert, fontSize: 15));
  }

  Widget _buildMainInfo() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Text("TEST1", style: TextStyle(fontSize: 24, fontWeight: FontWeight.w700, color: UiTools.getAlarmColor(selectRegion!))),
        Text("TEST2", style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w400)),
        const SizedBox(height: 15),
        const Divider(),
        // _buildAtantion(selectRegion!.districts, selectRegion!.isAlarm),
        // selectRegion!.isAlarm ? _buildAlertData() : _buildNoAlertData(),
        _buildSettingInfo(),
      ],
    );
  }

  Widget _buildSettingInfo() {
    List<Widget> widget = [
      if (_isAutoSearch()) _buildValue(name: "Авто определение области", value: "Вкл", colorValue: CustomColor.noAlert),
    ];

    if (widget.isNotEmpty) widget.insert(0, const Divider());

    return Column(children: widget);
  }

  Widget _buildContaner(Widget child) {
    return Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        width: double.infinity,
        decoration: BoxDecoration(
          color: CustomColor.backgroundCard,
          borderRadius: BorderRadius.circular(8),
        ),
        child: child);
  }

  // Widget _buildAtantion(List<DistrictModel> listDistrict, bool isAlarm) {
  //   if (isAlarm) return const SizedBox.shrink();
  //   List<DistrictModel> alarmDistrict = [...listDistrict.where((element) => element.isAlarm == true)];

  //   if (alarmDistrict.isEmpty) return const SizedBox.shrink();

  //   return Column(
  //     children: [
  //       for (int i = 0; i < alarmDistrict.length; i++)
  //         _buildValue(
  //           colorTitle: CustomColor.atantion,
  //           name: alarmDistrict[i].title,
  //           value: alarmDistrict[i].timeStart,
  //         ),
  //       const Divider(),
  //     ],
  //   );
  // }

  // Widget _buildAlertData() {
  //   return Column(
  //     children: [
  //       _buildValue(name: "Время тревоги", value: selectRegion!.timeDurationAlarmStr),
  //       _buildValue(name: "Начало тревоги", value: selectRegion!.timeStartStr),
  //     ],
  //   );
  // }

  // Widget _buildNoAlertData() {
  //   return Column(
  //     children: [
  //       _buildValue(name: "Время без тревоги", value: selectRegion!.timeDurationCancelAlarmStr),
  //       _buildValue(name: "Конец тревоги", value: selectRegion!.timeEndStr),
  //     ],
  //   );
  // }

  Widget _buildValue(
      {required String name, required String? value, Color? colorTitle = CustomColor.textColor, Color? colorValue = CustomColor.textColor}) {
    if (value == null) return const SizedBox.shrink();
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 7),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(child: Text(name, style: TextStyle(color: colorTitle))),
          Text(value, style: TextStyle(color: colorValue), textAlign: TextAlign.end),
        ],
      ),
    );
  }
}
