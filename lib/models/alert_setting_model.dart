import 'package:alarm/models/sound_model.dart';
import 'package:equatable/equatable.dart';

class SubscribeAlertModel extends Equatable {
  final String regionUID;
  final bool isMuted;
  final String alarmSoundFilaName;
  final String cancelSoundFilaName;

  const SubscribeAlertModel({required this.regionUID, required this.alarmSoundFilaName, required this.cancelSoundFilaName, required this.isMuted});

  factory SubscribeAlertModel.create({required String regionUID}) {
    return SubscribeAlertModel(
      regionUID: regionUID,
      isMuted: false,
      alarmSoundFilaName: SoundService.alarmSounds[1].fileName,
      cancelSoundFilaName: SoundService.cancelSounds[1].fileName,
    );
  }

  SubscribeAlertModel copyWith({String? regionUID, String? alarmSoundFilaName, String? cancelSoundFilaName, bool? isMuted}) {
    return SubscribeAlertModel(
      regionUID: regionUID ?? this.regionUID,
      alarmSoundFilaName: alarmSoundFilaName ?? this.alarmSoundFilaName,
      cancelSoundFilaName: cancelSoundFilaName ?? this.cancelSoundFilaName,
      isMuted: isMuted ?? this.isMuted,
    );
  }

  factory SubscribeAlertModel.fromJson(Map<String, dynamic> json) {
    return SubscribeAlertModel(
      regionUID: json['regionUID'] as String,
      alarmSoundFilaName: json['alarmSoundFilaName'] as String,
      cancelSoundFilaName: json['cancelSoundFilaName'] as String,
      isMuted: json['isMuted'] as bool,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'regionUID': regionUID,
      'alarmSoundFilaName': alarmSoundFilaName,
      'cancelSoundFilaName': cancelSoundFilaName,
      'isMuted': isMuted,
    };
  }

  @override
  List<Object?> get props => [regionUID, alarmSoundFilaName, cancelSoundFilaName, isMuted];
}
