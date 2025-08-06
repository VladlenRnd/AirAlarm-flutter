import 'dart:ui';

import 'package:alarm/tools/custom_color.dart';
import 'package:collection/collection.dart';
import 'package:equatable/equatable.dart';

import '../tools/ui_tools.dart';

class RegionModel extends Equatable {
  final int? id;
  final bool isAlert;
  final bool isAlertDistrict;
  final String? title;
  final ELocationType? locationType;

  final DateTime? startedAt;
  final String? startedAtEstimate;

  final DateTime? finishedAt;
  final String? finishedAtEstimate;

  final DateTime? updatedAt;
  final EAlertType? alertType;
  final String? uid;
  final String? locationOblast;
  final int? locationOblastUid;
  final String? locationRaion;
  final String? notes;
  final bool? calculated;
  final List<RegionModel>? listDistrict;

  RegionModel copyWith({
    bool? isAlert,
    EAlertType? alertType,
    bool? calculated,
    DateTime? startedAt,
    String? startedAtEstimate,
    DateTime? finishedAt,
    String? finishedAtEstimate,
    String? locationOblast,
    int? locationOblastUid,
    String? locationRaion,
    //String? title,
    ELocationType? locationType,
    String? uid,
    String? notes,
    DateTime? updatedAt,
    List<RegionModel>? listDistrict,
  }) {
    return RegionModel(
      isAlert: isAlert ?? false,
      alertType: alertType,
      calculated: calculated,
      finishedAt: finishedAt,
      id: id,
      listDistrict: listDistrict ?? this.listDistrict,
      locationOblast: locationOblast,
      locationOblastUid: locationOblastUid,
      locationRaion: locationRaion,
      title: title,
      locationType: locationType ?? this.locationType,
      uid: uid ?? this.uid,
      notes: notes,
      startedAt: startedAt,
      updatedAt: updatedAt,
    );
  }

  RegionModel({
    required this.isAlert,
    this.id,
    this.title,
    this.locationType,
    this.startedAt,
    this.finishedAt,
    this.updatedAt,
    this.alertType,
    this.uid,
    this.locationOblast,
    this.locationOblastUid,
    this.locationRaion,
    this.notes,
    this.calculated,
    this.listDistrict,
  })  : finishedAtEstimate = UiTools.getElapsedTimeFormatted(finishedAt),
        startedAtEstimate = UiTools.getElapsedTimeFormatted(startedAt),
        isAlertDistrict = listDistrict?.firstWhereOrNull((e) => e.isAlert) != null;

  factory RegionModel.fromJson(Map<String, dynamic> json) {
    return RegionModel(
      isAlert: json["isAlert"] as bool? ?? false,
      uid: json['uid'] as String?,
      id: json['id'] as int?,
      title: json['locationTitle'] as String?,
      locationType: ELocationType.getEnumByType(type: json['locationType']),
      startedAt: json['startedAt'] != null ? DateTime.tryParse(json['startedAt'])?.toLocal() : null,
      finishedAt: json['finishedAt'] != null ? DateTime.tryParse(json['finishedAt'])?.toLocal() : null,
      updatedAt: json['updatedAt'] != null ? DateTime.tryParse(json['updatedAt'])?.toLocal() : null,
      alertType: EAlertType.getEnumByType(type: json['alertType']),
      locationOblast: json['locationOblast'] as String?,
      locationOblastUid: json['locationOblastUid'] as int?,
      locationRaion: json['locationRaion'] as String?,
      notes: json['notes'] as String?,
      calculated: json['calculated'] as bool?,
      listDistrict:
          json['listDistrict'] != null ? (json['listDistrict'] as List).map((e) => RegionModel.fromJson(e as Map<String, dynamic>)).toList() : null,
    );
  }

  @override
  List<Object?> get props => [
        isAlert,
        id,
        title,
        locationType,
        startedAt,
        startedAtEstimate,
        finishedAt,
        finishedAtEstimate,
        updatedAt,
        alertType,
        uid,
        locationOblast,
        locationOblastUid,
        locationRaion,
        notes,
        calculated,
        listDistrict,
      ];
}

enum ELocationType {
  oblast,
  raion,
  city,
  hromada,
  unknown;

  static ELocationType getEnumByType({required String? type}) {
    switch (type) {
      case "oblast":
        return ELocationType.oblast;
      case "raion":
        return ELocationType.raion;
      case "city":
        return ELocationType.city;
      case "hromada":
        return ELocationType.hromada;
      case "unknown":
        return ELocationType.unknown;
      default:
        return ELocationType.unknown;
    }
  }
}

enum EAlertType {
  airRaid("Авиационная\nтревога", "assets/icons/air_raid.svg", CustomColor.airAlert),
  artilleryShelling("Артиллерийский\nобстрел", "assets/icons/artillery_shelling.svg", CustomColor.artilleryShelling),
  urbanFights("Бои в городе", "assets/icons/urban_fights.svg", CustomColor.urbanFights),
  chemical("Химическая\nугроза", "assets/icons/chemical.svg", CustomColor.chemical),
  nuclea("Ядерная\nугроза", "assets/icons/nuclear.svg", CustomColor.nuclear),
  unknown("", "", CustomColor.airAlert);

  const EAlertType(this.title, this.svgPath, this.colorAlert);

  final String title;
  final String svgPath;
  final Color colorAlert;

  static EAlertType getEnumByType({required String? type}) {
    switch (type) {
      case "airRaid":
        return EAlertType.airRaid;
      case "artilleryShelling":
        return EAlertType.artilleryShelling;
      case "urbanFights":
        return EAlertType.urbanFights;
      case "chemical":
        return EAlertType.chemical;
      case "nuclear":
        return EAlertType.nuclea;
      default:
        return EAlertType.unknown;
    }
  }
}
