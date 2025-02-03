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

  static ERegion? getERegionByUkrString(String str) {
    switch (str) {
      case 'Дніпропетровська область':
        return ERegion.dnipro;
      case 'Запорізька область':
        return ERegion.zapor;
      case 'Київська область':
        return ERegion.kyiv;
      case 'Луганська область':
        return ERegion.lugan;
      case 'Харківська область':
        return ERegion.harkiv;
      case 'Донецька область':
        return ERegion.donetsk;
      case 'Житомирська область':
        return ERegion.jitomer;
      case 'Закарпатська область':
        return ERegion.zakarpatska;
      case 'Кіровоградська область':
        return ERegion.kirovograd;
      case 'Львівська область':
        return ERegion.lvow;
      case 'Миколаївська область':
        return ERegion.mikolaev;
      case 'Одеська область':
        return ERegion.odesa;
      case 'Полтавська область':
        return ERegion.poltava;
      case 'Рівненська область':
        return ERegion.rivno;
      case 'Сумська область':
        return ERegion.sumska;
      case 'Тернопільська область':
        return ERegion.ternopil;
      case 'Херсонська область':
        return ERegion.herson;
      case 'Хмельницька область':
        return ERegion.hmelnytsk;
      case 'Черкаська область':
        return ERegion.cherkasy;
      case 'Чернівецька область':
        return ERegion.chernivets;
      case 'Чернігівська область':
        return ERegion.chernigev;
      case 'Вінницька область':
        return ERegion.vinetsk;
      case 'Волинська область':
        return ERegion.volinska;
      case 'АР Крим':
        return ERegion.krim;
      case 'Івано-Франківська область':
        return ERegion.ivanoFrankowsk;
      case 'Івано-Франківська облать':
        return ERegion.ivanoFrankowsk;
    }
    return null;
  }

  static ERegion? getRegionByGeolocation(String address, String locality) {
    String findBy = address.isNotEmpty ? address : locality;

    switch (findBy) {
      case "Luhans'ka oblast":
      case "Luhansk Oblast":
      case "Луганск":
      case "Луганськ":
        return ERegion.lugan;

      case "Donets'ka oblast":
      case "Donetsk Oblast":
      case "Донецьк":
      case "Донецк":
        return ERegion.donetsk;

      case "Kharkivs'ka oblast":
      case "Kharkiv oblast":
        return ERegion.harkiv;

      case "Dnipropetrovs'ka oblast":
      case "Dnipropetrovsk Oblast":
        return ERegion.dnipro;

      case "Zaporiz'ka oblast":
      case "Zaporizhia Oblast":
        return ERegion.zapor;

      case "Sums'ka oblast":
      case "Sumy oblast":
        return ERegion.sumska;

      case "Poltavs'ka oblast":
      case "Poltava oblast":
        return ERegion.poltava;

      case "Khersons'ka oblast":
      case "Kherson oblast":
        return ERegion.herson;

      case "Chernihivs'ka oblast":
      case "Chernihiv oblast":
        return ERegion.chernigev;

      case "Kyivs'ka oblast":
      case "Kyiv Oblast":
      case "Kyiv":
      case "Киев":
        return ERegion.kyiv;

      case "Cherkas'ka oblast":
      case "Cherkasy Oblast":
        return ERegion.cherkasy;

      case "Kirovohrads'ka oblast":
      case "Kirovohrad Oblast":
        return ERegion.kirovograd;

      case "Mykolaivs'ka oblast":
      case "Mykolaiv oblast":
        return ERegion.mikolaev;

      case "Zhytomyrs'ka oblast":
      case "Zhytomyr oblast":
        return ERegion.jitomer;

      case "Vinnyts'ka oblast":
      case "Vinnytsia Oblast":
        return ERegion.vinetsk;

      case "Odes'ka oblast":
      case "Odesa Oblast":
        return ERegion.odesa;

      case "Rivnens'ka oblast":
      case "Rivne Oblast":
        return ERegion.rivno;

      case "Khmel'nyts'ka oblast":
      case "Khmelnytskyi Oblast":
        return ERegion.hmelnytsk;

      case "Ternopil's'ka oblast":
      case "Ternopil Oblast":
        return ERegion.ternopil;

      case "Ivano-Frankivs'ka oblast":
      case "Ivano-Frankivsk Oblast":
        return ERegion.ivanoFrankowsk;

      case "Chernivets'ka oblast":
      case "Chernivtsi Oblast":
        return ERegion.chernivets;

      case "Zakarpattia Oblast":
      case "Zakarpats'ka oblast":
        return ERegion.zakarpatska;

      case "Lviv Oblast":
      case "L'vivs'ka oblast":
        return ERegion.lvow;

      case "Volyns'ka oblast":
      case "Volyn Oblast":
        return ERegion.volinska;

      default:
        return null;
    }
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
        return "Житомирская область";
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
        return "Винницкая область";
      case "volinska":
        return "Волынская  область";
      case "krim":
        return "АР Крым";
      default:
        throw Exception("No find region by EnumName $enumName");
    }
  }
}
