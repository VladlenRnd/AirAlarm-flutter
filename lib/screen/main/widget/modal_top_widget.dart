import 'package:flutter/material.dart';

import '../../../models/district_model.dart';
import '../../../models/region_model.dart';
import '../../../tools/custom_color.dart';
import '../../../tools/ui_tools.dart';

class _ModalTopWidget extends StatelessWidget {
  final RegionModel region;
  const _ModalTopWidget({Key? key, required this.region}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: CustomColor.backgroundLight,
      child: SizedBox(
        width: MediaQuery.of(context).size.width,
        child: Padding(
          padding: EdgeInsets.only(top: MediaQuery.of(context).viewPadding.top),
          child: _buildBody(context),
        ),
      ),
    );
  }

  Widget _buildBody(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Align(
            alignment: Alignment.topCenter,
            child: _buildHeader(region, context),
          ),
          const SizedBox(height: 15),
          _buildDistrictList(),
        ],
      ),
    );
  }

  Widget _buildDistrictList() {
    return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [for (int i = 0; i < region.districts.length; i++) _buildDistrict(region.districts[i], i % 2 == 0, region.isAlarm)]);
  }
}

Widget _buildDistrict(DistrictModel districts, bool isCount, bool isAlarmRegion) {
  return ColoredBox(
    color: isCount ? CustomColor.background : CustomColor.backgroundLight,
    child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              children: [
                UiTools.buildIconStatus(isAlarmRegion, districts.isAlarm, size: 30),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    districts.title,
                    style: const TextStyle(fontSize: 16),
                  ),
                )
              ],
            ),
            if (!isAlarmRegion)
              Padding(
                padding: const EdgeInsets.only(left: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    if (districts.isAlarm) _buildDate(districts.timeStart, districts.timeEnd),
                  ],
                ),
              ),
          ],
        )),
  );
}

Widget _buildHeader(RegionModel region, BuildContext context) {
  bool isDistrictsAlarm = region.districts.any((element) => element.isAlarm == true);
  return Column(
    children: [
      Align(alignment: Alignment.topLeft, child: IconButton(onPressed: () => Navigator.of(context).pop(), icon: const Icon(Icons.close))),
      Text(region.title, style: const TextStyle(fontSize: 20)),
      const SizedBox(height: 10),
      Text(
          region.isAlarm
              ? "Воздушная тревога в области"
              : isDistrictsAlarm
                  ? "Опасность в области"
                  : "Тревоги нет",
          style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: region.isAlarm
                  ? CustomColor.red
                  : isDistrictsAlarm
                      ? CustomColor.colorMapAtantion
                      : CustomColor.green)),
    ],
  );
}

Widget _buildDate(String? timeStart, String? timeEnd) {
  if (timeStart != null) {
    return Text(
      "Опасность артобстрела! \nc $timeStart",
      textAlign: TextAlign.center,
      style: const TextStyle(color: CustomColor.colorMapAtantion, fontSize: 16),
    );
  }
  return const SizedBox.shrink();
}

Future<void> showDistrictDialog(BuildContext context, RegionModel region) async {
  bool isClose = false;
  await showGeneralDialog(
    context: context,
    transitionDuration: const Duration(milliseconds: 250),
    pageBuilder: (context, _, __) => _ModalTopWidget(region: region),
    transitionBuilder: (context, animation, secondaryAnimation, child) {
      return Dismissible(
          direction: DismissDirection.up,
          confirmDismiss: (direction) {
            if (direction == DismissDirection.up) {
              isClose = true;
              Navigator.of(context).pop();
            }
            return Future.value(false);
          },
          key: UniqueKey(),
          child: SlideTransition(
            position: CurvedAnimation(parent: isClose ? secondaryAnimation : animation, curve: Curves.easeOutCubic)
                .drive(Tween<Offset>(begin: const Offset(0, -1.0), end: Offset.zero)),
            child: SingleChildScrollView(
                child: Material(
                    color: Colors.transparent,
                    child: SingleChildScrollView(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [child],
                      ),
                    ))),
          ));
    },
  );
}
