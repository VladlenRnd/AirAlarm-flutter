import 'dart:ui';

import 'package:alarm/tools/custom_color.dart';
import 'package:collection/collection.dart';
import 'package:expandable_page_view/expandable_page_view.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:lottie/lottie.dart';

import '../../../dialog/confirm_dialog.dart';
import '../../../models/alert_setting_model.dart';
import '../../../models/region_model.dart';

import '../../../service/settings_service.dart';
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
  String? _expandedRegionId = "";

  final PageController _controllerPage = PageController(
    viewportFraction: 0.9,
  );

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
                if (state.subscribeRegions != null && (state.subscribeRegions?.isNotEmpty ?? false)) ...[
                  SizedBox(height: 10),
                  ExpandablePageView.builder(
                    controller: _controllerPage,
                    itemCount: state.subscribeRegions!.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: _buildSubscribeCard(
                          region: state.subscribeRegions![index],
                        ),
                      );
                    },
                  ),
                ],
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
                          child: state.selectRegion?.uid == null
                              ? _buildStartCard()
                              : _buildNewCard(ValueKey(state.selectRegion!.uid), region: state.selectRegion!),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            );
        }
      },
    );
  }

//===================================

  Widget _buildSubscribeCard({required RegionModel region}) {
    final bool hasAlert = region.isAlert;

    final String regionUid = region.uid.toString();

    final bool isExpanded = _expandedRegionId == regionUid;

    return Material(
      color: CustomColor.backgroundCard,
      borderRadius: BorderRadius.circular(12),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onLongPress: () async => await _unsubscribeRegion(district: region),
        onTap: hasAlert ? () => setState(() => _expandedRegionId = isExpanded ? null : regionUid) : null,
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      region.title ?? '',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                            color: CustomColor.textColor,
                          ),
                    ),
                  ),
                  if (hasAlert)
                    AnimatedRotation(
                      turns: isExpanded ? 0.5 : 0,
                      duration: const Duration(milliseconds: 250),
                      curve: Curves.easeOutCubic,
                      child: Icon(
                        Icons.keyboard_arrow_down_rounded,
                        color: CustomColor.textColor.withValues(alpha: 0.7),
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 6),
              Row(
                children: [
                  Container(
                    width: 8,
                    height: 8,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: hasAlert ? region.alertType?.colorAlert : CustomColor.noAlert,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    hasAlert ? 'Тревога' : 'Тревоги нет',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          fontWeight: FontWeight.w500,
                          color: hasAlert ? region.alertType?.colorAlert : CustomColor.noAlert,
                        ),
                  ),
                ],
              ),
              if (hasAlert && isExpanded) ...[
                const SizedBox(height: 14),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 10,
                  ),
                  decoration: BoxDecoration(
                    color: CustomColor.background,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    children: [
                      SvgPicture.asset(
                        region.alertType!.svgPath,
                        width: 24,
                        height: 24,
                        colorFilter: ColorFilter.mode(
                          region.alertType?.colorAlert ?? CustomColor.textColor,
                          BlendMode.srcIn,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          region.alertType!.title,
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                fontWeight: FontWeight.w600,
                                color: region.alertType?.colorAlert,
                              ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 14),
                Container(
                  height: 1,
                  color: CustomColor.textColor.withValues(alpha: 0.08),
                ),
                const SizedBox(height: 14),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: _buildInfoItem(
                        icon: Icons.timer_outlined,
                        title: 'Время тревоги',
                        value: region.startedAtEstimate!,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: _buildInfoItem(
                        icon: Icons.access_time_rounded,
                        title: 'Начало тревоги',
                        value: UiTools.getDateToDay(
                          region.startedAt!,
                          true,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoItem({
    required IconData icon,
    required String title,
    required String value,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(
          icon,
          size: 18,
          color: CustomColor.textColor.withValues(alpha: 0.55),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: CustomColor.textColor.withValues(alpha: 0.55),
                    ),
              ),
              const SizedBox(height: 3),
              Text(
                value,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: CustomColor.textColor,
                    ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildStartCard() {
    return Container(
        margin: EdgeInsets.symmetric(vertical: 8, horizontal: 24),
        padding: EdgeInsets.symmetric(vertical: 10, horizontal: 12),
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: CustomColor.backgroundCard,
        ),
        child: Text(
          "Для начала работы, выберете область на карте",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          textAlign: TextAlign.center,
        ));
  }

  Widget _buildNewCard(Key key, {required RegionModel region}) {
    return Container(
      key: key,
      margin: EdgeInsets.only(top: 8, bottom: 35, left: 8, right: 8),
      padding: EdgeInsets.symmetric(vertical: 10, horizontal: 12),
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: CustomColor.backgroundCard,
      ),
      child: Column(
        children: [
          Text(
            region.title ?? "",
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  fontSize: 18,
                  color: UiTools.getAlarmColor(region),
                  fontWeight: FontWeight.w700,
                ),
          ),
          SizedBox(height: 10),
          switch (UiTools.isWhereAlarm(region: region)) {
            0 => Text("Тревог нет"),
            1 => Text("Тревоги по районам"),
            2 => Text("Тревога по всей области"),
            _ => SizedBox.shrink(),
          },
          if (region.isAlert) ...[
            const SizedBox(height: 8),
            if (region.startedAtEstimate != null)
              _buildCompactInfoRow(
                icon: Icons.timer_outlined,
                title: 'Время тревоги',
                value: region.startedAtEstimate!,
              ),
            if (region.startedAt != null) ...[
              const SizedBox(height: 4),
              _buildCompactInfoRow(
                icon: Icons.schedule_rounded,
                title: 'Начало тревоги',
                value: UiTools.getDateToDay(region.startedAt!, true),
              ),
            ],
          ],
          if ((region.listDistrict?.isNotEmpty ?? false) && region.isAlert == false) ...[
            SizedBox(height: 10),
            ...region.listDistrict!.map((e) => _buildDistrict(district: e)),
          ],
        ],
      ),
    );
  }

  Widget _buildCompactInfoRow({
    required IconData icon,
    required String title,
    required String value,
  }) {
    return Row(
      children: [
        Icon(
          icon,
          size: 16,
          color: CustomColor.textColor.withValues(alpha: 0.5),
        ),
        const SizedBox(width: 6),
        Text(
          '$title: ',
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                fontSize: 12,
                color: CustomColor.textColor.withValues(alpha: 0.55),
              ),
        ),
        Expanded(
          child: Text(
            value,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.end,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: CustomColor.textColor,
                ),
          ),
        ),
      ],
    );
  }

  Widget _buildDistrict({required RegionModel district}) {
    final bool hasAlert = district.isAlert;
    final Color statusColor = hasAlert ? district.alertType?.colorAlert ?? CustomColor.textColor : CustomColor.noAlert;

    SubscribeAlertModel? isSub = SettingsService.subscribeRegions!.firstWhereOrNull((e) => e.regionUID == district.uid);

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        CupertinoButton(
          padding: EdgeInsets.zero,
          onPressed: isSub != null
              ? null
              : () async {
                  await subscribeRegion(district: district);
                },
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        district.title ?? "",
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.titleSmall?.copyWith(
                              fontSize: 15,
                              color: UiTools.getAlarmColor(district),
                              fontWeight: FontWeight.w700,
                            ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (isSub != null) ...[
                          Icon(
                            isSub.isMuted ? Icons.notifications_off_rounded : Icons.notifications_active_rounded,
                            color: isSub.isMuted ? Colors.grey : CustomColor.atantion,
                            size: 19,
                          ),
                          SizedBox(width: 5),
                        ],
                        Container(
                          width: 7,
                          height: 7,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: statusColor,
                          ),
                        ),
                        const SizedBox(width: 6),
                        Text(
                          hasAlert ? "Тревога" : "Нет тревоги",
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                color: statusColor,
                                fontWeight: FontWeight.w600,
                              ),
                        ),
                      ],
                    ),
                  ],
                ),
                if (hasAlert) ...[
                  const SizedBox(height: 7),
                  Row(
                    children: [
                      SvgPicture.asset(
                        district.alertType!.svgPath,
                        width: 18,
                        height: 18,
                        colorFilter: ColorFilter.mode(
                          statusColor,
                          BlendMode.srcIn,
                        ),
                      ),
                      const SizedBox(width: 6),
                      Expanded(
                        child: Text(
                          district.alertType!.title,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                fontSize: 12,
                                color: statusColor,
                                fontWeight: FontWeight.w500,
                              ),
                        ),
                      ),
                      if (district.startedAtEstimate != null) ...[
                        const SizedBox(width: 10),
                        Icon(
                          Icons.timer_outlined,
                          size: 15,
                          color: CustomColor.textColor.withValues(alpha: 0.5),
                        ),
                        const SizedBox(width: 4),
                        Text(
                          district.startedAtEstimate!,
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                fontSize: 11,
                                color: CustomColor.textColor.withValues(alpha: 0.65),
                              ),
                        ),
                      ],
                    ],
                  ),
                  if (district.startedAt != null) ...[
                    const SizedBox(height: 5),
                    Row(
                      children: [
                        Icon(
                          Icons.schedule_rounded,
                          size: 15,
                          color: CustomColor.textColor.withValues(alpha: 0.5),
                        ),
                        const SizedBox(width: 5),
                        Expanded(
                          child: Text(
                            "Начало: ${UiTools.getDateToDay(district.startedAt!, true)}",
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                  fontSize: 11,
                                  color: CustomColor.textColor.withValues(alpha: 0.65),
                                ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ],
              ],
            ),
          ),
        ),
        Divider(
          height: 1,
          thickness: 1,
          color: CustomColor.textColor.withValues(alpha: 0.08),
        ),
      ],
    );
  }
//===================================

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

  Future<void> subscribeRegion({required RegionModel district}) async {
    bool? res = await showConficrDialog(context, title: district.title ?? "", content: "Получать уведомления о тревогах/отменах в этом районе?");

    if (res == true && context.mounted) {
      String newUID = district.uid ?? "";

      showDialog(context: !context.mounted ? context : context, barrierDismissible: false, builder: (BuildContext context) => _buildSaveLoad());
      await _bloc.subscribeRegion(newUID);
      Navigator.pop(!context.mounted ? context : context);
    }
  }

  Future<void> _unsubscribeRegion({required RegionModel district}) async {
    bool? res = await showConficrDialog(context, confirmBtn: "Отписаться", title: district.title ?? "", content: "Отключить уведомления?");

    if (res == true && context.mounted) {
      String newUID = district.uid ?? "";

      showDialog(context: !context.mounted ? context : context, barrierDismissible: false, builder: (BuildContext context) => _buildSaveLoad());
      await _bloc.unsubscribeRegion(newUID);
      Navigator.pop(!context.mounted ? context : context);
    }
  }

  @override
  void dispose() {
    _bloc.close();
    super.dispose();
  }
}
