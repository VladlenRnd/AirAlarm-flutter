import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logger/logger.dart';

import '../../../models/region_model.dart';
import '../../../tools/connection/connection.dart';

part 'alert_state.dart';

class AlertCubit extends Cubit<AlertState> {
  List<RegionModel> _globalAlert = [];
  Timer? _timer;

  AlertCubit() : super(AlertLoadingState()) {
    updateData();

    _timer = Timer.periodic(
      Duration(seconds: 3),
      (timer) => updateData(),
    );
  }

  Future<void> updateData() async {
    if (isClosed) {
      _timer?.cancel();
      return;
    }

    try {
      _globalAlert = await Connection.getAllAlert();
      emit(AlertLoadedDataState(regionList: _globalAlert));
    } catch (e) {
      Logger().e("Error get alert:", error: e);
      emit(AlertErrorDataState());
    }
  }

  @override
  Future<void> close() {
    _timer?.cancel();
    return super.close();
  }
}
