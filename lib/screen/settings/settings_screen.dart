import 'package:alarm/dialog/custom_snack_bar.dart';
import 'package:alarm/service/settings_service.dart';
import 'package:alarm/tools/custom_color.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../dialog/info_dialog.dart';
import '../../dialog/select_dialog.dart';
import '../../models/sound_model.dart';
import '../../service/location_service.dart';
import 'cubit/settings_cubit.dart';

AudioPlayer? _audioPlayer;

class SettingsScreen extends StatelessWidget {
  SettingsScreen({super.key});

  final SettingsCubit _bloc = SettingsCubit();

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.only(top: 55, left: 24, right: 24),
        child: BlocBuilder(
          bloc: _bloc,
          builder: (BuildContext context, SettingsState state) {
            switch (state) {
              case SettingsDataLoad():
                {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text("Настройки", style: TextStyle(fontSize: 21)),
                          Text("Версия ${state.version}", style: TextStyle(fontSize: 13, color: CustomColor.textColor.withValues(alpha: (0.6)))),
                        ],
                      ),
                      const SizedBox(height: 25),
                      _buildSettingWidget(
                        title: "Автоопределение области",
                        selectWidget: _buildCheckBox(
                            onTap: (bool value) async {
                              if (await LocationService.checkPermission()) {
                                if (!await _bloc.setAutoSearch(value)) {
                                  if (context.mounted) CustomSnackBar.error(context, title: "На устройстве выключена геолокация");
                                }
                              } else {
                                if (context.mounted) {
                                  if (await showInfoDialog(context,
                                          title: "Нет доступа к геопозиции!",
                                          contentInfo: "Предоставьте доступ к геопозиции устройства для работы автоопределения области",
                                          actionButtonStr: "Настройки") ??
                                      false) {
                                    LocationService.gotoSettingLocation();
                                  }
                                }
                              }
                            },
                            value: state.autoSearch),
                      ),
                      _buildSettingWidget(
                        title: "Звук уведомления тревоги",
                        selectWidget: _buildSelectedButton(
                            selectValue: state.alarmSoundSelect.name,
                            onTap: () async {
                              _audioPlayer = AudioPlayer();

                              SoundModel? res = await showSelectDialog<SoundModel>(
                                context,
                                title: "Звук уведомления тревоги",
                                selectElement: SoundService.getModelByFileName(SettingsService.alarmSoundFilaName!, SoundService.alarmSounds) ??
                                    SoundService.alarmSounds[0],
                                elementList: SoundService.alarmSounds,
                                widgetElement: _buildSelectSound,
                              );
                              if (res != null) {
                                _bloc.setAlarmSound(res);
                              }

                              await _dospocePlayer();
                            }),
                      ),
                      _buildSettingWidget(
                        title: "Звук уведомления отмены тревоги",
                        selectWidget: _buildSelectedButton(
                            selectValue: state.cancelSoundSelect.name,
                            onTap: () async {
                              _audioPlayer = AudioPlayer();

                              SoundModel? res = await showSelectDialog<SoundModel>(
                                context,
                                title: "Звук уведомления отмены тревоги",
                                selectElement: SoundService.getModelByFileName(SettingsService.cancelSoundFilaName!, SoundService.cancelSounds) ??
                                    SoundService.cancelSounds[0],
                                elementList: SoundService.cancelSounds,
                                widgetElement: _buildSelectSound,
                              );
                              if (res != null) {
                                _bloc.setCancelSound(res);
                              }

                              await _dospocePlayer();
                            }),
                      ),
                      _buildSettingWidget(
                        title: "Режим тишины",
                        selectWidget: _buildSelectedButton(
                            selectValue: state.silenceTime,
                            onTap: () async {
                              if (SettingsService.siledEnd?.isNotEmpty ?? false) {
                                bool? result = await showInfoDialog(
                                  context,
                                  title: "Выключить 'Режим тишины'?",
                                  contentInfo: "",
                                  actionButtonStr: "ДА",
                                  closeButtonStr: "Изменить время",
                                );

                                if (result == null) return;

                                if (result) {
                                  _bloc.removeSilenceTime();
                                  CustomSnackBar.success(
                                    context,
                                    showIsHot: true,
                                    title: "Режим тишины выключен! Теперь вам будут приходить звуковые уведомления",
                                  );

                                  return;
                                }
                              }

                              await _changeSilenceTime(context);
                            }),
                      ),
                    ],
                  );
                }
              case SettingsInitial():
                return _buildLoader();
            }
          },
        ));
  }

  Future<void> _changeSilenceTime(BuildContext context) async {
    TimeOfDay? startTime;
    TimeOfDay? endTime;
    startTime = await showTimePicker(
        context: context,
        initialTime: const TimeOfDay(hour: 0, minute: 0),
        helpText: "Выберите время НАЧАЛО тихого режима",
        hourLabelText: "Часы",
        minuteLabelText: "Минуты",
        initialEntryMode: TimePickerEntryMode.input,
        cancelText: "Закрыть",
        errorInvalidText: "Не правильно выбранно время",
        confirmText: "Сохранить");

    if (startTime != null) {
      endTime = await showTimePicker(
          context: context,
          initialTime: TimeOfDay(hour: startTime.hour == 23 ? 0 : startTime.hour + 1, minute: startTime.minute),
          helpText: "Выберите время КОНЕЦ тихого режима",
          hourLabelText: "Часы",
          minuteLabelText: "Минуты",
          initialEntryMode: TimePickerEntryMode.input,
          cancelText: "Закрыть",
          errorInvalidText: "Не правильно выбранно время",
          confirmText: "Сохранить");
    }

    if (startTime != null && endTime != null) {
      _bloc.setSilenceTime(startTime, endTime);
      CustomSnackBar.success(
        context,
        title: "Вам не будут приходить звуковые уведомления с ${startTime.format(context)} до ${endTime.format(context)}",
        duration: const Duration(seconds: 6),
      );
    }
  }

  //=========== Dialog widget ==============

  Widget _buildSelectSound(SoundModel sm, bool isSelected) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 14),
            child: Row(
              children: [
                isSelected ? const SizedBox(width: 10, child: Icon(Icons.check, color: CustomColor.actionColor)) : const SizedBox(width: 10),
                const SizedBox(width: 20),
                Expanded(
                  child: Text(
                    sm.name,
                    style: const TextStyle(color: CustomColor.textColor),
                  ),
                ),
                const SizedBox(width: 15),
                if (sm.fileName.isNotEmpty)
                  Container(
                    height: 25,
                    width: 25,
                    margin: const EdgeInsets.only(right: 20),
                    child: ElevatedButton(
                      style: ButtonStyle(
                        padding: MaterialStateProperty.all<EdgeInsetsGeometry>(EdgeInsets.zero),
                      ),
                      onPressed: () async {
                        await _audioPlayer?.stop();
                        await _audioPlayer?.play(AssetSource(sm.assetPath), mode: PlayerMode.mediaPlayer, volume: 0.7);
                      },
                      child: const Icon(Icons.play_arrow, color: CustomColor.textColor),
                    ),
                  ),
              ],
            )),
        const Divider(),
      ],
    );
  }

  Future<void> _dospocePlayer() async {
    await _audioPlayer?.stop();
    await _audioPlayer?.dispose();
    _audioPlayer = null;
  }

  Widget _buildLoader() {
    return const Center(
      child: SizedBox(
          height: 60,
          width: 60,
          child: CircularProgressIndicator(
            color: CustomColor.actionColor,
          )),
    );
  }

  Widget _buildCheckBox({required bool value, required Function(bool) onTap}) {
    return Checkbox(
        activeColor: CustomColor.atantion,
        value: value,
        onChanged: (bool? value) {
          onTap.call(value ?? false);
        });
  }

  Widget _buildSelectedButton({required String selectValue, required Function onTap}) {
    return CupertinoButton(
        padding: EdgeInsets.zero,
        child: Row(
          children: [
            Text(selectValue, style: const TextStyle(fontSize: 18, color: CustomColor.textColor, fontWeight: FontWeight.w700)),
            const Icon(Icons.keyboard_arrow_down_sharp, color: CustomColor.textColor),
          ],
        ),
        onPressed: () => onTap.call());
  }

  Widget _buildSettingWidget({required String title, required Widget selectWidget}) {
    return Column(
      children: [
        const Divider(),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 13),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(child: Text(title, style: TextStyle(color: CustomColor.textColor.withValues(alpha: (0.6))))),
              const SizedBox(width: 15),
              selectWidget,
            ],
          ),
        ),
      ],
    );
  }
}
