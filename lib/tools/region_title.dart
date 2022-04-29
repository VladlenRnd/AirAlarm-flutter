import 'eregion.dart';

class RegionTitle {
  static String getRegionByEnum(ERegion region) {
    switch (region) {
      case ERegion.dnipro:
        return "Днепропетровская область";
      case ERegion.lugan:
        return "Луганская область";
      case ERegion.harkiv:
        return "Харьковская область";
      case ERegion.zapor:
        return "Запорожская область";
      case ERegion.kyiv:
        return "Киевская область";
      case ERegion.donetsk:
        return "Донецкая область";
      case ERegion.jitomer:
        return "Житомерская область";
      case ERegion.zakarpatska:
        return "Закарпатская область";
      case ERegion.ivanoFrankowsk:
        return "Ивано-Франковская область";
      case ERegion.kirovograd:
        return "Кировоградская область";
      case ERegion.lvow:
        return "Львовская область";
      case ERegion.mikolaev:
        return "Николаевская область";
      case ERegion.odesa:
        return "Одесская область";
      case ERegion.poltava:
        return "Полтавская область";
      case ERegion.rivno:
        return "Ровенская область";
      case ERegion.sumska:
        return "Сумская область";
      case ERegion.ternopil:
        return "Тернопольская область";
      case ERegion.herson:
        return "Херсонская область";
      case ERegion.hmelnytsk:
        return "Хмельницкая область";
      case ERegion.cherkasy:
        return "Черкасская область";
      case ERegion.chernigev:
        return "Черниговская область";
      case ERegion.chernivets:
        return "Черновицкая область";
      case ERegion.vinetsk:
        return "Винетская область";
      case ERegion.volinska:
        return "Волынская  область";
    }
  }
}
