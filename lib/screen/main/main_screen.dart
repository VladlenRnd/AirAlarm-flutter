import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:lottie/lottie.dart';
import 'package:package_info_plus/package_info_plus.dart';
import '../../dialog/update_dialog.dart';
import '../../tools/connection/connection.dart';
import '../../tools/region_model.dart';
import '../../tools/ukrain_svg.dart';
import '../../tools/update_info.dart';
import '../select_region/select_region_screen.dart';
import '../settings/settings_screen.dart';
import 'bloc/main_bloc.dart';
import '../../tools/custom_color.dart';
import 'widget/card_list_widget.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> with TickerProviderStateMixin {
  late final MainBloc _bloc;

  Future<bool> _isUpdateCheck() async {
    bool result = false;
    try {
      UpdateInfo.infoUpdate = await Conectrion.chekUpdate();
      PackageInfo infoApp = await PackageInfo.fromPlatform();

      if (infoApp.version != UpdateInfo.infoUpdate.newVersion) {
        result = true;
      }
    } catch (e) {
      print(e);
    }

    return result;
  }

  @override
  void initState() {
    _bloc = MainBloc();
    SchedulerBinding.instance!.addPostFrameCallback((_) async {
      UpdateInfo.isNewVersion = await _isUpdateCheck();
      if (UpdateInfo.isNewVersion) {
        showUpdateDialog(context);
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CustomColor.background,
      appBar: AppBar(
        backgroundColor: CustomColor.backgroundLight,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(20),
          ),
        ),
        elevation: 0.0,
        title: const Text("Карта воздушных тревог"),
        centerTitle: true,
        actions: [
          IconButton(
              onPressed: () async {
                await Navigator.push(context, MaterialPageRoute(builder: (context) => const SettingScreen()));
                _bloc.add(MainForcedUpdateEvent());
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
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: double.infinity,
                  color: CustomColor.background,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                    child: SvgPicture.string(UkrainSvg.getSvgStr(regions: state.allRegion),
                        alignment: Alignment.topCenter, placeholderBuilder: (BuildContext context) => Container()),
                  ),
                  height: 230,
                ),
                Container(
                  height: 5,
                  color: CustomColor.backgroundLight,
                ),
                state.listRegions.isNotEmpty ? Expanded(child: _buildList(state.listRegions)) : _buildEmptyList(),
              ],
            );
          }

          return _buildErrorWidget();
        },
      ),
    );
  }

  Widget _buildList(List<RegionModel> listRegions) {
    return ColoredBox(
      color: CustomColor.background,
      child: ReorderableListView.builder(
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
          onReorder: (int oldIndex, int newIndex) async {
            if (newIndex > oldIndex) {
              newIndex = newIndex - 1;
            }
            _bloc.add(MainReorderableEvent(oldIndex: oldIndex, newIndex: newIndex));

            listRegions.insert(newIndex, listRegions.removeAt(oldIndex));
          }),
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
