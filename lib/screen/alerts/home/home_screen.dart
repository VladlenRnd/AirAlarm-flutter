import 'dart:ui';

import 'package:alarm/tools/custom_color.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:lottie/lottie.dart';

import '../../../dialog/custom_snack_bar.dart';
import '../../../models/region_model.dart';

import '../../../tools/ui_tools.dart';
import '../cubit/alert_cubit.dart';
import 'widget/map_widget.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final AlertCubit _bloc = AlertCubit();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AlertCubit, AlertState>(
      bloc: _bloc,
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
                    _bloc.selectRegion(selectUID: rm.uid);
                  },
                ),
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        AnimatedSwitcher(
                          duration: const Duration(milliseconds: 400),
                          switchInCurve: Curves.fastOutSlowIn,
                          switchOutCurve: Curves.easeInExpo,
                          reverseDuration: const Duration(milliseconds: 400),
                          transitionBuilder: (child, animation) {
                            return SizeTransition(sizeFactor: animation, child: child);
                          },
                          child: state.selectRegion?.uid != state.subscribeRegion?.uid
                              ? state.selectRegion == null
                                  ? SizedBox.shrink()
                                  : _buildInfoCard(region: state.selectRegion!, isSubscribe: state.selectRegion?.uid == state.subscribeRegion?.uid)
                              : null,
                        ),
                        state.subscribeRegion != null ? _buildInfoCard(region: state.subscribeRegion!, isSubscribe: true) : _buildEmptySubscribe()
                      ],
                    ),
                  ),
                )
              ],
            );
        }
      },
    );
  }

  Widget _buildEmptySubscribe() {
    return Container(
        margin: EdgeInsets.symmetric(vertical: 8, horizontal: 24),
        padding: EdgeInsets.symmetric(vertical: 10, horizontal: 12),
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: CustomColor.backgroundCard,
        ),
        child: Text(
          "Выберите область, чтобы получать уведомления о воздушных тревогах.",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          textAlign: TextAlign.center,
        ));
  }

  Widget _buildInfoCard({required RegionModel region, required bool isSubscribe}) {
    return Container(
      margin: EdgeInsets.all(8),
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
            mainAxisAlignment: region.isAlert ? MainAxisAlignment.spaceBetween : MainAxisAlignment.center,
            children: [
              Flexible(
                child: Text(
                  region.title ?? "",
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        fontSize: 18,
                        color: UiTools.getAlarmColor(region),
                        fontWeight: FontWeight.w700,
                      ),
                ),
              ),
              if (region.alertType != null && region.alertType != EAlertType.unknown && region.isAlert)
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
          if (!region.isAlert && !region.isAlertDistrict) ...[
            Text("Тревоги нет", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            SizedBox(height: 10),
            if (region.finishedAtEstimate != null) _buildTitleValue(title: "Время без тревоги:", value: region.finishedAtEstimate!),
            if (region.finishedAt != null) _buildTitleValue(title: "Конец тревоги:", value: UiTools.getDateToDay(region.finishedAt!, true)),
          ],
          if (!region.isAlert && region.isAlertDistrict) ...[
            Text("Тревога по районам", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            SizedBox(height: 10),
          ],
          if (region.listDistrict != null) ...[
            ...region.listDistrict!.where((e) => e.isAlert).map((e) => _buildDistrictAlarm(district: e)),
          ],
          if (region.startedAtEstimate != null) _buildTitleValue(title: "Время тревоги:", value: region.startedAtEstimate!),
          if (region.startedAt != null) _buildTitleValue(title: "Начало Тревоги:", value: UiTools.getDateToDay(region.startedAt!, true)),
          if (region.notes != null) ...[
            Divider(),
            _buildTitleValue(title: "Информация:", value: region.notes!),
          ],
          if (!isSubscribe) ...[
            SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton(
                    onPressed: () => {_bloc.selectRegion(selectUID: null)},
                    child: Text('Закрыть'.toUpperCase(), style: const TextStyle(color: CustomColor.textColor))),
                ElevatedButton(
                  onPressed: () async {
                    showDialog(context: context, barrierDismissible: false, builder: (BuildContext context) => _buildSaveLoad());
                    bool result = await _bloc.subscribeRegion(region.uid);
                    Navigator.pop(context);

                    if (result == false) {
                      CustomSnackBar.error(context, title: "Ошибка. Попробуйте ещё раз");
                    }
                  },
                  child: Text("Отслеживать", style: const TextStyle(color: CustomColor.textColor)),
                ),
              ],
            ),
          ]
        ],
      ),
    );
  }

  Widget _buildDistrictAlarm({required RegionModel district}) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(district.title ?? "", style: TextStyle(color: district.alertType?.colorAlert, fontSize: 14)),
                Text("Время тревоги: ${district.startedAtEstimate!}", style: TextStyle(fontSize: 12)),
                // Text("Начало Тревоги: ${UiTools.getDateToDay(district.startedAt!, true)}", style: TextStyle(fontSize: 12)),
                //  if (district.startedAtEstimate != null) _buildTitleValue(title: "Время тревоги:", value: district.startedAtEstimate!),
                // if (district.startedAt != null) _buildTitleValue(title: "Начало Тревоги:", value: UiTools.getDateToDay(district.startedAt!, true)),
              ],
            ),
            Container(
              padding: EdgeInsets.all(8),
              decoration: BoxDecoration(borderRadius: BorderRadius.circular(8), color: CustomColor.background),
              child: Row(
                children: [
                  Text(
                    textAlign: TextAlign.center,
                    district.alertType!.title,
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          fontSize: 10,
                          color: district.alertType?.colorAlert,
                          fontWeight: FontWeight.w500,
                        ),
                  ),
                  SizedBox(width: 5),
                  SvgPicture.asset(
                    district.alertType!.svgPath,
                    width: 20,
                    height: 20,
                    colorFilter: ColorFilter.mode(district.alertType?.colorAlert ?? Colors.white.withValues(alpha: 0.6), BlendMode.srcIn),
                  ),
                ],
              ),
            ),
          ],
        ),
        Divider(),
      ],
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
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
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
              "Сервер недоступен или отсутствует подключение к сети. Проверьте интернет-соединение или попробуйте позже.",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 14, color: CustomColor.textColor.withValues(alpha: 0.7)),
            )
          ],
        ),
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
    _bloc.close();
    super.dispose();
  }
}
