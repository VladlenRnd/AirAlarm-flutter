import 'package:app_settings/app_settings.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../dialog/info_dialog.dart';
import '../../dialog/update_dialog.dart';
import '../../tools/connection/connection.dart';
import '../../tools/connection/response/config_response.dart';
import '../../tools/custom_color.dart';
import '../../tools/repository/config_repository.dart';
import '../../tools/update_info.dart';
import '../alerts/home/home_screen.dart';
import '../alerts/list/list_screen.dart';
import '../download/download_screen.dart';
import '../settings/settings_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

EScreen _selectScreen = EScreen.home;

class _MainScreenState extends State<MainScreen> {
  ConfigResponse? get config => ConfigRepository.instance.config;

  @override
  void initState() {
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(statusBarColor: CustomColor.background));
    SchedulerBinding.instance.addPostFrameCallback((_) async {
      _checkPermition(!context.mounted ? context : context);
      if (await _isUpdateCheck() && (await showUpdateDialog(!context.mounted ? context : context) ?? false)) {
        await Navigator.of(!context.mounted ? context : context).push(MaterialPageRoute(builder: (context) => const DownloadScreen()));
      }
    });

    super.initState();
  }

  Future<void> _checkPermition(BuildContext context) async {
    switch (await Permission.notification.request()) {
      case PermissionStatus.granted:
        return;
      default:
        if (await showInfoDialog(context,
                title: "Нет разрешения на уведомления!",
                contentInfo: "Без доступа к уведомлениям приложение не сможет оповещать Вас о начале/конце тревоги",
                actionButtonStr: "Настройки") ??
            false) {
          await AppSettings.openAppSettings(type: AppSettingsType.notification);
        }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: CustomColor.background,
        body: Padding(
          padding: const EdgeInsets.only(top: 10),
          child: (config?.war ?? false)
              ? switch (_selectScreen) {
                  EScreen.home => _buildScreen(const HomeScreen()),
                  EScreen.settings => _buildScreen(SettingsScreen()),
                  EScreen.list => _buildScreen(ListScreen()),
                }
              : _buildNotWar(),
        ));
  }

  Widget _buildNotWar() {
    return const Scaffold(
      backgroundColor: CustomColor.background,
      body: Center(
        child: Text("Нет данных о тревогах", textAlign: TextAlign.center, style: TextStyle(fontSize: 18)),
      ),
    );
  }

  Widget _buildScreen(Widget screen) {
    return Scaffold(
      body: screen,
      backgroundColor: CustomColor.background,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(130)),
        onPressed: () => _setScreen(EScreen.home),
        backgroundColor: CustomColor.actionColor,
        child: const Icon(Icons.home, size: 40),
      ),
      bottomNavigationBar: BottomAppBar(
        height: 60,
        padding: const EdgeInsets.symmetric(horizontal: 24),
        shape: const CircularNotchedRectangle(),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
                child: _buildAppBarItem(
              icon: Icons.list,
              title: "Список",
              isSelected: _selectScreen == EScreen.list,
              setScreen: () => _setScreen(EScreen.list),
            )),
            const Spacer(),
            Expanded(
                child: _buildAppBarItem(
              icon: Icons.settings,
              title: "Настройки",
              isSelected: _selectScreen == EScreen.settings,
              setScreen: () => _setScreen(EScreen.settings),
            )),
          ],
        ),
      ),
    );
  }

  void _setScreen(EScreen newScreen) {
    if (newScreen == _selectScreen) return;

    setState(() {
      _selectScreen = newScreen;
    });
  }

  Widget _buildAppBarItem({required IconData icon, required String title, bool isSelected = false, required Function setScreen}) {
    Color? sc = isSelected ? CustomColor.actionColor : CustomColor.textColor;
    return CupertinoButton(
      onPressed: () => setScreen.call(),
      padding: EdgeInsets.zero,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: sc),
          Text(title, style: Theme.of(context).textTheme.titleSmall!.copyWith(color: sc)),
        ],
      ),
    );
  }

  Future<bool> _isUpdateCheck() async {
    bool result = false;
    try {
      UpdateInfo.infoUpdate = await Connection.chekUpdate();
      PackageInfo infoApp = await PackageInfo.fromPlatform();

      if (infoApp.version != UpdateInfo.infoUpdate.newVersion) {
        result = true;
      }
    } catch (e) {
      debugPrint(e.toString());
    }

    return result;
  }
}

enum EScreen {
  home,
  settings,
  list,
}
