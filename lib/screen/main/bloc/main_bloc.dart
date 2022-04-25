import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';
import 'package:meta/meta.dart';

import '../../../service/baground_service.dart';
import '../../../tools/connection/response/alarm_response.dart';
import '../tools/eregion.dart';
import '../tools/region_model.dart';
import '../tools/region_title.dart';

part 'main_event.dart';
part 'main_state.dart';

class MainBloc extends Bloc<MainEvent, MainState> {
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
    _initListenUpdate();
  }

  List<RegionModel> _getListRegion(States states) {
    //TODO проверить какие регионы отслеживать Пока все!
    List<RegionModel> result = [];

    result.add(_getRegionModel(states.dnipro, ERegion.dnipro));
    result.add(_getRegionModel(states.harkiv, ERegion.harkiv));
    result.add(_getRegionModel(states.kyiv, ERegion.kyiv));
    result.add(_getRegionModel(states.lugan, ERegion.lugan));
    result.add(_getRegionModel(states.zapor, ERegion.zapor));

    result.add(_getRegionModel(states.donetsk, ERegion.donetsk));
    result.add(_getRegionModel(states.jitomer, ERegion.jitomer));
    result.add(_getRegionModel(states.zakarpatska, ERegion.zakarpatska));
    result.add(_getRegionModel(states.ivanoFrankowsk, ERegion.ivanoFrankowsk));
    result.add(_getRegionModel(states.kirovograd, ERegion.kirovograd));
    result.add(_getRegionModel(states.lvow, ERegion.lvow));
    result.add(_getRegionModel(states.mikolaev, ERegion.mikolaev));
    result.add(_getRegionModel(states.odesa, ERegion.odesa));
    result.add(_getRegionModel(states.poltava, ERegion.poltava));
    result.add(_getRegionModel(states.rivno, ERegion.rivno));
    result.add(_getRegionModel(states.sumska, ERegion.sumska));
    result.add(_getRegionModel(states.ternopil, ERegion.ternopil));
    result.add(_getRegionModel(states.herson, ERegion.herson));
    result.add(_getRegionModel(states.hmelnytsk, ERegion.hmelnytsk));

    result.add(_getRegionModel(states.cherkasy, ERegion.cherkasy));
    result.add(_getRegionModel(states.chernigev, ERegion.chernigev));
    result.add(_getRegionModel(states.chernivets, ERegion.chernivets));
    result.add(_getRegionModel(states.vinetsk, ERegion.vinetsk));
    result.add(_getRegionModel(states.volinska, ERegion.volinska));

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

  void _initListenUpdate() {
    BackgroundService.on('update').listen((event) {
      try {
        AlarmRespose alarm = AlarmRespose.fromJson(event!["alarm"]);
        add(MainUpdateEvent(alarm: alarm));
      } catch (e) {
        add(MainErrorEvent());
      }
    });

    BackgroundService.on('error').listen((event) {
      add(MainErrorEvent());
    });

    _initAlarmData();
  }

  void _initAlarmData() async {
    BackgroundService.invoke("getData");
    BackgroundService.on('serviceReady').listen((event) {
      BackgroundService.invoke("getData");
    });
  }

  String? _formatData(String? data) {
    if (data != null) {
      return DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.parse(data).toLocal());
    }
    return null;
  }
}
