import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../tools/history.dart';

part 'info_title_state.dart';

class InfoTitleCubit extends Cubit<InfoTitleState> {
  InfoTitleCubit() : super(InfoIdle()) {
    loadHistory();
  }

  void loadHistory() async {
    await Future.delayed(const Duration(seconds: 2));
    emit(InfoLoad(loadMessage: "Загрузка истории"));
    if (await getAllHistory()) {
      emit(InfoSuccess(successMessage: "Загрузка завершена"));
    } else {
      emit(InfoError(errorMessage: "Ошибка загрузки истории"));
    }
    await Future.delayed(const Duration(seconds: 2));
    emit(InfoIdle());
  }
}
