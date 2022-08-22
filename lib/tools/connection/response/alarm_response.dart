class AlarmRespose {
  AlarmRespose({
    required this.version,
    required this.states,
  });
  late final int version;
  late final States states;

  AlarmRespose.fromJson(Map<String, dynamic> json) {
    version = json['version'];
    states = States.fromJson(json['states']);
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['version'] = version;
    _data['states'] = states.toJson();
    return _data;
  }
}

class States {
  States(
      {required this.dnipro,
      required this.zapor,
      required this.kyiv,
      required this.lugan,
      required this.harkiv,
      required this.donetsk,
      required this.jitomer,
      required this.zakarpatska,
      required this.ivanoFrankowsk,
      required this.kirovograd,
      required this.lvow,
      required this.mikolaev,
      required this.odesa,
      required this.poltava,
      required this.rivno,
      required this.sumska,
      required this.ternopil,
      required this.herson,
      required this.hmelnytsk,
      required this.cherkasy,
      required this.chernigev,
      required this.chernivets,
      required this.vinetsk,
      required this.volinska,
      required this.krim});

  final Region dnipro;
  final Region zapor;
  final Region kyiv;
  final Region lugan;
  final Region harkiv;
  final Region donetsk;
  final Region jitomer;
  final Region zakarpatska;
  final Region ivanoFrankowsk;
  final Region kirovograd;
  final Region lvow;
  final Region mikolaev;
  final Region odesa;
  final Region poltava;
  final Region rivno;
  final Region sumska;
  final Region ternopil;
  final Region herson;
  final Region hmelnytsk;
  final Region cherkasy;
  final Region chernigev;
  final Region chernivets;
  final Region vinetsk;
  final Region volinska;
  final Region krim;

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['Дніпропетровська область'] = dnipro.toJson();
    _data['Запорізька область'] = zapor.toJson();
    _data['Київська область'] = kyiv.toJson();
    _data['Луганська область'] = lugan.toJson();
    _data['Харківська область'] = harkiv.toJson();
    _data['Донецька область'] = donetsk.toJson();
    _data['Житомирська область'] = jitomer.toJson();
    _data['Закарпатська область'] = zakarpatska.toJson();
    _data['Івано-Франківська облать'] = ivanoFrankowsk.toJson();
    _data['Кіровоградська область'] = kirovograd.toJson();
    _data['Львівська область'] = lvow.toJson();
    _data['Миколаївська область'] = mikolaev.toJson();
    _data['Одеська область'] = odesa.toJson();
    _data['Полтавська область'] = poltava.toJson();
    _data['Рівненська область'] = rivno.toJson();
    _data['Сумська область'] = sumska.toJson();
    _data['Тернопільська область'] = ternopil.toJson();
    _data['Херсонська область'] = herson.toJson();
    _data['Хмельницька область'] = hmelnytsk.toJson();
    _data['Черкаська область'] = cherkasy.toJson();
    _data['Чернівецька область'] = chernigev.toJson();
    _data['Чернігівська область'] = chernigev.toJson();
    _data['Вінницька область'] = vinetsk.toJson();
    _data['Волинська область'] = volinska.toJson();
    _data['АР Крим'] = krim.toJson();

    return _data;
  }

  factory States.fromJson(Map<String, dynamic> json) {
    return States(
      dnipro: Region.fromJson(json['Дніпропетровська область']),
      zapor: Region.fromJson(json['Запорізька область']),
      kyiv: Region.fromJson(json['Київська область']),
      lugan: Region.fromJson(json['Луганська область']),
      harkiv: Region.fromJson(json['Харківська область']),
      donetsk: Region.fromJson(json['Донецька область']),
      jitomer: Region.fromJson(json['Житомирська область']),
      zakarpatska: Region.fromJson(json['Закарпатська область']),
      ivanoFrankowsk: Region.fromJson(json['Івано-Франківська область'] ?? json['Івано-Франківська облать']),
      kirovograd: Region.fromJson(json['Кіровоградська область']),
      lvow: Region.fromJson(json['Львівська область']),
      mikolaev: Region.fromJson(json['Миколаївська область']),
      odesa: Region.fromJson(json['Одеська область']),
      poltava: Region.fromJson(json['Полтавська область']),
      rivno: Region.fromJson(json['Рівненська область']),
      sumska: Region.fromJson(json['Сумська область']),
      ternopil: Region.fromJson(json['Тернопільська область']),
      herson: Region.fromJson(json['Херсонська область']),
      hmelnytsk: Region.fromJson(json['Хмельницька область']),
      cherkasy: Region.fromJson(json['Черкаська область']),
      chernivets: Region.fromJson(json['Чернівецька область']),
      chernigev: Region.fromJson(json['Чернігівська область']),
      vinetsk: Region.fromJson(json['Вінницька область']),
      volinska: Region.fromJson(json['Волинська область']),
      krim: Region.fromJson(json['АР Крим']),
    );

    // Волинська область = Волинська область.fromJson(json['Волинська область']);
    // м. Київ = м. Київ.fromJson(json['м. Київ']);
  }
}

// class Districts {
//   Districts({
//     required this.Вінницький район,
//     required this.Могилів-Подільський район,
//     required this.Жмеринський район,
//     required this.Гайсинський район,
//     required this.Тульчинський район,
//     required this.Хмільницький район,
//   });
//   late final вінницький район Вінницький район;
//   late final могилів-Подільський район Могилів-Подільський район;
//   late final жмеринський район Жмеринський район;
//   late final гайсинський район Гайсинський район;
//   late final тульчинський район Тульчинський район;
//   late final хмільницький район Хмільницький район;

//   Districts.fromJson(Map<String, dynamic> json){
//     Вінницький район = Вінницький район.fromJson(json['Вінницький район']);
//     Могилів-Подільський район = Могилів-Подільський район.fromJson(json['Могилів-Подільський район']);
//     Жмеринський район = Жмеринський район.fromJson(json['Жмеринський район']);
//     Гайсинський район = Гайсинський район.fromJson(json['Гайсинський район']);
//     Тульчинський район = Тульчинський район.fromJson(json['Тульчинський район']);
//     Хмільницький район = Хмільницький район.fromJson(json['Хмільницький район']);
//   }

//   Map<String, dynamic> toJson() {
//     final _data = <String, dynamic>{};
//     _data['Вінницький район'] = Вінницький район.toJson();
//     _data['Могилів-Подільський район'] = Могилів-Подільський район.toJson();
//     _data['Жмеринський район'] = Жмеринський район.toJson();
//     _data['Гайсинський район'] = Гайсинський район.toJson();
//     _data['Тульчинський район'] = Тульчинський район.toJson();
//     _data['Хмільницький район'] = Хмільницький район.toJson();
//     return _data;
//   }
// }

class Region {
  Region({
    required this.enabled,
    required this.type,
    // required this.districts,
    required this.enabledAt,
    required this.disabledAt,
  });
  late final bool enabled;
  late final String type;
  // late final Districts districts;
  late final String? enabledAt;
  late final String? disabledAt;

  Region.fromJson(Map<String, dynamic> json) {
    enabled = json['enabled'];
    type = json['type:'];
    //districts = Districts.fromJson(json['districts']);
    enabledAt = json['enabled_at'];
    disabledAt = json['disabled_at'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['enabled'] = enabled;
    _data['type:'] = type;
    // _data['districts'] = districts.toJson();
    _data['enabled_at'] = enabledAt;
    _data['disabled_at'] = disabledAt;
    return _data;
  }
}
