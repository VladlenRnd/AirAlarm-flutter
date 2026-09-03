import 'package:alarm/service/firebase_config_service.dart';
import 'package:app_settings/app_settings.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:logger/logger.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../dialog/info_dialog.dart';
import '../../dialog/update_dialog.dart';
import '../../tools/custom_color.dart';
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
  @override
  void initState() {
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: CustomColor.background,
        systemNavigationBarContrastEnforced: false,
      ),
    );
    SchedulerBinding.instance.addPostFrameCallback((_) async {
      _checkPermition(!context.mounted ? context : context);
      if (await _isUpdateCheck()) {
        if (await showUpdateDialog(!context.mounted ? context : context) ?? false) {
          await Navigator.of(!context.mounted ? context : context).push(MaterialPageRoute(builder: (context) => const DownloadScreen()));
        }
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
        body: SafeArea(
          left: false,
          top: true,
          bottom: false,
          right: false,
          child: Config.isTechnicalWork ?? false
              ? _buildTechnicalWork()
              : Config.isWar ?? false
                  ? switch (_selectScreen) {
                      EScreen.home => _buildScreen(const HomeScreen()),
                      EScreen.settings => _buildScreen(SettingsScreen()),
                      EScreen.history => _buildScreen(ListScreen()),
                    }
                  : _buildNotWar(),
        ));
  }

  Widget _buildTechnicalWork() {
    return const Scaffold(
      backgroundColor: CustomColor.background,
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.build, size: 48, color: CustomColor.atantion),
              SizedBox(height: 10),
              Text(
                "Технические работы",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 23, color: CustomColor.atantion),
              ),
              SizedBox(height: 5),
              Text(
                "В данный момент проводятся технические работы, просим извинения за неудобства",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNotWar() {
    return const Scaffold(
      backgroundColor: CustomColor.background,
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24),
        child: Center(
          child: Text("На данный момент, нет данных о тревогах", textAlign: TextAlign.center, style: TextStyle(fontSize: 21)),
        ),
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
              icon: Icons.history,
              title: EScreen.history.title,
              isSelected: _selectScreen == EScreen.history,
              setScreen: () async => await showInfoDialog(
                context,
                title: 'История в разработке',
                contentInfo: 'Ждите в ближайшем обновлении :-)',
                actionButtonStr: 'Хорошо!',
                closeButtonStr: "",
              ),

              // _setScreen(EScreen.history),
            )),
            const Spacer(),
            Expanded(
                child: _buildAppBarItem(
              icon: Icons.settings,
              title: EScreen.settings.title,
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
      PackageInfo infoApp = await PackageInfo.fromPlatform();
      if (Config.watNew?.newVersion != null && infoApp.version != Config.watNew!.newVersion) {
        result = true;
      }
    } catch (e) {
      Logger().e("_isUpdateCheck error:", error: e);
    }

    return result;
  }
}

enum EScreen {
  home("Главная"),
  settings("Настройки"),
  history("История");

  const EScreen(this.title);

  final String title;
}
