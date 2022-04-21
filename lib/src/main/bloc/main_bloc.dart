import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:intl/intl.dart';
import 'package:meta/meta.dart';
import 'dart:async';

import '../../service/shered_preferences.dart';
import '../../tools/alarm_sound.dart';
import '../../tools/connection/connection.dart';
import '../../tools/connection/responce/alarm_responce.dart';
import '../tools/eregion.dart';
import '../tools/region_model.dart';
import '../tools/region_title.dart';

part 'main_event.dart';
part 'main_state.dart';

//TODO Добавить предупреждения о разрыве соеденения

class MainBloc extends Bloc<MainEvent, MainState> {
  late final Timer _timer;

  int oldDataTry = 0;

  MainBloc() : super(MainInitialState()) {
    on<MainEvent>((event, emit) {
      if (event is MainUpdateEvent) {
        oldDataTry = 0;
        emit.call(MainLoadDataState(listRegions: _getListRegion(event.alarm.states)));
      }
      if (event is MainErrorEvent) {
        if (state is MainLoadDataState && oldDataTry < 4) {
          oldDataTry++;
          emit.call(state);
        } else {
          emit.call(MainErrorDataState());
        }
      }
    });

    AlarmSound.init();
    _initAlarmData();
    _initListenUpdate();
  }

  List<RegionModel> _getListRegion(States states) {
    //TODO проверить какие регионы отслеживать Пока все!
    List<RegionModel> result = [];

    result.add(_getRegionModel(states.dnipro, ERegion.dnepr));
    result.add(_getRegionModel(states.harkiv, ERegion.harkiv));
    result.add(_getRegionModel(states.kyiv, ERegion.kyiv));
    result.add(_getRegionModel(states.lugan, ERegion.lugansk));
    result.add(_getRegionModel(states.zapor, ERegion.zapor));

    return result;
  }

  RegionModel _getRegionModel(Region region, ERegion titleRegion) {
    return RegionModel(
      title: RegionTitle.getRegionByEnum(titleRegion),
      isAlarm: region.enabled,
      region: titleRegion,
      timeDuration: _getTimerStarted(region.enabledAt),
      timeEnd: _formatData(region.disabledAt),
      timeStart: _formatData(region.enabledAt),
    );
  }

  String? _getTimerStarted(String? startedAlarmTime) {
    if (startedAlarmTime != null) {
      Duration duration = DateTime.now().difference(DateTime.parse(startedAlarmTime).toLocal());

      String day = duration.inDays.toString();
      String hors = (duration.inHours % 24).toString().padLeft(2, '0');
      String min = (duration.inMinutes % 60).toString().padLeft(2, '0');

      if (day == '0') {
        return "$horsч:$minм";
      } else {
        return "$dayд $horsч:$minм";
      }
    }
    return null;
  }

  void _initAlarmData() async {
    if (SheredPreferencesService.preferences.getBool("backgroundSercive")!) {
      FlutterBackgroundService().invoke("getData");
    } else {
      FlutterBackgroundService().on('serviceReady').listen((event) {
        FlutterBackgroundService().invoke("getData");
      });
    }
  }

  void _initListenUpdate() {
    FlutterBackgroundService().on('update').listen((event) {
      try {
        Alarm alarm = Alarm.fromJson(event!["alarm"]);
        add(MainUpdateEvent(alarm: alarm));
      } catch (e) {
        add(MainErrorEvent());
      }
    });

    FlutterBackgroundService().on('error').listen((event) {
      add(MainErrorEvent());
    });

    // _timer = Timer.periodic(const Duration(seconds: 10), (timer) async {
    //   print("PERIOD UPDATE+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++");
    //   _setEvent();
    // });
  }

  String? _formatData(String? data) {
    if (data != null) {
      return DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.parse(data).toLocal());
    }
    return null;
  }

  Future<Alarm> _getAlarm() async {
    try {
      return await Conectrion.getAlarm();
    } catch (e) {
      throw Exception("Not data Alarm");
    }
  }
}


  // MainLoadDataState _selectRegionData(Alarm alarm) {

  //   // //TODO Добавить выбор области
  //   // if (alarm.states.dnipro.enabled) {
  //   //   AlarmSound.startAlarm();
  //   // } else {
  //   //   AlarmSound.stopAparm();
  //   // }

  //   return
  // }