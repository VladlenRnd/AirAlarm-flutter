import 'package:alarm/dialog/custom_snack_bar.dart';
import 'package:alarm/service/settings_service.dart';
import 'package:alarm/tools/custom_color.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:collection/collection.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../dialog/info_dialog.dart';
import '../../dialog/select_dialog.dart';
import '../../models/alert_setting_model.dart';
import '../../models/sound_model.dart';
import '../../tools/connection/connection.dart';
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
              case SettingsDataLoaded():
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
                      Expanded(
                        child: ReorderableListView.builder(
                          padding: const EdgeInsets.only(bottom: 30),
                          itemCount: state.subscribeList.length,
                          buildDefaultDragHandles: false,
                          onReorderItem: (oldIndex, newIndex) async {
                            if (state.subscribeList.length <= 1) return;
                            final newList = [...state.subscribeList];
                            final item = newList.removeAt(oldIndex);
                            newList.insert(newIndex, item);
                            await _bloc.setNewPosition(newPosition: newList);
                          },
                          itemBuilder: (context, index) {
                            final sub = state.subscribeList[index];
                            final card = _buildSubCard(context, sub: sub, isDrag: state.subscribeList.length > 1);

                            return KeyedSubtree(
                              key: ValueKey(sub.regionUID),
                              child: state.subscribeList.length > 1 ? ReorderableDragStartListener(index: index, child: card) : card,
                            );
                          },
                        ),
                      )
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
                    height: 30,
                    width: 30,
                    margin: const EdgeInsets.only(right: 20),
                    child: ElevatedButton(
                      style: ButtonStyle(
                        padding: WidgetStateProperty.all<EdgeInsetsGeometry>(EdgeInsets.zero),
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

  Widget _buildSelectedButton({required String selectValue, required Function onTap}) {
    return CupertinoButton(
        padding: EdgeInsets.zero,
        child: Row(
          children: [
            Text(selectValue, style: const TextStyle(fontSize: 14, color: CustomColor.textColor, fontWeight: FontWeight.w700)),
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

  Widget _buildSoundSection(
    BuildContext context, {
    required String title,
    required IconData icon,
    required String value,
    required VoidCallback onTap,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(
              icon,
              size: 17,
              color: Colors.grey,
            ),
            const SizedBox(width: 5),
            Text(
              title,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Colors.grey,
                  ),
            ),
          ],
        ),
        const SizedBox(height: 7),
        InkWell(
          borderRadius: BorderRadius.circular(10),
          onTap: onTap,
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 10,
            ),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Colors.white.withValues(alpha: 0.04),
              border: Border.all(
                color: Colors.white.withValues(alpha: 0.06),
              ),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    value,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ),
                const SizedBox(width: 4),
                const Icon(
                  Icons.keyboard_arrow_down_rounded,
                  size: 20,
                  color: Colors.grey,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSubCard(BuildContext context, {required SubscribeAlertModel sub, bool isDrag = true}) {
    final alarmSound = SoundService.getModelByFileName(
          sub.alarmSoundFilaName,
          SoundService.alarmSounds,
        ) ??
        SoundService.alarmSounds.first;

    final cancelSound = SoundService.getModelByFileName(
          sub.cancelSoundFilaName,
          SoundService.cancelSounds,
        ) ??
        SoundService.cancelSounds.first;

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 6),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: CustomColor.backgroundCard,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.06),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      Connection.lastUpdateRegion
                              .expand((region) => region.listDistrict ?? [])
                              .firstWhereOrNull((e) => e.uid == sub.regionUID)
                              ?.title ??
                          "",
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      "Настройки уведомлений",
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: Colors.grey,
                          ),
                    ),
                  ],
                ),
              ),
              CupertinoButton(
                padding: const EdgeInsets.all(8),
                onPressed: () {
                  _bloc.setMuteMode(uid: sub.regionUID, isMuted: !sub.isMuted);
                },
                minimumSize: Size(0, 0),
                child: Icon(
                  sub.isMuted ? Icons.notifications_off_rounded : Icons.notifications_active_rounded,
                  color: sub.isMuted ? Colors.grey : CustomColor.atantion,
                  size: 25,
                ),
              ),
              if (isDrag) ...[
                const SizedBox(width: 4),
                const Icon(
                  Icons.drag_indicator_rounded,
                  color: Colors.grey,
                  size: 25,
                ),
              ]
            ],
          ),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 12),
            child: Divider(height: 1),
          ),
          Row(
            children: [
              Expanded(
                child: _buildSoundSection(
                  context,
                  title: "Звук тревоги",
                  icon: Icons.warning_amber_rounded,
                  value: alarmSound.name,
                  onTap: () async {
                    _audioPlayer = AudioPlayer();

                    final res = await showSelectDialog<SoundModel>(
                      context,
                      title: "Звук тревоги",
                      selectElement: alarmSound,
                      elementList: SoundService.alarmSounds,
                      widgetElement: _buildSelectSound,
                    );

                    if (res != null) {
                      _bloc.setAlarmSound(uid: sub.regionUID, sound: res);
                    }

                    await _dospocePlayer();
                  },
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildSoundSection(
                  context,
                  title: "Звук отмены",
                  icon: Icons.check_circle_outline_rounded,
                  value: cancelSound.name,
                  onTap: () async {
                    _audioPlayer = AudioPlayer();

                    final res = await showSelectDialog<SoundModel>(
                      context,
                      title: "Звук отмены тревоги",
                      selectElement: cancelSound,
                      elementList: SoundService.cancelSounds,
                      widgetElement: _buildSelectSound,
                    );

                    if (res != null) {
                      _bloc.setCancelSound(uid: sub.regionUID, sound: res);
                    }

                    await _dospocePlayer();
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
