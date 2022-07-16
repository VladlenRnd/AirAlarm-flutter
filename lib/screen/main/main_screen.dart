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
import '../../tools/ui_tools.dart';
import '../../tools/ukrain_svg.dart';
import '../../tools/update_info.dart';
import '../drawer/drawer_screen.dart';
import 'bloc/main_bloc.dart';
import '../../tools/custom_color.dart';
import 'widget/card_list_small_widget.dart';
import 'widget/card_list_widget.dart';

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
      UpdateInfo.isNewVersion = await _isUpdateCheck();
      if (UpdateInfo.isNewVersion) {
        showUpdateDialog(context);
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  AppBar _buildAppBar() {
    return AppBar(
      toolbarHeight: 40,
      backgroundColor: CustomColor.backgroundLight,
      elevation: 0.0,
      titleSpacing: 0,
    );
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
                          child: _buildAllRegion(state.listRegions),
                          duration: const Duration(milliseconds: 600),
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
                      child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                          child: Stack(
                            children: [
                              Positioned.fill(
                                top: 30,
                                child: SvgPicture.string(
                                  UkrainSvg.getSvgStr(regions: allRegion),
                                  placeholderBuilder: (BuildContext context) => Container(),
                                ),
                              ),
                              Positioned.fill(child: _buildMapText("Днепропетровск", fontSize: 6), top: 150, left: 143),
                              Positioned.fill(child: _buildMapText("Луганск", fontSize: 6), top: 130, left: 278),
                              Positioned.fill(child: _buildMapText("Донецк"), top: 163, left: 232),
                              Positioned.fill(child: _buildMapText("Запорожье", fontSize: 6.5), top: 183, left: 163),
                              Positioned.fill(child: _buildMapText("Херсон"), top: 195, left: 93),
                              Positioned.fill(child: _buildMapText("Харьков", fontSize: 9), top: 115, left: 195),
                              Positioned.fill(child: _buildMapText("Полтава", fontSize: 9), top: 115, left: 100),
                              Positioned.fill(child: _buildMapText("Сумы", fontSize: 9), top: 80, left: 110),
                              Positioned.fill(child: _buildMapText("Чернигов", fontSize: 7), top: 70, left: 25),
                              Positioned.fill(child: _buildMapText("Киев", fontSize: 11), top: 95, left: -20),
                              Positioned.fill(child: _buildMapText("Черкасы", fontSize: 8), top: 130, left: 0),
                              Positioned.fill(child: _buildMapText("Кировоград"), top: 150, left: 30),
                              Positioned.fill(child: _buildMapText("Николаев", fontSize: 6), top: 180, left: 30),
                              Positioned.fill(child: _buildMapText("Одесса", fontSize: 6), top: 180, left: -35),
                              Positioned.fill(child: _buildMapText("Житомир", fontSize: 7), top: 90, left: -100),
                              Positioned.fill(child: _buildMapText("Винница", fontSize: 7), top: 135, left: -93),
                              Positioned.fill(child: _buildMapText("Ровно", fontSize: 7), top: 70, left: -163),
                              Positioned.fill(child: _buildMapText("Луцк", fontSize: 10), top: 70, left: -230),
                              Positioned.fill(child: _buildMapText("Хмель-\nницкий", fontSize: 6), top: 115, left: -150),
                              Positioned.fill(child: _buildMapText("Терно-\nполь", fontSize: 6), top: 120, left: -200),
                              Positioned.fill(child: _buildMapText("Львов", fontSize: 8), top: 110, left: -257),
                              Positioned.fill(child: _buildMapText("Ужгород", fontSize: 6), top: 150, left: -285),
                              Positioned.fill(child: _buildMapText("Ивано-\nФранковск", fontSize: 5), top: 140, left: -230),
                              Positioned.fill(child: _buildMapText("Черновцы", fontSize: 5), top: 156, left: -200),
                            ],
                          )),
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
                          child: RotationTransition(
                            turns: Tween(begin: 0.0, end: 0.5).animate(_controller),
                            child: const Icon(Icons.expand_less, color: Colors.white, size: 30),
                          ),
                          onPressed: () {
                            setState(() {
                              if (sizeAllListTop == 332) {
                                sizeAllListTop = -5;
                                sizeAllListHeight = _getHeightAllRegion(context, true, UiTools.getAlarmRegion(allRegion).isNotEmpty);
                                //- (UiTools.getAlarmRegion(allRegion).isEmpty ? 80 : 205);
                                _controller.forward();
                              } else {
                                sizeAllListTop = 332;
                                sizeAllListHeight = _getHeightAllRegion(context, false, UiTools.getAlarmRegion(allRegion).isNotEmpty);
                                //- 576; //(UiTools.getAlarmRegion(allRegion).isEmpty ? 0 : 0);
                                _controller.reverse();
                              }
                            });
                          },
                          padding: const EdgeInsets.symmetric(
                            horizontal: 20,
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
                            width: 22,
                            height: 22,
                            margin: const EdgeInsets.symmetric(horizontal: 5),
                            alignment: Alignment.center,
                            child: Text(alertsRegions.length.toString(), style: const TextStyle(fontWeight: FontWeight.w800)),
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              color: CustomColor.red,
                            ),
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

  Widget _buildMapText(String region, {double fontSize = 7}) {
    return Text(
      region,
      textAlign: TextAlign.center,
      style: TextStyle(fontSize: fontSize),
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
            child: CardList(
              key: ValueKey(listRegions[index].region),
              model: listRegions[index],
            ),
          );
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
