// ignore_for_file: use_build_context_synchronously

import 'package:alarm/screen/main/main_screen.dart';
import 'package:alarm/tools/connection/connection.dart';
import 'package:alarm/tools/custom_color.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:page_transition/page_transition.dart';

import '../../dialog/update_dialog.dart';
import '../../service/firebase_service.dart';
import '../../service/location_service.dart';
import '../../service/notification_service.dart';
import '../../service/shered_preferences_service.dart';
import '../../tools/connection/response/alarm_response.dart';
import '../../tools/repository/config_repository.dart';
import '../../tools/update_info.dart';
import '../download/download_screen.dart';

class LoaderScrean extends StatefulWidget {
  const LoaderScrean({super.key});

  @override
  State<LoaderScrean> createState() => _LoaderScreanState();
}

class _LoaderScreanState extends State<LoaderScrean> {
  List<_LoadModel> _loadServiceList = [];
  _EAllLoadedStatus _eStatus = _EAllLoadedStatus.proccesing;
  double _loadPercent = 0.0;
  AlarmRespose? _listAlarm;

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

  Future<bool> _initConfig() async {
    if (!await ConfigRepository.instance.init()) {
      setState(() {
        _eStatus = _EAllLoadedStatus.criticalError;
      });
      return false;
    }
    return true;
  }

  @override
  void initState() {
    SchedulerBinding.instance.addPostFrameCallback((_) async {
      if (!await _initConfig()) return;

      if (await _isUpdateCheck() && (await showUpdateDialog(context) ?? false)) {
        await Navigator.of(context).push(MaterialPageRoute(builder: (context) => const DownloadScreen()));
      }

      _allDataLoaded();
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: _buildBody(),
        ),
      ),
    );
  }

  Widget _buildBody() {
    switch (_eStatus) {
      case _EAllLoadedStatus.allDone:
      case _EAllLoadedStatus.proccesing:
        return Column(
          key: ValueKey(_eStatus),
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AnimatedTextKit(
              isRepeatingAnimation: false,
              animatedTexts: [
                TypewriterAnimatedText(
                  _eStatus == _EAllLoadedStatus.proccesing ? "Загрузка приложения" : "Загрузка завершена",
                  textAlign: TextAlign.center,
                  textStyle: TextStyle(
                    fontFamily: "8Bit",
                    fontSize: 16,
                    fontWeight: FontWeight.w300,
                    letterSpacing: 1.5,
                    color: _eStatus == _EAllLoadedStatus.allDone ? CustomColor.green : null,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 30),
            LinearProgressIndicator(
              minHeight: 7,
              value: _loadPercent,
              color: CustomColor.systemSecondary,
            ),
          ],
        );

      case _EAllLoadedStatus.criticalError:
        return Column(
          key: ValueKey(_eStatus),
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AnimatedTextKit(
              isRepeatingAnimation: false,
              animatedTexts: [
                TypewriterAnimatedText("Ошибка загрузки приложения",
                    textAlign: TextAlign.center,
                    textStyle: const TextStyle(
                        fontFamily: "8Bit", fontSize: 16, fontWeight: FontWeight.w300, color: CustomColor.red, letterSpacing: 1.5, height: 1.5)),
              ],
            ),
            const SizedBox(height: 20),
            CupertinoButton(
                onPressed: () async {
                  setState(() {
                    _eStatus = _EAllLoadedStatus.proccesing;
                    _loadPercent = 0.0;
                    _loadServiceList = [];
                  });
                  if (!await _initConfig()) return;
                  _allDataLoaded();
                },
                child: const Text("Повторить загрузку")),
          ],
        );

      case _EAllLoadedStatus.notCriticalError:
        return Column(
          key: ValueKey(_eStatus),
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AnimatedTextKit(
              isRepeatingAnimation: false,
              animatedTexts: [
                TypewriterAnimatedText("Загрузка завершена c ошибкой",
                    textAlign: TextAlign.center,
                    textStyle: const TextStyle(
                        fontFamily: "8Bit",
                        fontSize: 16,
                        fontWeight: FontWeight.w300,
                        color: CustomColor.colorMapAtantion,
                        letterSpacing: 1.5,
                        height: 1.5)),
              ],
            ),
            const SizedBox(height: 25),
            ElevatedButton(
                onPressed: () async {
                  setState(() {});
                  _goToMain();
                },
                style: ButtonStyle(backgroundColor: MaterialStateProperty.all<Color>(CustomColor.systemSecondary)),
                child: const Text("Запустить упрощёную версию")),
            CupertinoButton(
                onPressed: () async {
                  setState(() {
                    _eStatus = _EAllLoadedStatus.proccesing;
                    _loadPercent = 0.0;
                    _loadServiceList = [];
                  });
                  if (!await _initConfig()) return;
                  _allDataLoaded();
                },
                child: const Text("Повторить загрузку")),
          ],
        );
      default:
        return const SizedBox.shrink();
    }
  }

  Future<bool> _getAlarm() async {
    try {
      _listAlarm = await Connection.getAlarm();
      return true;
    } catch (e) {
      return false;
    }
  }

  void _allDataLoaded() async {
    await Future.delayed(const Duration(milliseconds: 500));
    _loadServiceList = [
      _LoadModel(listMethosInit: [SheredPreferencesService().init], isCritical: true),
      _LoadModel(listMethosInit: [LocationService().init, NotificationService().init, FirebaseService().init]),
      _LoadModel(listMethosInit: [_getAlarm], isCritical: true),
    ];

    double onePercent = 1 / _loadServiceList.length;

    for (_LoadModel e in _loadServiceList) {
      if (await e.load()) setState(() => _loadPercent += onePercent);
    }

    _eStatus = _EAllLoadedStatus.allDone;

    for (_LoadModel element in _loadServiceList) {
      if (element.isCritical && element.status == _ELoadStatus.error) {
        _eStatus = _EAllLoadedStatus.criticalError;
        break;
      }
      if (element.status == _ELoadStatus.error && !element.isCritical) _eStatus = _EAllLoadedStatus.notCriticalError;
    }

    switch (_eStatus) {
      case _EAllLoadedStatus.allDone:
        setState(() {});
        await Future.delayed(const Duration(milliseconds: 500));
        _goToMain();
        return;
      case _EAllLoadedStatus.proccesing:
      case _EAllLoadedStatus.criticalError:
      case _EAllLoadedStatus.notCriticalError:
        setState(() {});
        break;
    }
  }

  void _goToMain() => Navigator.pushAndRemoveUntil<void>(context, _createRoute(), (route) => false);

  Route _createRoute() {
    return PageTransition(
      child: MainScreen(initAlarm: _listAlarm),
      type: PageTransitionType.fade,
      duration: const Duration(seconds: 1),
    );
  }
}

class _LoadModel {
  final bool isCritical;
  _ELoadStatus? status;
  List<Future<bool> Function()> listMethosInit;

  Future<bool> load() async {
    status = _ELoadStatus.loading;
    for (Future<bool> Function() initFunc in listMethosInit) {
      if (!await initFunc.call()) {
        if (kDebugMode) print("Error load $initFunc");
        status = _ELoadStatus.error;
        return false;
      }
    }
    status = _ELoadStatus.ok;
    return true;
  }

  _LoadModel({required this.listMethosInit, this.isCritical = false});
}

enum _EAllLoadedStatus { allDone, proccesing, criticalError, notCriticalError }

enum _ELoadStatus { loading, ok, error }
