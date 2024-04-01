import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottie/lottie.dart';

import '../../../models/region_model.dart';
import '../../../tools/custom_color.dart';
import '../../../tools/ui_tools.dart';
import '../bloc/home_bloc.dart';

class ListScreen extends StatelessWidget {
  final AlertBloc bloc = AlertBloc();

  ListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 45),
      child: BlocBuilder(
        bloc: bloc,
        builder: (context, state) {
          if (state is HomeUpdateState) {
            return Column(
              children: [
                _buildInfoStatLineContaner(
                    alert: UiTools.getCountAlarmRegion(state.listRegions),
                    atantion: UiTools.getCountWarningRegion(state.listRegions),
                    noAlert: UiTools.getCountNoAlarmRegion(state.listRegions)),
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        for (int i = 0; i < state.listRegions.length; i++) _buildCard(state.listRegions[i]),
                        const SizedBox(height: 25),
                      ],
                    ),
                  ),
                ),
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
      ),
    );
  }

  Widget _buildInfoStatLineContaner({required int noAlert, required int atantion, required int alert}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
      color: CustomColor.backgroundCard,
      child: Column(
        children: [
          _buildStatusLine(noAlert: noAlert, atantion: atantion, alert: alert),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Без тревоги: $noAlert", style: const TextStyle(fontSize: 13, color: CustomColor.green)),
              Text("Опасность: $atantion", style: const TextStyle(fontSize: 13, color: CustomColor.atantion)),
              Text("Тревоги: $alert", style: const TextStyle(fontSize: 13, color: CustomColor.red)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatusLine({required int noAlert, required int atantion, required int alert}) {
    int summa = (noAlert + atantion + alert);
    double onePercent = (summa != 0 ? 100 / summa : summa).toDouble();

    if (summa == 0) {
      return Container(
        width: double.infinity,
        height: 8,
        clipBehavior: Clip.hardEdge,
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(8), color: CustomColor.gray),
      );
    }

    return Container(
      width: double.infinity,
      height: 8,
      clipBehavior: Clip.hardEdge,
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(8)),
      child: Row(
        children: [
          Expanded(flex: (onePercent * noAlert).toInt(), child: Container(color: CustomColor.green)),
          Expanded(flex: (onePercent * atantion).toInt(), child: Container(color: CustomColor.atantion)),
          Expanded(flex: (onePercent * alert).toInt(), child: Container(color: CustomColor.red))
        ],
      ),
    );
  }

  Widget _buildCard(RegionModel model) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 15),
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      width: double.infinity,
      decoration: BoxDecoration(
        color: CustomColor.backgroundCard,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          Row(
            children: [
              _buildValue(value: model.title, size: 16, flex: 2),
              _buildValue(
                  size: 16, value: UiTools.getAlarmStr(model.isAlarm, model.districts), align: TextAlign.end, color: UiTools.getAlarmColor(model)),
            ],
          ),
          const Divider(height: 35),
          model.isAlarm ? _buildAlertData(model) : _buildNotAlertData(model),
        ],
      ),
    );
  }

  Widget _buildAlertData(RegionModel model) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        _buildTitleValue(title: "Время тревоги", value: model.timeDurationAlarmStr!),
        _buildTitleValue(title: "Начало тревоги", value: model.timeStartStr!, align: CrossAxisAlignment.end),
      ],
    );
  }

  Widget _buildNotAlertData(RegionModel model) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        _buildTitleValue(title: "Время без тревоги", value: model.timeDurationCancelAlarmStr!),
        _buildTitleValue(title: "Конец тревоги", value: model.timeEndStr!, align: CrossAxisAlignment.end),
      ],
    );
  }

  Widget _buildTitleValue({required String title, required String value, CrossAxisAlignment align = CrossAxisAlignment.start}) {
    return Expanded(
        child: Column(
      crossAxisAlignment: align,
      children: [
        Text(title, textAlign: TextAlign.end, style: TextStyle(fontSize: 14, color: CustomColor.textColor.withOpacity(0.6))),
        Text(value, textAlign: TextAlign.end, style: const TextStyle(fontSize: 15)),
      ],
    ));
  }

  Widget _buildValue({required String value, Color? color, double? size, TextAlign? align, int flex = 1}) {
    return Expanded(
      flex: flex,
      child: Text(
        value,
        textAlign: align,
        style: TextStyle(color: color, fontSize: size),
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
            width: 200,
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
            style: TextStyle(fontSize: 14, color: CustomColor.textColor.withOpacity(0.7)),
          )
        ],
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
}
