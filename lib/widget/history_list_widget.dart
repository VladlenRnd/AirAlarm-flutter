import 'package:flutter/material.dart';
import 'package:flutter_sticky_header/flutter_sticky_header.dart';
import 'package:intl/intl.dart';

import '../tools/custom_color.dart';

class HistoryListWidget extends StatelessWidget {
  final List<List<String>> historyData;
  final Map<String, List<List<String>>> _groupedData = {};
  HistoryListWidget({super.key, required this.historyData}) {
    _getGroup();
  }

  void _getGroup() {
    for (List<String> element in historyData) {
      DateTime date = DateTime.parse(element[0]);
      if (_groupedData[DateFormat("dd/MM/yyyy").format(date)] == null) {
        _groupedData[DateFormat("dd/MM/yyyy").format(date)] = [element];
      } else {
        _groupedData[DateFormat("dd/MM/yyyy").format(date)]!.add(element);
      }
    }
  }

  Widget _buildTitleHeader(String title, String subTitle) {
    return Container(
      height: 40,
      color: CustomColor.listCardColor,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      alignment: Alignment.centerLeft,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: const TextStyle(color: Colors.white, fontSize: 16),
          ),
          Container(
            height: 25,
            width: 25,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(14),
              color: CustomColor.systemSecondary,
            ),
            child: Text(
              subTitle,
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  List<SliverStickyHeader> _getHeaderList() {
    return _groupedData.entries.map((e) {
      return SliverStickyHeader(
        header: _buildTitleHeader("Дата ${e.key}", "${e.value.length}"),
        sliver: SliverList(
          delegate: SliverChildBuilderDelegate(
            (context, i) => _buildHistoryCard(DateTime.parse(e.value[i][0]).toLocal(), DateTime.parse(e.value[i][1]).toLocal()),
            childCount: e.value.length,
          ),
        ),
      );
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      physics: const BouncingScrollPhysics(),
      slivers: _getHeaderList(),
    );
  }

  Widget _buildCardTitleValue(String title, String date, String time, CrossAxisAlignment align) {
    return Column(
      crossAxisAlignment: align,
      children: [
        Text(title, style: TextStyle(color: Colors.white.withOpacity(0.6))),
        const SizedBox(height: 15),
        Text(date),
        Text(time),
      ],
    );
  }

  Widget _buildHistoryCard(DateTime dateStart, DateTime dateEnd) {
    Duration duration = dateEnd.difference(dateStart);
    String hors = (duration.inHours % 24).toString().padLeft(2, '0');
    String min = (duration.inMinutes % 60).toString().padLeft(2, '0');

    return Container(
      height: 80,
      width: double.infinity,
      margin: const EdgeInsets.symmetric(horizontal: 1, vertical: 5),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: CustomColor.background,
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _buildCardTitleValue(
                "Начало", DateFormat("dd/MM/yyyy").format(dateStart), DateFormat("HH:mm").format(dateStart), CrossAxisAlignment.start),
            _buildCardTitleValue("Время", "$hors:$min", "", CrossAxisAlignment.center),
            _buildCardTitleValue("Конец", DateFormat("dd/MM/yyyy").format(dateEnd), DateFormat("HH:mm").format(dateEnd), CrossAxisAlignment.end),
          ],
        ),
      ),
    );
  }
}
