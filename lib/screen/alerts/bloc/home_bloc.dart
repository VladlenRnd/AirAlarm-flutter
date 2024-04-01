import 'dart:async';

import 'package:alarm/tools/ui_tools.dart';

import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import '../../../../models/district_model.dart';
import '../../../../models/region_model.dart';
import '../../../../service/shered_preferences_service.dart';
import '../../../../tools/connection/connection.dart';
import '../../../../tools/connection/response/alarm_response.dart';
import '../../../../tools/history.dart';
import '../../../../tools/region/eregion.dart';

part 'home_event.dart';
part 'home_state.dart';

class AlertBloc extends Bloc<HomeEvent, HomeState> {
  int _oldDataTry = 0;
  Timer? _timer;

  AlertBloc() : super(HomeLoadingState()) {
    on<HomeEvent>((event, emit) async {
      if (event is HomeSaveRegionEvent) {
        _getData();
      }
      if (event is HomeUpdateEvent) {
        _oldDataTry = 0;
        emit.call(
          HomeUpdateState(listRegions: _getAllRegion(event.data.states)),
        );
      }
      if (event is HomeErrorEvent) {
        if (state is HomeUpdateState && _oldDataTry < 3) {
          _oldDataTry++;
          emit.call(state);
        } else {
          emit.call(HomeErrorDataState());
        }
      }
      if (event is HomeChangeSort) {
        //TODO SORT CHANGE
        SheredPreferencesService.preferences.setInt("sort", event.sortIndex);
        if (state is HomeUpdateState) {
          emit.call(
            HomeUpdateState(listRegions: (state as HomeUpdateState).listRegions),
          );
        }
      }
    });

    _initTimerData();
    _getData();
  }

  void _initTimerData() async {
    _timer = Timer.periodic(const Duration(seconds: 5), (timer) {
      _getData();
    });
  }

  void _getData() async {
    try {
      add(HomeUpdateEvent(data: await Connection.getAlarm()));
    } catch (e) {
      add(HomeErrorEvent());
      throw Exception("Not data Alarm");
    }
  }

  List<RegionModel> _getAllRegion(States states) {
    return [
      _getRegionModel(states.dnipro, ERegion.dnipro),
      _getRegionModel(states.harkiv, ERegion.harkiv),
      _getRegionModel(states.kyiv, ERegion.kyiv),
      _getRegionModel(states.lugan, ERegion.lugan),
      _getRegionModel(states.zapor, ERegion.zapor),
      _getRegionModel(states.donetsk, ERegion.donetsk),
      _getRegionModel(states.jitomer, ERegion.jitomer),
      _getRegionModel(states.zakarpatska, ERegion.zakarpatska),
      _getRegionModel(states.ivanoFrankowsk, ERegion.ivanoFrankowsk),
      _getRegionModel(states.kirovograd, ERegion.kirovograd),
      _getRegionModel(states.lvow, ERegion.lvow),
      _getRegionModel(states.mikolaev, ERegion.mikolaev),
      _getRegionModel(states.odesa, ERegion.odesa),
      _getRegionModel(states.rivno, ERegion.rivno),
      _getRegionModel(states.sumska, ERegion.sumska),
      _getRegionModel(states.ternopil, ERegion.ternopil),
      _getRegionModel(states.herson, ERegion.herson),
      _getRegionModel(states.hmelnytsk, ERegion.hmelnytsk),
      _getRegionModel(states.cherkasy, ERegion.cherkasy),
      _getRegionModel(states.chernigev, ERegion.chernigev),
      _getRegionModel(states.chernivets, ERegion.chernivets),
      _getRegionModel(states.vinetsk, ERegion.vinetsk),
      _getRegionModel(states.volinska, ERegion.volinska),
      _getRegionModel(states.poltava, ERegion.poltava),
      _getRegionModel(states.krim, ERegion.krim),
    ];
  }

  List<List<DateTime>> _getHistoryThreeDay(ERegion region) {
    List<List<DateTime>> result = [];
    if (allHistory[region] == null) return [];

    result.addAll(allHistory[region]!.reversed.toList().where((element) {
      DateTime date = element[0];
      DateTime dateNow = DateTime.now().add(const Duration(days: -3));

      if (dateNow.isBefore(date)) return true;

      return false;
    }));

    return result;
  }

  RegionModel _getRegionModel(Region region, ERegion titleRegion) {
    return RegionModel(
      title: titleRegion.title,
      isAlarm: region.enabled,
      region: titleRegion,
      allHistory: allHistory[titleRegion] == null ? [] : allHistory[titleRegion]!.reversed.toList(),
      historyThreeDay: _getHistoryThreeDay(titleRegion),
      timeDurationAlarmStr: _getTimerStr(region.enabledAt),
      timeDurationAlarm: getDurationTime(region.enabledAt),
      timeDurationCancelAlarmStr: _getTimerStr(region.disabledAt),
      timeDurationCancelAlarm: getDurationTime(region.disabledAt),
      timeEndStr: _formatData(region.disabledAt),
      timeStartStr: _formatData(region.enabledAt),
      districts: _getDistrictModel(region.districts),
      curfewStr: null, //"05:00 - 00:00", //null,
      isCurfew: false,
    );
  }

  List<DistrictModel> _getDistrictModel(List<Districts> districts) {
    List<DistrictModel> result = [];

    for (Districts element in districts) {
      result.add(DistrictModel(
        title: element.title.title,
        isAlarm: element.enabled,
        districts: element.title,
        timeDurationAlarm: _getTimerStr(element.enabledAt),
        timeDurationCancelAlarm: _getTimerStr(element.disabledAt),
        timeEnd: _formatData(element.disabledAt),
        timeStart: _formatData(element.enabledAt),
      ));
    }

    return result;
  }

  Duration getDurationTime(String? time) {
    if (time != null) {
      return DateTime.now().difference(DateTime.parse(time).toLocal());
    }
    return Duration.zero;
  }

  String? _getTimerStr(String? time) {
    if (time != null) {
      Duration duration = DateTime.now().difference(DateTime.parse(time).toLocal());

      String day = duration.inDays.toString();
      String hors = (duration.inHours % 24).toString().padLeft(1, '0');
      String min = (duration.inMinutes % 60).toString().padLeft(2, '0');

      if (day == '0') {
        return "$hors:$min";
      } else {
        return "($day день)";
      }
    }
    return null;
  }

  String? _formatData(String? data) {
    if (data != null) {
      return UiTools.getDateToDay(DateTime.parse(data).toLocal(), true) ?? DateFormat('dd/MM/yyyy  HH:mm:ss').format(DateTime.parse(data).toLocal());
    }
    return null;
  }

  @override
  Future<void> close() {
    _timer?.cancel();
    return super.close();
  }
}
