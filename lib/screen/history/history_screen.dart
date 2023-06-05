import 'package:alarm/tools/custom_color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottie/lottie.dart';

import '../../models/region_model.dart';
import '../../widget/bubble_tab_indicator_decoration.dart';
import 'bloc/history_bloc.dart';
import 'widget/tab_graph_widget.dart';
import 'widget/tab_list_history_widget.dart';

class HistoryScreen extends StatelessWidget {
  final RegionModel region;
  const HistoryScreen({super.key, required this.region});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Column(
            children: [
              const Text("История тревог"),
              const SizedBox(height: 5),
              Text(region.title, style: const TextStyle(fontSize: 14)),
            ],
          ),
        ),
        body: BlocProvider(
          create: ((_) => HistoryBloc(region: region)),
          child: BlocBuilder<HistoryBloc, HistoryState>(
            builder: (BuildContext context, HistoryState state) {
              if (state is HistoryLoadedState) {
                return _buildBody(state, context);
              }
              return _buildLoad();
            },
          ),
        ));
  }

  Widget _buildTab() {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.transparent,
            CustomColor.background,
            Colors.transparent,
          ],
        ),
      ),
      child: Theme(
        data: ThemeData(
          highlightColor: Colors.transparent,
          splashColor: CustomColor.systemSecondary,
        ),
        child: TabBar(
          labelPadding: const EdgeInsets.symmetric(horizontal: 22),
          labelColor: CustomColor.systemText,
          indicator: BubbleTabIndicator(
            tabBarIndicatorSize: TabBarIndicatorSize.label,
            indicatorHeight: 20,
            padding: const EdgeInsets.symmetric(vertical: 7),
            indicatorColor: CustomColor.systemSecondary.withOpacity(0.15),
            borderColor: CustomColor.systemSecondary,
          ),
          labelStyle: const TextStyle(fontSize: 18, color: CustomColor.textColor, fontFamily: "Days"),
          unselectedLabelColor: CustomColor.textColor.withOpacity(0.6),
          indicatorSize: TabBarIndicatorSize.tab,
          tabs: const [
            Tab(text: "Список тревог"),
            Tab(text: "График"),
          ],
        ),
      ),
    );
  }

  Widget _buildBody(HistoryLoadedState state, BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Column(
        children: [
          _buildTab(),
          Expanded(
            child: TabBarView(children: [
              TabListHistoryWidget(
                state: state,
                onChangeData: (DateTimeRange dateRange) =>
                    BlocProvider.of<HistoryBloc>(context).add(HistoryChangeDataEvent(selectStartDate: dateRange.start, selectEndDate: dateRange.end)),
              ),
              TabGraphWidget(historyGraph: state.historyGraph)
            ]),
          )
        ],
      ),
    );
  }

  Widget _buildLoad() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            height: 100,
            width: 100,
            child: Lottie.asset(
              'assets/lottie/load.json',
              width: 100,
              height: 100,
              frameRate: FrameRate(60),
            ),
          ),
          const Text(
            "Загрузка данных",
            style: TextStyle(fontSize: 25),
          )
        ],
      ),
    );
  }
}
