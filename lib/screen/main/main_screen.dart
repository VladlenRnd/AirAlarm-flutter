// ignore_for_file: use_build_context_synchronously

import 'package:alarm/service/notification_service.dart';
import 'package:alarm/tools/region/eregion.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:lottie/lottie.dart';
import '../../dialog/no_permission_dialog.dart';
import '../../models/region_model.dart';
import '../../tools/connection/response/alarm_response.dart';
import '../../tools/connection/response/config_response.dart';
import '../../tools/history.dart';
import '../../tools/repository/config_repository.dart';
import '../../tools/ui_tools.dart';
import '../../tools/ukrain_svg.dart';
import '../drawer/drawer_screen.dart';
import '../drawer/end_drawer_screen.dart';
import 'bloc/main_bloc.dart';
import '../../tools/custom_color.dart';
import 'widget/card_list_widget.dart';
import 'widget/modal_top_widget.dart';
import 'widget/not_war_widget.dart';

class MainScreen extends StatefulWidget {
  final AlarmRespose? initAlarm;
  const MainScreen({Key? key, required this.initAlarm}) : super(key: key);

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  ConfigResponse config = ConfigRepository.instance.config;

  @override
  void initState() {
    getAllHistory();
    SchedulerBinding.instance.addPostFrameCallback((_) async {
      if (await NotificationService.requestPermission() == false) {
        showPermissionDialog(context);
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [_buildApp(), if (config.war != null && config.war == false) const NotWarWidget()],
    );
  }

  Widget _buildAlarmCounter(int alarmCount) {
    if (alarmCount == 0) return const SizedBox.shrink();
    return Stack(
      children: [
        Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            child: Builder(
                builder: (context) => CupertinoButton(
                      onPressed: () {
                        Scaffold.of(context).openEndDrawer();
                      },
                      padding: EdgeInsets.zero,
                      child: Lottie.asset(
                        'assets/lottie/warning.json',
                        width: 40,
                        height: 40,
                        fit: BoxFit.cover,
                        frameRate: FrameRate(60),
                      ),
                    ))),
        Positioned(
          top: 5,
          right: 5,
          child: Container(
              width: 20,
              height: 20,
              decoration: BoxDecoration(color: CustomColor.red, shape: BoxShape.circle, border: Border.all(color: CustomColor.background)),
              child: Center(
                child: Text(
                  alarmCount.toString(),
                  style: Theme.of(context).textTheme.bodyLarge!.copyWith(fontSize: 12),
                  textAlign: TextAlign.center,
                ),
              )),
        ),
      ],
    );
  }

  Widget _buildToolBarStatus(int count, Widget icon, Color color) {
    if (count == 0) return const SizedBox.shrink();
    return Container(
      height: 25,
      padding: const EdgeInsets.symmetric(horizontal: 5),
      decoration: BoxDecoration(
        color: color.withOpacity(0.7),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [icon, const SizedBox(width: 5), Text("$count", textAlign: TextAlign.center)],
      ),
    );
  }

  List<Widget> _buildStatusAlert(List<RegionModel> listRegion) {
    return [
      _buildToolBarStatus(
        UiTools.getAlarmRegion(listRegion).length,
        SvgPicture.asset("assets/icons/alarm.svg", width: 20, colorFilter: const ColorFilter.mode(CustomColor.textColor, BlendMode.srcIn)),
        CustomColor.red,
      ),
      const SizedBox(width: 10),
      _buildToolBarStatus(
        UiTools.getCountWarningRegion(listRegion),
        SvgPicture.asset("assets/icons/bomb.svg", width: 20, colorFilter: const ColorFilter.mode(CustomColor.textColor, BlendMode.srcIn)),
        CustomColor.colorMapAtantion,
      ),
      const SizedBox(width: 10),
      _buildToolBarStatus(
        (listRegion.length - UiTools.getAlarmRegion(listRegion).length),
        SvgPicture.asset("assets/icons/safety.svg", width: 20, colorFilter: const ColorFilter.mode(CustomColor.textColor, BlendMode.srcIn)),
        CustomColor.green,
      ),
    ];
  }

  List<Widget> _buildGlobalAlarm() {
    return [
      Lottie.asset(
        'assets/lottie/warning.json',
        fit: BoxFit.cover,
        frameRate: FrameRate(60),
      ),
      const Text("Всеобщая воздушная тревога", style: TextStyle(color: CustomColor.red)),
      Lottie.asset(
        'assets/lottie/warning.json',
        fit: BoxFit.cover,
        frameRate: FrameRate(60),
      ),
    ];
  }

  List<Widget> _buildNoAlarm() {
    return [
      Lottie.asset(
        'assets/lottie/shield.json',
        fit: BoxFit.cover,
        frameRate: FrameRate(60),
        repeat: false,
      ),
      const Text("Воздушных тревог нет", style: TextStyle(color: CustomColor.green)),
    ];
  }

  Widget _buildApp() {
    return BlocProvider(
      create: (_) => MainBloc(widget.initAlarm!),
      child: BlocBuilder<MainBloc, MainState>(builder: (BuildContext context, MainState state) {
        if (state is MainLoadDataState) {
          bool isGlobalAlarm = UiTools.isGlobalAlarm(state.listRegions);
          bool isNoAlarm = UiTools.isNoAlarm(state.listRegions);
          return Scaffold(
              backgroundColor: CustomColor.background,
              resizeToAvoidBottomInset: false,
              drawer: CustomDrawer(allRegion: state.listRegions),
              endDrawer: CustomEndDrawer(alertsRegions: UiTools.getAlarmRegion(state.listRegions)),
              endDrawerEnableOpenDragGesture: false,
              body: SafeArea(
                child: CustomScrollView(
                  physics: const BouncingScrollPhysics(),
                  slivers: <Widget>[
                    SliverAppBar(
                      stretch: true,
                      actions: [
                        _buildAlarmCounter(UiTools.getAlarmRegion(state.listRegions).length),
                      ],
                      pinned: true,
                      floating: true,
                      expandedHeight: 383,
                      bottom: PreferredSize(
                          preferredSize: const Size(double.infinity, 33),
                          child: Column(
                            children: [
                              Container(
                                height: 3,
                                width: double.infinity,
                                color: Colors.black,
                              ),
                              Container(
                                color: CustomColor.systemTextBox,
                                height: 30,
                                alignment: Alignment.centerRight,
                                padding: const EdgeInsets.symmetric(horizontal: 24),
                                child: Row(
                                  children: [
                                    if (isNoAlarm) ..._buildNoAlarm(),
                                    if (!isNoAlarm && isGlobalAlarm) ..._buildGlobalAlarm(),
                                    if (!isNoAlarm && !isGlobalAlarm) ..._buildStatusAlert(state.listRegions),
                                    const Spacer(),
                                    PopupMenuButton<int>(
                                      icon: const Icon(Icons.sort),
                                      padding: EdgeInsets.zero,
                                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                                      tooltip: "Сортировка",
                                      splashRadius: 1,
                                      onSelected: (int sortIndex) => BlocProvider.of<MainBloc>(context).add(MainChangeSort(sortIndex: sortIndex)),
                                      offset: const Offset(-30, 25),
                                      itemBuilder: (BuildContext context) {
                                        return _buildSortPopup(state.sortIndex);
                                      },
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          )),
                      flexibleSpace: FlexibleSpaceBar(
                        background: _buildMap(state.listRegions),
                      ),
                    ),
                    SliverList(
                      delegate: SliverChildBuilderDelegate(
                        (BuildContext context, int index) {
                          return Padding(
                              key: ValueKey(state.listRegions[index].region),
                              padding: const EdgeInsets.symmetric(vertical: 3),
                              child: CupertinoButton(
                                onPressed: () async => await showDistrictDialog(context, state.listRegions[index]),
                                padding: EdgeInsets.zero,
                                child: CardList(
                                  key: ValueKey(state.listRegions[index].region),
                                  model: state.listRegions[index],
                                ),
                              ));
                        },
                        childCount: state.listRegions.length,
                      ),
                    ),
                  ],
                ),
              ));
        }
        if (state is MainErrorDataState) {
          return Scaffold(body: _buildErrorWidget());
        }
        return const SizedBox.shrink();
      }),
    );
  }

  List<PopupMenuItem<int>> _buildSortPopup(int selectSort) {
    Widget checkIcon = const Icon(Icons.check, color: CustomColor.green);
    return [
      PopupMenuItem(
        value: 0,
        padding: EdgeInsets.zero,
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(children: [
            const Padding(padding: EdgeInsetsDirectional.only(end: 8.0), child: Icon(Icons.warning_amber_rounded)),
            const Text("Сперва тревоги"),
            const Spacer(),
            if (selectSort == 0) checkIcon,
          ]),
        ),
      ),
      PopupMenuItem(
        value: 1,
        padding: EdgeInsets.zero,
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(children: [
            const Padding(padding: EdgeInsetsDirectional.only(end: 8.0), child: Icon(Icons.shield_outlined)),
            const Text("Сперва без тревоги"),
            if (selectSort == 1) checkIcon,
          ]),
        ),
      ),
      PopupMenuItem(
        value: 2,
        padding: EdgeInsets.zero,
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(children: [
            const Padding(padding: EdgeInsetsDirectional.only(end: 8.0), child: Icon(Icons.sort_by_alpha_outlined)),
            const Text("По алфавиту"),
            if (selectSort == 2) checkIcon,
          ]),
        ),
      ),
      PopupMenuItem(
        value: 3,
        padding: EdgeInsets.zero,
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(children: [
            const Padding(padding: EdgeInsetsDirectional.only(end: 8.0), child: Icon(Icons.keyboard_double_arrow_down_outlined)),
            const Text("от Я до А"),
            if (selectSort == 3) checkIcon,
          ]),
        ),
      ),
    ];
  }

  Widget _buildMap(List<RegionModel> allRegion) {
    return InteractiveViewer(
      maxScale: 3,
      minScale: 1,
      child: Container(
          alignment: Alignment.center,
          width: MediaQuery.of(context).size.width,
          color: CustomColor.backgroundLight,
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxHeight: 300, maxWidth: 380, minHeight: 300, minWidth: 380),
            child: LayoutBuilder(builder: ((context, constraints) {
              double w = constraints.maxWidth;
              double h = constraints.minHeight;
              return Stack(
                children: [
                  Positioned(
                    top: 30,
                    left: 0,
                    right: 0,
                    bottom: 0,
                    child: SvgPicture.string(
                      fit: BoxFit.fitWidth,
                      UkrainSvg.getSvgStr(regions: allRegion),
                      placeholderBuilder: (BuildContext context) => Center(
                        child: Lottie.asset('assets/lottie/load2.json', width: 250, height: 250, frameRate: FrameRate(60)),
                      ),
                    ),
                  ),
                  Positioned(top: h * 0.55, left: w * 0.64, child: _buildMapText("Днепропетровск", allRegion, ERegion.dnipro, fontSize: 6)),
                  Positioned(top: h * 0.48, left: w * 0.89, child: _buildMapText("Луганск", allRegion, ERegion.lugan, fontSize: 6)),
                  Positioned(top: h * 0.6, left: w * 0.82, child: _buildMapText("Донецк", allRegion, ERegion.donetsk)),
                  Positioned(top: h * 0.66, left: w * 0.69, child: _buildMapText("Запорожье", allRegion, ERegion.zapor, fontSize: 6.5)),
                  Positioned(top: h * 0.72, left: w * 0.6, child: _buildMapText("Херсон", allRegion, ERegion.herson)),
                  Positioned(top: h * 0.85, left: w * 0.62, child: _buildMapText("АР Крым", allRegion, ERegion.krim, fontSize: 6)),
                  Positioned(top: h * 0.4, left: w * 0.74, child: _buildMapText("Харьков", allRegion, ERegion.harkiv, fontSize: 9)),
                  Positioned(top: h * 0.4, left: w * 0.585, child: _buildMapText("Полтава", allRegion, ERegion.poltava, fontSize: 9)),
                  Positioned(top: h * 0.28, left: w * 0.62, child: _buildMapText("Сумы", allRegion, ERegion.sumska, fontSize: 9)),
                  Positioned(top: h * 0.24, left: w * 0.49, child: _buildMapText("Чернигов", allRegion, ERegion.chernigev, fontSize: 7)),
                  Positioned(top: h * 0.34, left: w * 0.43, child: _buildMapText("Киев", allRegion, ERegion.kyiv, fontSize: 11)),
                  Positioned(top: h * 0.46, left: w * 0.46, child: _buildMapText("Черкасы", allRegion, ERegion.cherkasy, fontSize: 8)),
                  Positioned(top: h * 0.54, left: w * 0.48, child: _buildMapText("Кировоград", allRegion, ERegion.kirovograd)),
                  Positioned(top: h * 0.64, left: w * 0.5, child: _buildMapText("Николаев", allRegion, ERegion.mikolaev, fontSize: 6)),
                  Positioned(top: h * 0.67, left: w * 0.41, child: _buildMapText("Одесса", allRegion, ERegion.odesa, fontSize: 6)),
                  Positioned(top: h * 0.31, left: w * 0.29, child: _buildMapText("Житомир", allRegion, ERegion.jitomer, fontSize: 7)),
                  Positioned(top: h * 0.5, left: w * 0.31, child: _buildMapText("Винница", allRegion, ERegion.vinetsk, fontSize: 7)),
                  Positioned(top: h * 0.26, left: w * 0.22, child: _buildMapText("Ровно", allRegion, ERegion.rivno, fontSize: 7)),
                  Positioned(top: h * 0.26, left: w * 0.11, child: _buildMapText("Луцк", allRegion, ERegion.volinska, fontSize: 10)),
                  Positioned(top: h * 0.40, left: w * 0.23, child: _buildMapText("Хмель-\nницкий", allRegion, ERegion.hmelnytsk, fontSize: 6)),
                  Positioned(top: h * 0.44, left: w * 0.16, child: _buildMapText("Терно-\nполь", allRegion, ERegion.ternopil, fontSize: 6)),
                  Positioned(top: h * 0.4, left: w * 0.06, child: _buildMapText("Львов", allRegion, ERegion.lvow, fontSize: 8)),
                  Positioned(top: h * 0.54, left: w * 0.01, child: _buildMapText("Ужгород", allRegion, ERegion.zakarpatska, fontSize: 6)),
                  Positioned(
                      top: h * 0.51, left: w * 0.09, child: _buildMapText("Ивано-\nФранковск", allRegion, ERegion.ivanoFrankowsk, fontSize: 5)),
                  Positioned(top: h * 0.57, left: w * 0.17, child: _buildMapText("Черновцы", allRegion, ERegion.chernivets, fontSize: 5)),
                ],
              );
            })),
          )),
    );
  }

  Widget _buildMapText(String region, List<RegionModel> regionlist, ERegion eregion, {double fontSize = 7}) {
    return GestureDetector(
      onTap: () async => await showDistrictDialog(context, regionlist.firstWhere((element) => eregion == element.region)),
      child: Text(
        region,
        textAlign: TextAlign.center,
        style: TextStyle(fontSize: fontSize),
      ),
    );
  }

  Widget _buildErrorWidget() {
    return Center(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Lottie.asset(
            'assets/lottie/no-connect.json',
            width: 240,
            height: 240,
            frameRate: FrameRate(60),
          ),
          const Text(
            "Потерянно соединение",
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 22),
          ),
          const Padding(padding: EdgeInsets.symmetric(vertical: 10)),
          const Text(
            "проверьте интернет-соединение",
            style: TextStyle(fontSize: 19),
          )
        ],
      ),
    );
  }
}
