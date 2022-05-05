import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:meta/meta.dart';

import '../../../service/notification_service.dart';
import '../../../service/shered_preferences_service.dart';
import '../../../tools/background_hendler.dart';
import '../../../tools/connection/connection.dart';
import '../../../tools/connection/response/alarm_response.dart';
import '../../../tools/eregion.dart';
import '../../../tools/region_model.dart';
import '../../../tools/region_title.dart';

part 'main_event.dart';
part 'main_state.dart';

class MainBloc extends Bloc<MainEvent, MainState> {
  int oldDataTry = 0;

  MainBloc() : super(MainInitialState()) {
    on<MainEvent>((event, emit) {
      if (event is MainUpdateEvent) {
        oldDataTry = 0;
        emit.call(MainLoadDataState(listRegions: _getListRegion(event.alarm.states), allRegion: _getAllRegion(event.alarm.states)));
      }
      if (event is MainForcedUpdateEvent) {
        _getForceUpdate();
      }
      if (event is MainReorderableEvent) {
        _reorderable(event.oldIndex, event.newIndex);
      }
      if (event is MainErrorEvent) {
        if (state is MainLoadDataState && oldDataTry < 3) {
          oldDataTry++;
          emit.call(state);
        } else {
          emit.call(MainErrorDataState());
        }
      }
    });
    _initTimerData();
    _getForceUpdate();

    FirebaseMessaging.onMessage.listen((RemoteMessage event) async {
      print("==========FOREGROUND MESSAGE============");
      testNotification(event.data);
      NotificationService.showNotification(event.data["isAlarm"].toLowerCase() == 'true', event.data["region"]);
      print("========================================");
    });
  }

  void _getForceUpdate() async {
    try {
      add(MainUpdateEvent(alarm: await _getData()));
    } catch (e) {
      add(MainErrorEvent());
    }
  }

  void _reorderable(int oldIndex, int newIndex) async {
    List<String> strList = SheredPreferencesService.preferences.getStringList("subscribe")!;
    strList.insert(newIndex, strList.removeAt(oldIndex));
    await SheredPreferencesService.preferences.setStringList("subscribe", strList);
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
    ];
  }

  List<RegionModel> _getListRegion(States states) {
    //TODO проверить какие регионы отслеживать Пока все!
    List<RegionModel> result = [];

    for (var subs in SheredPreferencesService.preferences.getStringList("subscribe")!) {
      if (subs == ERegion.dnipro.name) result.add(_getRegionModel(states.dnipro, ERegion.dnipro));
      if (subs == ERegion.harkiv.name) result.add(_getRegionModel(states.harkiv, ERegion.harkiv));
      if (subs == ERegion.kyiv.name) result.add(_getRegionModel(states.kyiv, ERegion.kyiv));
      if (subs == ERegion.lugan.name) result.add(_getRegionModel(states.lugan, ERegion.lugan));
      if (subs == ERegion.zapor.name) result.add(_getRegionModel(states.zapor, ERegion.zapor));
      if (subs == ERegion.donetsk.name) result.add(_getRegionModel(states.donetsk, ERegion.donetsk));
      if (subs == ERegion.jitomer.name) result.add(_getRegionModel(states.jitomer, ERegion.jitomer));
      if (subs == ERegion.zakarpatska.name) result.add(_getRegionModel(states.zakarpatska, ERegion.zakarpatska));
      if (subs == ERegion.ivanoFrankowsk.name) result.add(_getRegionModel(states.ivanoFrankowsk, ERegion.ivanoFrankowsk));
      if (subs == ERegion.kirovograd.name) result.add(_getRegionModel(states.kirovograd, ERegion.kirovograd));
      if (subs == ERegion.lvow.name) result.add(_getRegionModel(states.lvow, ERegion.lvow));
      if (subs == ERegion.mikolaev.name) result.add(_getRegionModel(states.mikolaev, ERegion.mikolaev));
      if (subs == ERegion.odesa.name) result.add(_getRegionModel(states.odesa, ERegion.odesa));
      if (subs == ERegion.rivno.name) result.add(_getRegionModel(states.rivno, ERegion.rivno));
      if (subs == ERegion.sumska.name) result.add(_getRegionModel(states.sumska, ERegion.sumska));
      if (subs == ERegion.ternopil.name) result.add(_getRegionModel(states.ternopil, ERegion.ternopil));
      if (subs == ERegion.herson.name) result.add(_getRegionModel(states.herson, ERegion.herson));
      if (subs == ERegion.hmelnytsk.name) result.add(_getRegionModel(states.hmelnytsk, ERegion.hmelnytsk));
      if (subs == ERegion.cherkasy.name) result.add(_getRegionModel(states.cherkasy, ERegion.cherkasy));
      if (subs == ERegion.chernigev.name) result.add(_getRegionModel(states.chernigev, ERegion.chernigev));
      if (subs == ERegion.chernivets.name) result.add(_getRegionModel(states.chernivets, ERegion.chernivets));
      if (subs == ERegion.vinetsk.name) result.add(_getRegionModel(states.vinetsk, ERegion.vinetsk));
      if (subs == ERegion.volinska.name) result.add(_getRegionModel(states.volinska, ERegion.volinska));
      if (subs == ERegion.poltava.name) result.add(_getRegionModel(states.poltava, ERegion.poltava));
    }

    return result;
  }

  RegionModel _getRegionModel(Region region, ERegion titleRegion) {
    return RegionModel(
      title: RegionTitle.getRegionByEnum(titleRegion),
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

  String? _formatData(String? data) {
    if (data != null) {
      return DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.parse(data).toLocal());
    }
    return null;
  }
}
