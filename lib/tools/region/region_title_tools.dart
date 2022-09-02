import 'eregion.dart';

class RegionTitleTools {
  static ERegion getEnumByEnumName(String enumName) {
    switch (enumName) {
      case "dnipro":
        return ERegion.dnipro;
      case "lugan":
        return ERegion.lugan;
      case "harkiv":
        return ERegion.harkiv;
      case "zapor":
        return ERegion.zapor;
      case "kyiv":
        return ERegion.kyiv;
      case "donetsk":
        return ERegion.donetsk;
      case "jitomer":
        return ERegion.jitomer;
      case "zakarpatska":
        return ERegion.zakarpatska;
      case "ivanoFrankowsk":
        return ERegion.ivanoFrankowsk;
      case "kirovograd":
        return ERegion.kirovograd;
      case "lvow":
        return ERegion.lvow;
      case "mikolaev":
        return ERegion.mikolaev;
      case "odesa":
        return ERegion.odesa;
      case "poltava":
        return ERegion.poltava;
      case "rivno":
        return ERegion.rivno;
      case "sumska":
        return ERegion.sumska;
      case "ternopil":
        return ERegion.ternopil;
      case "herson":
        return ERegion.herson;
      case "hmelnytsk":
        return ERegion.hmelnytsk;
      case "cherkasy":
        return ERegion.cherkasy;
      case "chernigev":
        return ERegion.chernigev;
      case "chernivets":
        return ERegion.chernivets;
      case "vinetsk":
        return ERegion.vinetsk;
      case "volinska":
        return ERegion.volinska;
      case "krim":
        return ERegion.krim;
    }
    throw Exception("No find enum by enumName $enumName");
  }

  static String getRegionByEnumName(String enumName) {
    switch (enumName) {
      case "dnipro":
        return "Днепропетровская область";
      case "lugan":
        return "Луганская область";
      case "harkiv":
        return "Харьковская область";
      case "zapor":
        return "Запорожская область";
      case "kyiv":
        return "Киевская область";
      case "donetsk":
        return "Донецкая область";
      case "jitomer":
        return "Житомерская область";
      case "zakarpatska":
        return "Закарпатская область";
      case "ivanoFrankowsk":
        return "Ивано-Франковская область";
      case "kirovograd":
        return "Кировоградская область";
      case "lvow":
        return "Львовская область";
      case "mikolaev":
        return "Николаевская область";
      case "odesa":
        return "Одесская область";
      case "poltava":
        return "Полтавская область";
      case "rivno":
        return "Ровенская область";
      case "sumska":
        return "Сумская область";
      case "ternopil":
        return "Тернопольская область";
      case "herson":
        return "Херсонская область";
      case "hmelnytsk":
        return "Хмельницкая область";
      case "cherkasy":
        return "Черкасская область";
      case "chernigev":
        return "Черниговская область";
      case "chernivets":
        return "Черновицкая область";
      case "vinetsk":
        return "Винетская область";
      case "volinska":
        return "Волынская  область";
      case "krim":
        return "АР Крым";
      default:
        throw Exception("No find region by EnumName $enumName");
    }
  }
}
