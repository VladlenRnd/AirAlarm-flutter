import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:meta/meta.dart';
import '../../../tools/connection/connection.dart';
import '../../../tools/connection/response/alarm_response.dart';
import '../../../tools/region/eregion.dart';
import '../../../models/region_model.dart';
import '../../../tools/region/region_title_tools.dart';

part 'main_event.dart';
part 'main_state.dart';

class MainBloc extends Bloc<MainEvent, MainState> {
  int _oldDataTry = 0;

  MainBloc() : super(MainInitialState()) {
    on<MainEvent>((event, emit) {
      if (event is MainUpdateEvent) {
        _oldDataTry = 0;
        emit.call(
          MainLoadDataState(
            listRegions: _getAllRegion(event.alarm.states),
          ),
        );
      }
      if (event is MainForcedUpdateEvent) {
        _getForceUpdate();
      }
      if (event is MainErrorEvent) {
        if (state is MainLoadDataState && _oldDataTry < 3) {
          _oldDataTry++;
          emit.call(state);
        } else {
          emit.call(MainErrorDataState());
        }
      }
    });
    _initTimerData();
    _getForceUpdate();
  }

  void _getForceUpdate() async {
    try {
      add(MainUpdateEvent(alarm: await _getData()));
    } catch (e) {
      add(MainErrorEvent());
    }
  }

  void _initTimerData() async {
    Timer.periodic(const Duration(seconds: 10), (timer) async {
      try {
        add(MainUpdateEvent(alarm: await _getData()));
      } catch (e) {
        add(MainErrorEvent());
      }
    });
  }

  Future<AlarmRespose> _getData() async {
    try {
      return await Conectrion.getAlarm();
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

  RegionModel _getRegionModel(Region region, ERegion titleRegion) {
    return RegionModel(
      title: titleRegion.title,
      isAlarm: region.enabled,
      region: titleRegion,
      timeDurationAlarm: _getTimer(region.enabledAt),
      timeDurationCancelAlarm: _getTimer(region.disabledAt),
      timeEnd: _formatData(region.disabledAt),
      timeStart: _formatData(region.enabledAt),
    );
  }

  String? _getTimer(String? startedAlarmTime) {
    if (startedAlarmTime != null) {
      Duration duration = DateTime.now().difference(DateTime.parse(startedAlarmTime).toLocal());

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
      return DateFormat('dd.MM.yyyy HH:mm:ss').format(DateTime.parse(data).toLocal());
    }
    return null;
  }
}
