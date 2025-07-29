import 'dart:ui';

import 'package:alarm/service/settings_service.dart';
import 'package:alarm/tools/custom_color.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottie/lottie.dart';
import 'package:rxdart/rxdart.dart';

import '../../../models/region_model.dart';

import '../../../tools/region/region_title_tools.dart';
import '../../../tools/ui_tools.dart';
import '../bloc/home_bloc.dart';
import 'widget/map_widget.dart';
import 'widget/info_widget.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final BehaviorSubject<bool> expandedStream = BehaviorSubject<bool>();
  RegionModel? selectRegionModel;
  final AlertBloc bloc = AlertBloc();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AlertBloc, HomeState>(
      bloc: bloc,
      builder: (BuildContext context, HomeState state) {
        if (state is HomeUpdateState) {
          return Column(
            children: [
              MapWidget(
                allRegion: state.listRegions,
                onTap: (RegionModel rm) {
                  selectRegionModel = rm;
                  expandedStream.add(SettingsService.subscribeRegion != rm.region.name);
                },
              ),
              Expanded(
                  child: SingleChildScrollView(
                child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                    child: Column(
                      children: [
                        if (UiTools.isGlobalAlarm(state.listRegions)) const InfoWidget.globalAlarmWidget(),
                        StreamBuilder(
                            stream: expandedStream,
                            initialData: false,
                            builder: (context, snapshot) {
                              return AnimatedSwitcher(
                                duration: const Duration(milliseconds: 600),
                                switchInCurve: Curves.easeOutExpo,
                                switchOutCurve: Curves.easeInOutExpo,
                                reverseDuration: const Duration(milliseconds: 200),
                                transitionBuilder: (child, animation) {
                                  return SizeTransition(sizeFactor: animation, child: child);
                                },
                                child: snapshot.data!
                                    ? Padding(
                                        padding: const EdgeInsets.only(bottom: 10),
                                        child: InfoWidget.auxiliaryInfoWidget(
                                          selectRegion: selectRegionModel!,
                                          onClose: () => expandedStream.add(false),
                                          onSave: () => onSaveNewLocation(),
                                        ),
                                      )
                                    : null,
                              );
                            }),
                        InfoWidget.infoWidget(
                            selectRegion: UiTools.getRegion(state.listRegions, RegionTitleTools.getEnumByEnumName(SettingsService.subscribeRegion!))),
                        const SizedBox(height: 25),
                      ],
                    )),
              ))
            ],
          );
        }

        if (state is HomeErrorDataState) {
          return _buildErrorWidget();
        }
        if (state is HomeLoadingState) {
          return _buildLoader();
        }
        return const SizedBox.shrink();
      },
    );
  }

  Widget _buildLoader() {
    return const Center(
      child: SizedBox(
          height: 60,
          width: 60,
          child: CircularProgressIndicator(
            color: CustomColor.actionColor,
          )),
    );
  }

  Widget _buildSaveLoad() {
    return PopScope(
        canPop: false,
        child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text("Сохранение...", style: TextStyle(fontSize: 30)),
                const SizedBox(height: 20),
                _buildLoader(),
              ],
            )));
  }

  Widget _buildErrorWidget() {
    return Center(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Lottie.asset(
            'assets/lottie/no-connect.json',
            width: 190,
            height: 200,
            frameRate: FrameRate(60),
          ),
          const Text(
            "Не могу получить данные",
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 19),
          ),
          const SizedBox(height: 5),
          Text(
            "проверьте интернет-соединение",
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 14, color: CustomColor.textColor.withValues(alpha: 0.7)),
          )
        ],
      ),
    );
  }

//*******TOOLS METHOD***** */

  void onSaveNewLocation() async {
    showDialog(context: context, barrierDismissible: false, builder: (BuildContext context) => _buildSaveLoad());

    String selectName = selectRegionModel!.region.name;
    if (SettingsService.subscribeRegion! != selectName && selectName.isNotEmpty) {
      await FirebaseMessaging.instance.unsubscribeFromTopic(SettingsService.subscribeRegion!);
      await SettingsService.setParametr(subscribeRegionParam: selectName);
      await FirebaseMessaging.instance.subscribeToTopic(selectName);
    }

    Navigator.pop(!context.mounted ? context : context);
    bloc.add(HomeSaveRegionEvent());
    expandedStream.add(false);
  }

  @override
  void dispose() {
    expandedStream.close();
    bloc.close();
    super.dispose();
  }
}
