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
import '../select_region/select_region_screen.dart';
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

  double toDouble(TimeOfDay myTime) => myTime.hour + myTime.minute / 60.0;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MainBloc, MainState>(
      bloc: _bloc,
      builder: (BuildContext context, MainState state) {
        if (state is MainLoadedDataState || state is MainInitialState) {
          return _buildScaffold(
            const Center(
              child: CircularProgressIndicator(
                color: Colors.indigo,
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
                          height: sizeAllListHeight ?? (UiTools.getAlarmRegion(state.listRegions).isEmpty ? 340 : 215),
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
        return Scaffold(
          body: _buildErrorWidget(),
        );
      },
    );
  }

  Widget _buildScaffold(Widget child, {List<RegionModel>? allRegion}) {
    return Scaffold(
        backgroundColor: CustomColor.background,
        appBar: _buildAppBar(),
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
                  child: SizedBox(
                    height: 300,
                    width: 360,
                    child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                        child: Stack(
                          children: [
                            Positioned.fill(
                              top: 30,
                              child: SvgPicture.string(
                                UkrainSvg.getSvgStr(regions: allRegion),
                                height: 330,
                                placeholderBuilder: (BuildContext context) => Container(),
                              ),
                            ),
                            Positioned(child: _buildMapText("Днепропетровск"), top: 150, left: 203),
                            Positioned(child: _buildMapText("Луганск"), top: 130, left: 285),
                            Positioned(child: _buildMapText("Донецк"), top: 163, left: 263),
                            Positioned(child: _buildMapText("Запорожье"), top: 183, left: 223),
                            Positioned(child: _buildMapText("Херсон"), top: 195, left: 190),
                            Positioned(child: _buildMapText("Харьков", fontSize: 9), top: 115, left: 239),
                            Positioned(child: _buildMapText("Полтава", fontSize: 9), top: 115, left: 190),
                            Positioned(child: _buildMapText("Сумы", fontSize: 9), top: 80, left: 200),
                            Positioned(child: _buildMapText("Чернигов", fontSize: 8), top: 70, left: 154),
                            Positioned(child: _buildMapText("Киев", fontSize: 11), top: 95, left: 138),
                            Positioned(child: _buildMapText("Черкасы", fontSize: 8), top: 130, left: 145),
                            Positioned(child: _buildMapText("Кировоград"), top: 150, left: 155),
                            Positioned(child: _buildMapText("Николаев", fontSize: 6), top: 180, left: 162),
                            Positioned(child: _buildMapText("Одесса", fontSize: 6), top: 180, left: 133),
                            Positioned(child: _buildMapText("Житомир", fontSize: 7), top: 90, left: 95),
                            Positioned(child: _buildMapText("Винница", fontSize: 7), top: 135, left: 100),
                            Positioned(child: _buildMapText("Ровно", fontSize: 7), top: 70, left: 70),
                            Positioned(child: _buildMapText("Луцк", fontSize: 10), top: 70, left: 37),
                            Positioned(child: _buildMapText("Хмель-\nницкий", fontSize: 7), top: 115, left: 74),
                            Positioned(child: _buildMapText("Терно-\nполь", fontSize: 6), top: 120, left: 51),
                            Positioned(child: _buildMapText("Львов", fontSize: 8), top: 110, left: 20),
                            Positioned(child: _buildMapText("Ужгород", fontSize: 6.5), top: 150, left: 5),
                            Positioned(child: _buildMapText("Ивано-\nФранковск", fontSize: 5), top: 140, left: 34),
                            Positioned(child: _buildMapText("Черновцы", fontSize: 5), top: 156, left: 53),
                          ],
                        )),
                  ),
                ),
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
                                sizeAllListHeight = MediaQuery.of(context).size.height - (UiTools.getAlarmRegion(allRegion).isEmpty ? 80 : 205);
                                _controller.forward();
                              } else {
                                sizeAllListTop = 332;
                                sizeAllListHeight = (UiTools.getAlarmRegion(allRegion).isEmpty ? 335 : 210);
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

  Widget _buildEmptyList() {
    return CupertinoButton(
      padding: EdgeInsets.zero,
      child: Container(
        height: 80,
        decoration: BoxDecoration(
          color: CustomColor.listCardColor.withOpacity(0.4),
          borderRadius: const BorderRadius.all(Radius.circular(5)),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 13),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Text(
                "Добавить область",
                textAlign: TextAlign.center,
                style: TextStyle(color: CustomColor.textColor, fontSize: 25, fontWeight: FontWeight.bold),
              ),
              Icon(Icons.add_circle_outline_sharp, size: 40, color: CustomColor.textColor),
            ],
          ),
        ),
      ),
      onPressed: () async {
        if (await Navigator.push(context, MaterialPageRoute(builder: (context) => const SelectRegionScreen()))) {
          _bloc.add(MainForcedUpdateEvent());
        }
      },
    );
  }

  Widget _buildErrorWidget() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Container(
          height: 230,
          decoration: BoxDecoration(
            color: CustomColor.listCardColor.withOpacity(0.4),
            borderRadius: const BorderRadius.all(Radius.circular(15)),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 15),
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
          ),
        ),
      ),
    );
  }
}
