import 'package:flutter/material.dart';

import '../../models/region_model.dart';
import '../../tools/connection/response/config_response.dart';
import '../../tools/custom_color.dart';
import '../../tools/repository/config_repository.dart';

class CustomEndDrawer extends StatelessWidget {
  final List<RegionModel> alertsRegions;
  const CustomEndDrawer({super.key, required this.alertsRegions});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: CustomColor.background,
      child: Column(
        children: [
          _buildWarCounter(),
          alertsRegions.isEmpty
              ? const Padding(
                  padding: EdgeInsets.symmetric(vertical: 20, horizontal: 12),
                  child: Text("Тревог нет", style: TextStyle(fontSize: 23, color: CustomColor.green)),
                )
              : Expanded(
                  child: ListView.builder(
                    physics: const BouncingScrollPhysics(),
                    padding: EdgeInsets.zero,
                    itemCount: alertsRegions.length,
                    itemBuilder: (BuildContext context, int index) {
                      return _buildAlarmCard(alertsRegions[index]);
                    },
                  ),
                )
        ],
      ),
    );
  }
}

Widget _buildAlarmCard(RegionModel alertModel) {
  return Container(
    height: 130,
    padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 10),
    decoration: BoxDecoration(border: Border(bottom: BorderSide(color: Colors.grey.withOpacity(0.4)))),
    child: Column(
      children: [
        Text(alertModel.title, style: const TextStyle(fontSize: 18)),
        const SizedBox(height: 10),
        Expanded(
          child: Column(
            children: [
              Column(
                children: [
                  const Text(
                    "Начало Тревоги",
                    style: TextStyle(color: CustomColor.textColor),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    alertModel.timeDurationAlarm == "0:00" ? "Только что" : alertModel.timeStart ?? "",
                    style: const TextStyle(color: CustomColor.red),
                  ),
                ],
              ),
              const Spacer(),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    alertModel.timeDurationAlarm == "0:00" ? "" : "Тревога длится:",
                    style: const TextStyle(color: CustomColor.red),
                  ),
                  const SizedBox(width: 10),
                  Text(
                    alertModel.timeDurationAlarm == "0:00" ? "" : alertModel.timeDurationAlarm ?? "",
                    style: const TextStyle(color: CustomColor.red),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    ),
  );
}

Widget _buildWarCounter() {
  ConfigResponse config = ConfigRepository.instance.config;
  if (config.war == true && config.startWarDate != null) {
    int warDay = DateTime.now().difference(config.startWarDate!).inDays + 1;
    return SizedBox(
        height: 80,
        child: ColoredBox(
          color: CustomColor.systemTextBox,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 40),
              Text("$warDay день войны", textAlign: TextAlign.center, style: const TextStyle(color: CustomColor.red, fontSize: 18)),
              const Spacer(),
              Container(
                height: 3,
                width: double.infinity,
                color: Colors.black,
              ),
            ],
          ),
        ));
  }
  return const SizedBox.shrink();
}
