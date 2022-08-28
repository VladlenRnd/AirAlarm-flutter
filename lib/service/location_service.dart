import 'dart:async';

import 'package:geocoding/geocoding.dart' as geo;

import '../tools/eregion.dart';
import 'shered_preferences_service.dart';

StreamSubscription? sub;

Future<String?> getLocationLocal() async {}

ERegion _getERegionByLocation(String location) {
  switch (location) {
    case "Dnipropetrovs'ka oblast":
      return ERegion.dnipro;
    case "Donets'ka oblast":
      return ERegion.donetsk;
    case "Zaporizhia Oblast":
      return ERegion.zakarpatska;
    case "Odes'ka oblast":
      return ERegion.odesa;
    case "Kyivs'ka oblast":
      return ERegion.kyiv;
    case "Odessa Oblast":
      return ERegion.odesa;
    default:
      return ERegion.krim;
  }
}
