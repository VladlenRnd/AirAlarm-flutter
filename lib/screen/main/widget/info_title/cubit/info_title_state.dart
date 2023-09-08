part of 'info_title_cubit.dart';

sealed class InfoTitleState {}

final class InfoIdle implements InfoTitleState {
  InfoIdle();
}

final class InfoLoad implements InfoTitleState {
  final String loadMessage;
  InfoLoad({required this.loadMessage});
}

final class InfoSuccess implements InfoTitleState {
  final String successMessage;
  InfoSuccess({required this.successMessage});
}

final class InfoError implements InfoTitleState {
  final String errorMessage;
  InfoError({required this.errorMessage});
}

final class InfoMessage implements InfoTitleState {
  final String infoMessage;
  InfoMessage({required this.infoMessage});
}
