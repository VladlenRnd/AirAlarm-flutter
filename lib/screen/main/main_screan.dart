import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottie/lottie.dart';
import '../settings/settings.dart';
import 'bloc/main_bloc.dart';
import 'tools/color.dart';
import 'tools/region_model.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  final MainBloc _bloc = MainBloc();

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
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const SettingScreen()),
                );
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
            return SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.only(top: 24, left: 24, right: 24),
                child: Column(
                  children: state.listRegions.map((model) => _buildCardWidget(model)).toList(),
                ),
              ),
            );
          }

          return _buildErrorWidget();
        },
      ),
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
      padding: const EdgeInsets.symmetric(vertical: 10),
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
            child: model.isAlarm
                ? Text("Воздушная тревога",
                    style: TextStyle(
                      fontSize: 22,
                      color: CustomColor.red,
                    ))
                : Center(child: Text("Тревоги нет", style: TextStyle(fontSize: 22, color: CustomColor.green))),
          ),
          Expanded(
            child: model.timeDuration != null
                ? Text("Тревога длится: \n ${model.timeDuration}",
                    textAlign: TextAlign.center, style: TextStyle(fontSize: 22, color: CustomColor.red))
                : const SizedBox.shrink(),
          ),
          const Padding(padding: EdgeInsets.symmetric(vertical: 5)),
          model.timeStart != null
              ? Text(
                  "Начало тревоги: ${model.timeStart}",
                  style: TextStyle(color: CustomColor.textColor),
                )
              : const SizedBox.shrink(),
          const Padding(padding: EdgeInsets.symmetric(vertical: 5)),
          model.timeEnd != null
              ? Text(
                  "Конец тревоги: ${model.timeEnd}",
                  style: TextStyle(color: CustomColor.textColor),
                )
              : const SizedBox.shrink(),
        ],
      ),
    );
  }
}
