import 'dart:ui';

import 'package:alarm/service/settings_service.dart';
import 'package:alarm/tools/custom_color.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:lottie/lottie.dart';
import 'package:rxdart/rxdart.dart';

import '../../../models/region_model.dart';

import '../../../tools/region/region_title_tools.dart';
import '../../../tools/ui_tools.dart';
import '../cubit/alert_cubit.dart';
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
  final AlertCubit bloc = AlertCubit();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AlertCubit, AlertState>(
      bloc: bloc,
      builder: (BuildContext context, AlertState state) {
        switch (state) {
          case AlertLoadingState():
            return _buildLoader();
          case AlertErrorDataState():
            return _buildErrorWidget();
          case AlertLoadedDataState():
            return Column(
              children: [
                MapWidget(
                  allRegion: state.regionList,
                  onTap: (RegionModel rm) {
                    int i = 0;
                    //selectRegionModel = rm;
                    //expandedStream.add(SettingsService.subscribeRegion != rm.region.name);
                  },
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: state.regionList.length,
                    itemBuilder: (context, index) {
                      return state.regionList[index].isAlert ? _buildInfoCard(region: state.regionList[index]) : SizedBox.shrink();
                    },
                  ),
                ),
              ],
            );

          /*
           
            return Column(
              children: [
                // MapWidget(
                //   allRegion: state.listRegions,
                //   onTap: (RegionModel rm) {
                //     selectRegionModel = rm;
                //     expandedStream.add(SettingsService.subscribeRegion != rm.region.name);
                //   },
                // ),
                Expanded(
                    child: SingleChildScrollView(
                  child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                      child: Column(
                        children: [
                          // if (UiTools.isGlobalAlarm(state.listRegions)) const InfoWidget.globalAlarmWidget(),
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
                                            onSave: () => {}, // onSaveNewLocation(),
                                          ),
                                        )
                                      : null,
                                );
                              }),
                          // InfoWidget.infoWidget(
                          //     selectRegion:
                          //         UiTools.getRegion(state.listRegions, RegionTitleTools.getEnumByEnumName(SettingsService.subscribeRegion!))),
                          const SizedBox(height: 25),
                        ],
                      )),
                ))
              ],
            );

*/
        }
      },
    );
  }

  Widget _buildInfoCard({required RegionModel region}) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 8),
      padding: EdgeInsets.symmetric(vertical: 10, horizontal: 12),
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: CustomColor.backgroundCard,
      ),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                child: Text(
                  region.title ?? "", //region.title
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        fontSize: 18,
                        color: region.alertType?.colorAlert,
                        fontWeight: FontWeight.w700,
                      ),
                ),
              ),
              if (region.alertType != null && region.alertType != EAlertType.unknown)
                Flexible(
                  child: Container(
                    padding: EdgeInsets.all(8),
                    decoration: BoxDecoration(borderRadius: BorderRadius.circular(8), color: CustomColor.background),
                    child: Row(
                      children: [
                        Expanded(
                            child: Text(
                          textAlign: TextAlign.center,
                          region.alertType!.title,
                          style: Theme.of(context).textTheme.titleSmall?.copyWith(
                                fontSize: 14,
                                color: region.alertType?.colorAlert,
                                fontWeight: FontWeight.w500,
                              ),
                        )),
                        SizedBox(width: 5),
                        SvgPicture.asset(
                          region.alertType!.svgPath,
                          width: 45,
                          height: 45,
                          colorFilter: ColorFilter.mode(region.alertType?.colorAlert ?? Colors.white.withValues(alpha: 0.6), BlendMode.srcIn),
                        ),
                      ],
                    ),
                  ),
                ),
            ],
          ),
          Divider(),
          if (region.startedAt != null) _buildTitleValue(title: "Время тревоги:", value: UiTools.getElapsedTimeFormatted(region.startedAt!)),
          if (region.startedAt != null) _buildTitleValue(title: "Начало Тревоги:", value: UiTools.getDateToDay(region.startedAt!, true)),
          if (region.notes != null) ...[
            Divider(),
            _buildTitleValue(title: "Информация:", value: region.notes!),
          ],
        ],
      ),
    );
  }

  Widget _buildTitleValue({required String title, required String value}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [Expanded(child: Text(title)), Expanded(child: Text(value, textAlign: TextAlign.end))],
      ),
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
            "Не могу получить данные с сервера",
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

  // void onSaveNewLocation() async {
  //   showDialog(context: context, barrierDismissible: false, builder: (BuildContext context) => _buildSaveLoad());

  //   String selectName = selectRegionModel!.region.name;
  //   if (SettingsService.subscribeRegion! != selectName && selectName.isNotEmpty) {
  //     await FirebaseMessaging.instance.unsubscribeFromTopic(SettingsService.subscribeRegion!);
  //     await SettingsService.setParametr(subscribeRegionParam: selectName);
  //     await FirebaseMessaging.instance.subscribeToTopic(selectName);
  //   }

  //   Navigator.pop(!context.mounted ? context : context);
  //   bloc.add(HomeSaveRegionEvent());
  //   expandedStream.add(false);
  // }

  @override
  void dispose() {
    expandedStream.close();
    bloc.close();
    super.dispose();
  }
}
