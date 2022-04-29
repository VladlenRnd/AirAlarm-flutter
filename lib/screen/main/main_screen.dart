import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottie/lottie.dart';
import 'package:package_info_plus/package_info_plus.dart';
import '../../dialog/update_dialog.dart';
import '../../tools/connection/connection.dart';
import '../../tools/region_model.dart';
import '../../tools/update_info.dart';
import '../select_region/select_region_screen.dart';
import '../settings/settings_screen.dart';
import 'bloc/main_bloc.dart';
import '../../tools/custom_color.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  late final MainBloc _bloc;

  Future<bool> _isUpdateCheck() async {
    bool result = false;
    try {
      UpdateInfo.infoUpdate = await Conectrion.chekUpdate();
      PackageInfo infoApp = await PackageInfo.fromPlatform();

      if (infoApp.version != UpdateInfo.infoUpdate.newVersion) {
        result = true;
      }
    } catch (e) {
      print(e);
    }

    return result;
  }

  @override
  void initState() {
    _bloc = MainBloc();
    SchedulerBinding.instance!.addPostFrameCallback((_) async {
      UpdateInfo.isNewVersion = await _isUpdateCheck();
      if (UpdateInfo.isNewVersion) {
        showUpdateDialog(context);
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CustomColor.background,
      appBar: AppBar(
        backgroundColor: CustomColor.backgroundLight,
        title: const Text("Воздушная тревога"),
        centerTitle: true,
        actions: [
          IconButton(
              onPressed: () async {
                await Navigator.push(context, MaterialPageRoute(builder: (context) => const SettingScreen()));
                _bloc.add(MainUpdateAlarmEvent());
              },
              icon: const Icon(Icons.settings))
        ],
      ),
      body: BlocBuilder<MainBloc, MainState>(
        bloc: _bloc,
        builder: (BuildContext context, MainState state) {
          if (state is MainLoadedDataState || state is MainInitialState) {
            return const Center(
              child: CircularProgressIndicator(
                color: Colors.indigo,
              ),
            );
          }
          if (state is MainLoadDataState) {
            return state.listRegions.isNotEmpty
                ? ListView.builder(
                    itemCount: state.listRegions.length,
                    itemBuilder: (BuildContext context, int index) {
                      //TODO Add dismisible
                      return _buildCardWidget(state.listRegions[index]);
                    })
                : _buildEmptyList();
          }

          return _buildErrorWidget();
        },
      ),
    );
  }

  Widget _buildEmptyList() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Center(
          child: Container(
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 24),
        decoration: BoxDecoration(
          color: CustomColor.systemTextBox,
          borderRadius: const BorderRadius.all(Radius.circular(18)),
          boxShadow: [
            BoxShadow(
              color: CustomColor.systemSecondary.withOpacity(0.5),
              spreadRadius: 5,
              blurRadius: 7,
              offset: const Offset(0, 3), // changes position of shadow
            ),
          ],
        ),
        width: double.infinity,
        height: 250,
        child: Column(
          children: [
            Text(
              "Добавьте области для отслеживания воздушной тревоги",
              textAlign: TextAlign.center,
              style: TextStyle(color: CustomColor.textColor, fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const Padding(padding: EdgeInsets.symmetric(vertical: 15)),
            ElevatedButton(
              onPressed: () async {
                if (await Navigator.push(context, MaterialPageRoute(builder: (context) => const SelectRegionScreen()))) {
                  _bloc.add(MainUpdateAlarmEvent());
                }
              },
              child: const Icon(Icons.add, size: 35),
              style: ButtonStyle(
                shape: MaterialStateProperty.all(const CircleBorder()),
                padding: MaterialStateProperty.all(const EdgeInsets.all(20)),
                backgroundColor: MaterialStateProperty.all(CustomColor.systemSecondary), // <-- Button color
              ),
            )
          ],
        ),
      )),
    );
  }

  Widget _buildErrorWidget() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Center(
          child: Container(
        decoration: BoxDecoration(
          color: Colors.white70,
          borderRadius: const BorderRadius.all(Radius.circular(18)),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 5,
              blurRadius: 7,
              offset: const Offset(0, 3), // changes position of shadow
            ),
          ],
        ),
        height: 230,
        width: double.infinity,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              "Потерянно соединение с сервером",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 25),
            ),
            const Padding(padding: EdgeInsets.symmetric(vertical: 10)),
            const Text(
              "проверьте интернет-соединение",
              style: TextStyle(fontSize: 19),
            ),
            Lottie.asset(
              'assets/lottie/load.json',
              width: 100,
              height: 100,
            ),
          ],
        ),
      )),
    );
  }

  Widget _buildCardWidget(RegionModel model) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 24),
      child: SizedBox(
        height: 200,
        child: Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: model.isAlarm ? CustomColor.redBox : CustomColor.greenBox,
            borderRadius: const BorderRadius.all(Radius.circular(18)),
            boxShadow: [
              BoxShadow(
                color: model.isAlarm ? CustomColor.redBox.withOpacity(0.6) : CustomColor.greenBox.withOpacity(0.6),
                spreadRadius: 5,
                blurRadius: 7,
                offset: const Offset(0, 3), // changes position of shadow
              ),
            ],
          ),
          child: _buildInfoData(model),
        ),
      ),
    );
  }

  Widget _buildInfoData(RegionModel model) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 14),
      child: Column(
        children: [
          Text(
            model.title,
            style: TextStyle(
              fontSize: 16,
              color: CustomColor.textColor,
            ),
          ),
          const Padding(padding: EdgeInsets.symmetric(vertical: 10)),
          Expanded(
            child: _buildAlarm(model.isAlarm),
          ),
          _buildTimer(model.timeDurationAlarm, model.timeDurationCancelAlarm),
          const Padding(padding: EdgeInsets.symmetric(vertical: 5)),
          _buildDate(model.timeStart, model.timeEnd),
        ],
      ),
    );
  }

  Widget _buildAlarm(bool isAlarm) {
    return Text(isAlarm ? "Воздушная тревога" : "Тревоги нет",
        style: TextStyle(
          fontSize: 22,
          color: isAlarm ? CustomColor.red : CustomColor.green,
        ));
  }

  Widget _buildDate(String? timeStart, String? timeEnd) {
    if (timeStart != null) {
      return Text(
        "Начало тревоги: $timeStart",
        style: TextStyle(color: CustomColor.textColor),
      );
    } else if (timeEnd != null) {
      return Text(
        "Конец тревоги: $timeEnd",
        style: TextStyle(color: CustomColor.textColor),
      );
    } else {
      return const SizedBox.shrink();
    }
  }

  Widget _buildTimer(String? startAlarm, String? endAlarm) {
    if (startAlarm != null) {
      return Expanded(
          child: Text("Тревога длится: \n $startAlarm", textAlign: TextAlign.center, style: TextStyle(fontSize: 22, color: CustomColor.red)));
    } else if (endAlarm != null) {
      return Expanded(
          child: Text("Без тревоги: \n $endAlarm", textAlign: TextAlign.center, style: TextStyle(fontSize: 22, color: CustomColor.green)));
    } else {
      return const SizedBox.shrink();
    }
  }
}
