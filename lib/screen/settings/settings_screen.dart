import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../service/baground_service.dart';
import '../../service/shered_preferences.dart';
import '../main/tools/custom_color.dart';
import '../select_region/select_region_screen.dart';

class SettingScreen extends StatefulWidget {
  const SettingScreen({Key? key}) : super(key: key);

  @override
  State<SettingScreen> createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  @override
  void initState() {
    super.initState();
  }

  Future<SettingData> _getSettingData() async {
    return SettingData(packageInfo: await PackageInfo.fromPlatform(), pref: SheredPreferencesService.preferences);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CustomColor.background,
      appBar: AppBar(
        backgroundColor: CustomColor.backgroundLight,
        title: const Text("Настройки"),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 24),
        child: FutureBuilder<SettingData>(
          future: _getSettingData(),
          builder: (BuildContext context, AsyncSnapshot<SettingData> snapshot) {
            if (snapshot.hasData) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  _buildBagroundSetting(),
                  Divider(color: CustomColor.primaryGreen.withOpacity(0.6)),
                  _buildRegionaAdd(),
                  Expanded(
                    child: _buildAppVersion(snapshot.data!.packageInfo),
                  )
                ],
              );
            }
            return const Center(
              child: CircularProgressIndicator(),
            );
          },
        ),
      ),
    );
  }

  Widget _buildRegionaAdd() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 15),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            "Выбор области",
            textAlign: TextAlign.end,
            style: TextStyle(
              fontSize: 17,
              color: CustomColor.textColor,
            ),
          ),
          MaterialButton(
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => const SelectRegionScreen()));
            },
            color: CustomColor.greenBox,
            child: Text(
              "Выбрать",
              style: TextStyle(color: CustomColor.primaryGreen),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildBagroundSetting() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Оповещения в \nфоновом режиме",
              textAlign: TextAlign.start,
              style: TextStyle(
                fontSize: 17,
                color: CustomColor.textColor,
              )),
          Switch(
            activeColor: CustomColor.primaryGreen,
            value: SheredPreferencesService.preferences.getBool("backgroundSercive")!,
            onChanged: (bool value) async {
              await _bagroundLogic(SheredPreferencesService.preferences, value);
            },
          )
        ],
      ),
    );
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

  Future<void> _bagroundLogic(SharedPreferences sh, bool value) async {
    if (value == false) {
      BackgroundService.invoke("setAsBackground");
    } else {
      BackgroundService.invoke("setAsForeground");
    }

    setState(() {
      sh.setBool("backgroundSercive", value);
    });
  }
}

class SettingData {
  final SharedPreferences pref;
  final PackageInfo packageInfo;

  SettingData({required this.packageInfo, required this.pref});
}
