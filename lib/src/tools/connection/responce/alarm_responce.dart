class Alarm {
  Alarm({
    required this.version,
    required this.states,
  });
  late final int version;
  late final States states;

  Alarm.fromJson(Map<String, dynamic> json) {
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
  States({required this.dnipro});

  late final Region dnipro;
  late final Region zapor;
  late final Region kyiv;
  late final Region lugan;
  late final Region harkiv;

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['Дніпропетровська область'] = dnipro.toJson();
    _data['Запорізька область'] = zapor.toJson();
    _data['Київська область'] = kyiv.toJson();
    _data['Луганська область'] = lugan.toJson();
    _data['Харківська область'] = harkiv.toJson();

    return _data;
  }

  States.fromJson(Map<String, dynamic> json) {
    // Вінницька область = Вінницька область.fromJson(json['Вінницька область']);
    // Волинська область = Волинська область.fromJson(json['Волинська область']);
    dnipro = Region.fromJson(json['Дніпропетровська область']);
    zapor = Region.fromJson(json['Запорізька область']);
    kyiv = Region.fromJson(json['Київська область']);
    lugan = Region.fromJson(json['Луганська область']);
    harkiv = Region.fromJson(json['Харківська область']);
    // Донецька область = Донецька область.fromJson(json['Донецька область']);
    // Житомирська область = Житомирська область.fromJson(json['Житомирська область']);
    // Закарпатська область = Закарпатська область.fromJson(json['Закарпатська область']);
    // Запорізька область = Запорізька область.fromJson(json['Запорізька область']);
    // Івано-Франківська область = Івано-Франківська область.fromJson(json['Івано-Франківська область']);
    // Київська область = Київська область.fromJson(json['Київська область']);
    // Кіровоградська область = Кіровоградська область.fromJson(json['Кіровоградська область']);
    // Луганська область = Луганська область.fromJson(json['Луганська область']);
    // Львівська область = Львівська область.fromJson(json['Львівська область']);
    // Миколаївська область = Миколаївська область.fromJson(json['Миколаївська область']);
    // Одеська область = Одеська область.fromJson(json['Одеська область']);
    // Полтавська область = Полтавська область.fromJson(json['Полтавська область']);
    // Рівненська область = Рівненська область.fromJson(json['Рівненська область']);
    // Сумська область = Сумська область.fromJson(json['Сумська область']);
    // Тернопільська область = Тернопільська область.fromJson(json['Тернопільська область']);
    // Харківська область = Харківська область.fromJson(json['Харківська область']);
    // Херсонська область = Херсонська область.fromJson(json['Херсонська область']);
    // Хмельницька область = Хмельницька область.fromJson(json['Хмельницька область']);
    // Черкаська область = Черкаська область.fromJson(json['Черкаська область']);
    // Чернівецька область = Чернівецька область.fromJson(json['Чернівецька область']);
    // Чернігівська область = Чернігівська область.fromJson(json['Чернігівська область']);
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
