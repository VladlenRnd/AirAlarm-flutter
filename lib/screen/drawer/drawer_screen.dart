import 'package:alarm/screen/news/news_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:expandable/expandable.dart';

import '../../dialog/setting_dialogs/change_sound_dialog.dart';
import '../../dialog/setting_dialogs/silent_mode_dialog.dart';
import '../../dialog/setting_dialogs/subscribe_notifiaction_dialog.dart';
import '../../service/shered_preferences_service.dart';
import '../../tools/custom_color.dart';
import '../../tools/eregion.dart';
import '../../models/region_model.dart';
import '../../tools/region_title_tools.dart';

class CustomDrawer extends StatelessWidget {
  final List<RegionModel> allRegion;
  const CustomDrawer({Key? key, required this.allRegion}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: FutureBuilder<PackageInfo>(
        future: PackageInfo.fromPlatform(),
        builder: ((context, snapshot) {
          if (snapshot.hasData) {
            return Column(
              children: [
                StatefulBuilder(builder: ((BuildContext context, setState) {
                  return Column(
                    children: [
                      _buildHead(),
                      _buildNotificationSetting(context, setState),
                    ],
                  );
                })),
                const Padding(padding: EdgeInsets.symmetric(vertical: 5)),
                _buildItemButton(context, "Режим тишины", Icons.notifications_paused_rounded, Colors.blueGrey, () {
                  showSilentModeDialog(context);
                }),
                const Padding(padding: EdgeInsets.symmetric(vertical: 5)),
                _buildItemButton(context, "События", Icons.newspaper, Colors.deepOrange, () async {
                  Navigator.of(context).pop();
                  Navigator.of(context).push(MaterialPageRoute(builder: (context) => const NewsScreen()));
                }),
                const Spacer(),
                Padding(
                  padding: const EdgeInsets.only(bottom: 25),
                  child: _buildAppVersion(snapshot.data!),
                ),
              ],
            );
          }
          return const SizedBox.shrink();
        }),
      ),
    );
  }

  Widget _buildItemButton(BuildContext context, String title, IconData icon, Color color, void Function() onTap) {
    return CupertinoButton(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Row(
          children: [
            Icon(icon, color: color, size: 30),
            const Padding(padding: EdgeInsets.symmetric(horizontal: 8)),
            Expanded(
              child: Text(
                title,
                style: Theme.of(context).textTheme.headline6!.copyWith(color: Colors.white),
              ),
            ),
          ],
        ),
        onPressed: onTap);
  }

  Widget _buildNotificationSetting(BuildContext context, Function(void Function()) setState) {
    return ExpandablePanel(
      collapsed: const SizedBox.shrink(),
      expanded: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 0),
        child: _buildAllertSetting(context, setState),
      ),
      header: _buildItemHeader(context),
      theme: ExpandableThemeData(
        iconColor: CustomColor.textColor,
        headerAlignment: ExpandablePanelHeaderAlignment.center,
        iconPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      ),
    );
  }

  Widget _buildItemHeader(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        child: Row(
          children: [
            Icon(Icons.notifications_active, color: CustomColor.drawerItemNotification),
            const Padding(padding: EdgeInsets.symmetric(horizontal: 8)),
            Text(
              "Уведомления",
              style: Theme.of(context).textTheme.headline6!.copyWith(color: Colors.white),
            ),
          ],
        ));
  }

  Widget _buildTitleSetting(String title, {Function? onTap}) {
    return CupertinoButton(
        child: Text(title, style: TextStyle(color: CustomColor.textColor.withOpacity(0.8), fontFamily: "Days")),
        onPressed: () {
          onTap?.call();
        });
  }

  Widget _buildAllertSetting(BuildContext context, Function(void Function()) setState) {
    return Container(
      decoration: BoxDecoration(border: Border(left: BorderSide(color: CustomColor.drawerItemNotification, width: 2))),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildTitleSetting("Отслеживание тревоги", onTap: () async {
            await showSubscribeDialog(context);
            setState(() {});
          }),
          _buildTitleSetting("Звук при тревоге", onTap: () => showChangeSoundDialog(context, true)),
          _buildTitleSetting("Звук при отмене тревоги", onTap: () => showChangeSoundDialog(context, false)),
        ],
      ),
    );
  }

  bool _isAlarmSelectRegion() {
    ERegion subscribeRegion = RegionTitleTools.getEnumByEnumName(SheredPreferencesService.preferences.getString("subscribeRegion")!);

    return allRegion.firstWhere((RegionModel e) => e.region == subscribeRegion).isAlarm;
  }

  Widget _buildHead() {
    bool isAlarm = _isAlarmSelectRegion();
    return Container(
        height: 230,
        width: double.infinity,
        decoration: BoxDecoration(
            gradient: LinearGradient(
          begin: Alignment.bottomRight,
          end: Alignment.topLeft,
          colors: [
            CustomColor.greenBox,
            CustomColor.listCardColor,
            CustomColor.redBox,
          ],
        )),
        child: Padding(
          padding: const EdgeInsets.only(top: 50),
          child: Column(
            children: [
              Icon(
                isAlarm ? Icons.warning_amber_rounded : Icons.gpp_good_outlined,
                size: 80,
                color: isAlarm ? CustomColor.red : CustomColor.green,
              ),
              const SizedBox(height: 15),
              Text(isAlarm ? "Воздушная тревога" : "Тревоги нет",
                  style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold, color: isAlarm ? CustomColor.red : CustomColor.green)),
              const Padding(padding: EdgeInsets.symmetric(vertical: 5)),
              Text(RegionTitleTools.getRegionByEnumName(SheredPreferencesService.preferences.getString("subscribeRegion")!)),
            ],
          ),
        ));
  }

  Widget _buildAppVersion(PackageInfo info) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Text(
        "Версия: ${info.version}",
        style: TextStyle(color: CustomColor.textColor, fontSize: 18),
      ),
    );
  }
}
