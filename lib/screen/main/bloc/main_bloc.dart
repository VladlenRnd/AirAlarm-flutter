import 'dart:async';

import 'package:alarm/tools/ui_tools.dart';

import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import '../../../models/district_model.dart';
import '../../../service/shered_preferences_service.dart';
import '../../../tools/connection/connection.dart';
import '../../../tools/connection/response/alarm_response.dart';
import '../../../tools/history.dart';
import '../../../tools/region/eregion.dart';
import '../../../models/region_model.dart';

part 'main_event.dart';
part 'main_state.dart';

class MainBloc extends Bloc<MainEvent, MainState> {
  int _oldDataTry = 0;
  Timer? _timer;
  int? sortIndex = SheredPreferencesService.preferences.getInt("sort");
  final AlarmRespose respose;

  MainBloc(this.respose) : super(MainInitialState()) {
    on<MainEvent>((event, emit) {
      if (event is MainUpdateEvent) {
        _oldDataTry = 0;
        emit.call(
          MainLoadDataState(
            sortIndex: sortIndex!,
            listRegions: _sort(sortIndex!, _getAllRegion(event.alarm.states)),
          ),
        );
      }
      if (event is MainErrorEvent) {
        if (state is MainLoadDataState && _oldDataTry < 3) {
          _oldDataTry++;
          emit.call(state);
        } else {
          emit.call(MainErrorDataState());
        }
      }
      if (event is MainChangeSort) {
        sortIndex = event.sortIndex;
        SheredPreferencesService.preferences.setInt("sort", event.sortIndex);
        if (state is MainLoadDataState) {
          emit.call(
            MainLoadDataState(
              sortIndex: sortIndex!,
              listRegions: _sort(sortIndex!, (state as MainLoadDataState).listRegions),
            ),
          );
        }
      }
    });

    _initTimerData();
    add(MainUpdateEvent(alarm: respose));
  }

  void _initTimerData() async {
    _timer = Timer.periodic(const Duration(seconds: 7), (timer) async {
      try {
        add(MainUpdateEvent(alarm: await _getData()));
      } catch (e) {
        add(MainErrorEvent());
      }
    });
  }

  Future<AlarmRespose> _getData() async {
    try {
      return await Connection.getAlarm();
    } catch (e) {
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
      timeDurationAlarm: _getTimer(region.enabledAt),
      timeDurationCancelAlarm: _getTimer(region.disabledAt),
      timeEnd: _formatData(region.disabledAt),
      timeStart: _formatData(region.enabledAt),
      districts: _getDistrictModel(region.districts),
    );
  }

  List<DistrictModel> _getDistrictModel(List<Districts> districts) {
    List<DistrictModel> result = [];

    for (Districts element in districts) {
      result.add(DistrictModel(
        title: element.title.title,
        isAlarm: element.enabled,
        districts: element.title,
        timeDurationAlarm: _getTimer(element.enabledAt),
        timeDurationCancelAlarm: _getTimer(element.disabledAt),
        timeEnd: _formatData(element.disabledAt),
        timeStart: _formatData(element.enabledAt),
      ));
    }

    return result;
  }

  String? _getTimer(String? alarmTime) {
    if (alarmTime != null) {
      Duration duration = DateTime.now().difference(DateTime.parse(alarmTime).toLocal());

      String day = duration.inDays.toString();
      String hors = (duration.inHours % 24).toString().padLeft(1, '0');
      String min = (duration.inMinutes % 60).toString().padLeft(2, '0');

      if (day == '0') {
        return "$hors:$min";
      } else {
        return "$dayд $hors:$min";
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

  List<RegionModel> _sort(int sortIndex, List<RegionModel> list) {
    List<RegionModel> result = List<RegionModel>.from(list);

    switch (sortIndex) {
      case 0:
        {
          result.sort((a, b) {
            if (a.isAlarm && !b.isAlarm) return -1;
            if (a.isAlarm && b.isAlarm) return 0;
            if (!a.isAlarm && !b.isAlarm) return 0;
            if (!a.isAlarm && b.isAlarm) return 1;
            return 0;
          });
          break;
        }
      case 1:
        {
          result.sort((a, b) {
            if (a.isAlarm && !b.isAlarm) return 1;
            if (a.isAlarm && b.isAlarm) return 0;
            if (!a.isAlarm && !b.isAlarm) return 0;
            if (!a.isAlarm && b.isAlarm) return -1;
            return 0;
          });
          break;
        }
      case 2:
        {
          result.sort((a, b) => a.title.toLowerCase().compareTo(b.title.toLowerCase()));
          break;
        }
      case 3:
        {
          result.sort((a, b) => b.title.toLowerCase().compareTo(a.title.toLowerCase()));
          break;
        }
    }

    return result;
  }

  @override
  Future<void> close() {
    _timer?.cancel();
    return super.close();
  }
}
