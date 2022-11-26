import 'package:alarm/tools/custom_color.dart';
import 'package:fl_animated_linechart/chart/animated_line_chart.dart';
import 'package:fl_animated_linechart/chart/line_chart.dart';
import 'package:flutter/material.dart';

import '../bloc/history_bloc.dart';

class TabGraphWidget extends StatelessWidget {
  final HistoryLoadedState state;
  const TabGraphWidget({super.key, required this.state});

  Map<DateTime, double> _getDataChart() {
    Map<DateTime, double> data = {};
    DateTime dateNow = DateTime.now();

    state.historyGraph.forEach((key, value) {
      data[DateTime(dateNow.year, dateNow.month, key)] = value.toDouble();
    });

    return data;
  }

  @override
  Widget build(BuildContext context) {
    Map<DateTime, double> mapData = _getDataChart();
    LineChart dataChart = LineChart.fromDateTimeMaps([mapData], [CustomColor.systemSecondary], ["Тревоги за текущий месяц"]);
    if (mapData.isNotEmpty) {
      return Padding(
        padding: const EdgeInsets.only(bottom: 30, top: 25, right: 24),
        child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                  child: AnimatedLineChart(
                dataChart,
                gridColor: CustomColor.background,
                tapText: (prefix, y, unit) {
                  return "Кол-во тревог: ${y.toInt()}\nДата: ${prefix.replaceAll("24:00", "")}";
                },
                toolTipColor: CustomColor.systemSecondary,
              )),
            ]),
      );
    }

    return const Center(
      child: Text(
        "Нет данных за текущий месяц",
        style: TextStyle(fontSize: 18),
      ),
    );
  }
}
