import 'eregion.dart';

class RegionTitle {
  static String getRegionByEnum(ERegion region) {
    switch (region) {
      case ERegion.dnepr:
        return "Днепропетровская область";
      case ERegion.lugansk:
        return "Луганская область";
      case ERegion.harkiv:
        return "Харьковская область";
      case ERegion.zapor:
        return "Запорожская область";
      case ERegion.kyiv:
        return "Киевская область";
    }
  }
}
