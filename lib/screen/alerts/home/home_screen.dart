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
                              : _buildCard(ValueKey(state.selectRegion!.uid), region: state.selectRegion!),
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
    final Color statusColor = hasAlert ? region.alertLevel?.getAlertColor() ?? CustomColor.textColor : CustomColor.noAlert;
    final threat = region.threats?.lastOrNull;

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
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                            color: CustomColor.textColor,
                          ),
                    ),
                  ),
                  if (hasAlert) ...[
                    const SizedBox(width: 10),
                    AnimatedRotation(
                      turns: isExpanded ? 0.5 : 0,
                      duration: const Duration(milliseconds: 250),
                      curve: Curves.easeOutCubic,
                      child: Icon(
                        Icons.keyboard_arrow_down_rounded,
                        size: 22,
                        color: CustomColor.textColor.withValues(alpha: 0.65),
                      ),
                    ),
                  ],
                ],
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 5,
                    ),
                    decoration: BoxDecoration(
                      color: statusColor.withValues(alpha: 0.08),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          width: 6,
                          height: 6,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: statusColor,
                          ),
                        ),
                        const SizedBox(width: 5),
                        Text(
                          hasAlert ? 'Тревога' : 'Тревоги нет',
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                fontSize: 11,
                                fontWeight: FontWeight.w600,
                                color: statusColor,
                              ),
                        ),
                      ],
                    ),
                  ),
                  if (hasAlert && region.alertLevel != null) ...[
                    const SizedBox(width: 7),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 5),
                      decoration: BoxDecoration(
                        color: statusColor.withValues(alpha: 0.06),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        region.alertLevel!.getMsg(),
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              fontSize: 10,
                              fontWeight: FontWeight.w600,
                              color: statusColor,
                            ),
                      ),
                    ),
                  ],
                ],
              ),
              if (hasAlert && isExpanded) ...[
                const SizedBox(height: 14),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(11),
                  decoration: BoxDecoration(
                    color: region.alertType!.colorAlert.withValues(alpha: 0.045),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: region.alertType!.colorAlert.withValues(alpha: 0.10),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          if (region.alertType != null)
                            SvgPicture.asset(
                              region.alertType!.svgPath,
                              width: 22,
                              height: 22,
                              colorFilter: ColorFilter.mode(region.alertType!.colorAlert, BlendMode.srcIn),
                            ),
                          const SizedBox(width: 9),
                          Expanded(
                            child: Text(
                              region.alertType?.title ?? '',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style:
                                  Theme.of(context).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600, color: region.alertType!.colorAlert),
                            ),
                          ),
                        ],
                      ),
                      if (threat?.customMessage?.isNotEmpty == true) ...[
                        const SizedBox(height: 8),
                        Padding(
                          padding: const EdgeInsets.only(left: 31),
                          child: Text(
                            threat!.customMessage!,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                fontSize: 12, height: 1.3, color: CustomColor.textColor.withValues(alpha: 0.72), fontWeight: FontWeight.w400),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
                const SizedBox(height: 14),
                Divider(),
                const SizedBox(height: 14),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (region.startedAtEstimate != null)
                      Expanded(
                        child: _buildInfoItem(
                          icon: Icons.timer_outlined,
                          title: 'Время тревоги',
                          value: region.startedAtEstimate!,
                        ),
                      ),
                    if (region.startedAtEstimate != null && region.startedAt != null) const SizedBox(width: 16),
                    if (region.startedAt != null)
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

  Widget _buildCard(Key key, {required RegionModel region}) {
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

  Widget _buildCompactInfoRow({required IconData icon, required String title, required String value}) {
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
    final Color statusColor = hasAlert ? district.alertLevel?.getAlertColor() ?? CustomColor.textColor : CustomColor.noAlert;
    final SubscribeAlertModel? isSub = SettingsService.subscribeRegions!.firstWhereOrNull((e) => e.regionUID == district.uid);
    final threat = district.threats?.lastOrNull;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        CupertinoButton(
          padding: EdgeInsets.zero,
          onPressed: isSub != null ? null : () async => await subscribeRegion(district: district),
          child: Padding(
            padding: const EdgeInsets.symmetric(
              vertical: 12,
              horizontal: 2,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
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
                    if (isSub != null) ...[
                      Icon(
                        isSub.isMuted ? Icons.notifications_off_rounded : Icons.notifications_active_rounded,
                        color: isSub.isMuted ? CustomColor.textColor.withValues(alpha: 0.45) : CustomColor.atantion,
                        size: 18,
                      ),
                      const SizedBox(width: 8),
                    ],
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
                      decoration: BoxDecoration(
                        color: statusColor.withValues(alpha: 0.08),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            width: 6,
                            height: 6,
                            decoration: BoxDecoration(
                              color: statusColor,
                              shape: BoxShape.circle,
                            ),
                          ),
                          const SizedBox(width: 5),
                          Text(
                            hasAlert ? "Тревога" : "Нет тревоги",
                            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                  fontSize: 11,
                                  color: statusColor,
                                  fontWeight: FontWeight.w600,
                                ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                if (hasAlert) ...[
                  const SizedBox(height: 10),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: district.alertType!.colorAlert.withValues(alpha: 0.045),
                      borderRadius: BorderRadius.circular(9),
                      border: Border.all(
                        color: statusColor.withValues(alpha: 0.10),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            if (district.alertType != null)
                              SvgPicture.asset(
                                district.alertType!.svgPath,
                                width: 18,
                                height: 18,
                                colorFilter: ColorFilter.mode(district.alertType!.colorAlert, BlendMode.srcIn),
                              ),
                            const SizedBox(width: 7),
                            Expanded(
                              child: Text(
                                district.alertType?.title ?? "",
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: Theme.of(context)
                                    .textTheme
                                    .bodySmall
                                    ?.copyWith(fontSize: 13, color: district.alertType!.colorAlert, fontWeight: FontWeight.w600),
                              ),
                            ),
                            if (district.alertLevel != null) ...[
                              const SizedBox(width: 8),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 7,
                                  vertical: 3,
                                ),
                                decoration: BoxDecoration(
                                  color: statusColor.withValues(alpha: 0.10),
                                  borderRadius: BorderRadius.circular(5),
                                ),
                                child: Text(
                                  district.alertLevel!.getMsg(),
                                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                        fontSize: 10,
                                        color: statusColor,
                                        fontWeight: FontWeight.w600,
                                      ),
                                ),
                              ),
                            ],
                          ],
                        ),
                        if (threat?.customMessage?.isNotEmpty == true) ...[
                          const SizedBox(height: 7),
                          Padding(
                            padding: const EdgeInsets.only(left: 25),
                            child: Text(
                              threat!.customMessage!,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                    fontSize: 12,
                                    height: 1.3,
                                    color: CustomColor.textColor.withValues(alpha: 0.75),
                                    fontWeight: FontWeight.w400,
                                  ),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                  if (district.startedAt != null && district.startedAtEstimate != null) ...[
                    const SizedBox(height: 9),

                    /// TIME
                    Row(
                      children: [
                        Icon(
                          Icons.schedule_rounded,
                          size: 14,
                          color: CustomColor.textColor.withValues(alpha: 0.4),
                        ),
                        const SizedBox(width: 5),
                        Expanded(
                          child: Text(
                            "Начало: ${UiTools.getDateToDay(
                              district.startedAt!,
                              true,
                            )}",
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                  fontSize: 11,
                                  color: CustomColor.textColor.withValues(alpha: 0.6),
                                ),
                          ),
                        ),
                        Icon(
                          Icons.timer_outlined,
                          size: 14,
                          color: CustomColor.textColor.withValues(alpha: 0.4),
                        ),
                        const SizedBox(width: 4),
                        Text(
                          district.startedAtEstimate!,
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                fontSize: 11,
                                color: CustomColor.textColor.withValues(alpha: 0.6),
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
