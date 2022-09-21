import 'package:alarm/tools/region/eregion.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:lottie/lottie.dart';
import 'package:package_info_plus/package_info_plus.dart';
import '../../dialog/update_dialog.dart';
import '../../tools/connection/connection.dart';
import '../../models/region_model.dart';
import '../../tools/repository/config_repository.dart';
import '../../tools/ui_tools.dart';
import '../../tools/ukrain_svg.dart';
import '../../tools/update_info.dart';
import '../drawer/drawer_screen.dart';
import 'bloc/main_bloc.dart';
import '../../tools/custom_color.dart';
import 'widget/card_list_small_widget.dart';
import 'widget/card_list_widget.dart';
import 'widget/modal_top_widget.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> with SingleTickerProviderStateMixin {
  late final MainBloc _bloc;

  double sizeAllListTop = 332;
  double? sizeAllListHeight;
  late final AnimationController _controller;

  Future<bool> _isUpdateCheck() async {
    bool result = false;
    try {
      UpdateInfo.infoUpdate = await Conectrion.chekUpdate();
      PackageInfo infoApp = await PackageInfo.fromPlatform();

      if (infoApp.version != UpdateInfo.infoUpdate.newVersion) {
        result = true;
      }
    } catch (e) {
      debugPrint(e.toString());
    }

    return result;
  }

  @override
  void initState() {
    _bloc = MainBloc();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    SchedulerBinding.instance.addPostFrameCallback((_) async {
      if (await _isUpdateCheck()) {
        showUpdateDialog(context);
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    _bloc.close();
    super.dispose();
  }

  AppBar _buildAppBar() {
    return AppBar(
      toolbarHeight: 40,
      backgroundColor: CustomColor.backgroundLight,
      elevation: 0.0,
      titleSpacing: 0,
      actions: [_buildWarCounter()],
    );
  }

  Widget _buildWarCounter() {
    if (ConfigRepository.instance.config.war == true && ConfigRepository.instance.config.startWarDate != null) {
      int warDay = DateTime.now().difference(ConfigRepository.instance.config.startWarDate!).inDays + 1;
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
        child: Text("$warDay день войны", textAlign: TextAlign.center, style: const TextStyle(color: CustomColor.red)),
      );
    }
    return const SizedBox.shrink();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MainBloc, MainState>(
      bloc: _bloc,
      builder: (BuildContext context, MainState state) {
        if (state is MainLoadedDataState || state is MainInitialState) {
          return Scaffold(
            backgroundColor: CustomColor.background,
            body: Center(
              child: Lottie.asset(
                'assets/lottie/load2.json',
                width: 250,
                height: 250,
                frameRate: FrameRate(60),
              ),
            ),
          );
        }
        if (state is MainLoadDataState) {
          return _buildScaffold(
            Padding(
              padding: const EdgeInsets.only(top: 15, right: 5, left: 5),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  UiTools.getAlarmRegion(state.listRegions).isNotEmpty
                      ? _buildAlertList(UiTools.getAlarmRegion(state.listRegions))
                      : const SizedBox.shrink(),
                  Expanded(
                    child: Stack(
                      fit: StackFit.expand,
                      children: [
                        Positioned.fill(
                          child: _buildMap(state.listRegions),
                        ),
                        AnimatedPositioned(
                          top: sizeAllListTop,
                          curve: Curves.easeOutCirc,
                          height: sizeAllListHeight ?? _getHeightAllRegion(context, false, UiTools.getAlarmRegion(state.listRegions).isNotEmpty),
                          width: MediaQuery.of(context).size.width,
                          duration: const Duration(milliseconds: 600),
                          child: _buildAllRegion(state.listRegions),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            allRegion: state.listRegions,
          );
        }
        return Scaffold(body: _buildErrorWidget());
      },
    );
  }

  Widget _buildScaffold(Widget child, {List<RegionModel>? allRegion}) {
    return Scaffold(
        backgroundColor: CustomColor.background,
        appBar: _buildAppBar(),
        resizeToAvoidBottomInset: false,
        drawer: CustomDrawer(allRegion: allRegion ?? []),
        body: SafeArea(
          child: child,
        ));
  }

  Widget _buildMap(List<RegionModel> allRegion) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 5),
              color: CustomColor.backgroundLight,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 5),
                child: Row(
                  children: [
                    const Icon(Icons.map_outlined, color: Colors.greenAccent),
                    _buildTitle("Карта"),
                  ],
                ),
              )),
          Stack(
            children: [
              InteractiveViewer(
                maxScale: 3,
                minScale: 1,
                child: Container(
                    alignment: Alignment.center,
                    width: MediaQuery.of(context).size.width,
                    color: CustomColor.backgroundLight,
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxHeight: 300, maxWidth: 360, minHeight: 300, minWidth: 360),
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
                            Positioned(
                                top: h * 0.40, left: w * 0.23, child: _buildMapText("Хмель-\nницкий", allRegion, ERegion.hmelnytsk, fontSize: 6)),
                            Positioned(top: h * 0.44, left: w * 0.16, child: _buildMapText("Терно-\nполь", allRegion, ERegion.ternopil, fontSize: 6)),
                            Positioned(top: h * 0.4, left: w * 0.06, child: _buildMapText("Львов", allRegion, ERegion.lvow, fontSize: 8)),
                            Positioned(top: h * 0.54, left: w * 0.01, child: _buildMapText("Ужгород", allRegion, ERegion.zakarpatska, fontSize: 6)),
                            Positioned(
                                top: h * 0.51,
                                left: w * 0.09,
                                child: _buildMapText("Ивано-\nФранковск", allRegion, ERegion.ivanoFrankowsk, fontSize: 5)),
                            Positioned(top: h * 0.57, left: w * 0.17, child: _buildMapText("Черновцы", allRegion, ERegion.chernivets, fontSize: 5)),
                          ],
                        );
                      })),
                    )),
              ),
              Positioned(
                child: Container(
                  padding: const EdgeInsets.all(8),
                  height: 55,
                  width: double.infinity,
                  color: CustomColor.backgroundLight.withOpacity(0.5),
                  child: UiTools.getAlarmRegion(allRegion).isNotEmpty
                      ? Column(
                          children: [
                            Text("Тревога на ${UiTools.getPercentAlarm(allRegion)}% територии", style: const TextStyle(fontSize: 18)),
                            Text(
                                "(${UiTools.getAlarmRegion(allRegion).length} ${UiTools.declinationWordByNumber(UiTools.getAlarmRegion(allRegion).length, "Область", "Области", "Областей")})",
                                style: TextStyle(fontSize: 13, color: Colors.white.withOpacity(0.7))),
                          ],
                        )
                      : const Text(
                          "Тревоги нет",
                          style: TextStyle(color: CustomColor.green, fontSize: 19, fontWeight: FontWeight.w700),
                          textAlign: TextAlign.center,
                        ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 7),
      child: Text(title, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
    );
  }

  double _getHeightAllRegion(BuildContext context, bool isOpen, bool isAlarmBloc) {
    if (isAlarmBloc) {
      return MediaQuery.of(context).size.height - (50 + 120 + 40 + (isOpen ? 0 : 339));
    }
    return MediaQuery.of(context).size.height - (50 + 30 + (isOpen ? 0 : 339));
  }

  Widget _buildAllRegion(List<RegionModel> allRegion) {
    return Padding(
      padding: const EdgeInsets.only(top: 10),
      child: Container(
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(5), color: CustomColor.backgroundLight),
        padding: const EdgeInsets.only(top: 4),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(5),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 5),
                child: SizedBox(
                  height: 24,
                  child: Row(
                    children: [
                      const Icon(Icons.pix, color: Colors.indigoAccent),
                      Expanded(
                        child: _buildTitle("Области"),
                      ),
                      const Spacer(),
                      CupertinoButton(
                          onPressed: () {
                            setState(() {
                              if (sizeAllListTop == 332) {
                                sizeAllListTop = -5;
                                sizeAllListHeight = _getHeightAllRegion(context, true, UiTools.getAlarmRegion(allRegion).isNotEmpty);

                                _controller.forward();
                              } else {
                                sizeAllListTop = 332;
                                sizeAllListHeight = _getHeightAllRegion(context, false, UiTools.getAlarmRegion(allRegion).isNotEmpty);

                                _controller.reverse();
                              }
                            });
                          },
                          padding: const EdgeInsets.symmetric(
                            horizontal: 20,
                          ),
                          child: RotationTransition(
                            turns: Tween(begin: 0.0, end: 0.5).animate(_controller),
                            child: const Icon(Icons.expand_less, color: Colors.white, size: 30),
                          ))
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Expanded(child: _buildList(allRegion)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAlertList(List<RegionModel> alertsRegions) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: SizedBox(
          height: 120,
          child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                color: CustomColor.backgroundLight,
              ),
              padding: const EdgeInsets.only(top: 4),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(5),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 5),
                      child: Row(
                        children: [
                          const Icon(
                            Icons.warning_amber_rounded,
                            color: CustomColor.red,
                          ),
                          _buildTitle("Тревоги"),
                          const Spacer(),
                          Container(
                            width: 25,
                            height: 25,
                            margin: const EdgeInsets.symmetric(horizontal: 5),
                            alignment: Alignment.center,
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              color: CustomColor.red,
                            ),
                            child: Text(alertsRegions.length.toString(), style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 13)),
                          )
                        ],
                      ),
                    ),
                    Expanded(
                      child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: alertsRegions.length,
                        scrollDirection: Axis.horizontal,
                        itemBuilder: (BuildContext context, int index) {
                          return Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: CardListSmall(region: alertsRegions[index]),
                          );
                        },
                      ),
                    )
                  ],
                ),
              ))),
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

  Widget _buildList(List<RegionModel> listRegions) {
    return ColoredBox(
      color: CustomColor.background,
      child: ListView.builder(
        itemBuilder: (BuildContext context, int index) {
          return Padding(
              key: ValueKey(listRegions[index].region),
              padding: const EdgeInsets.symmetric(vertical: 3),
              child: CupertinoButton(
                onPressed: () async => await showDistrictDialog(context, listRegions[index]),
                padding: EdgeInsets.zero,
                child: CardList(
                  key: ValueKey(listRegions[index].region),
                  model: listRegions[index],
                ),
              ));
        },
        itemCount: listRegions.length,
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
