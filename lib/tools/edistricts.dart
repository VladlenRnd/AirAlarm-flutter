enum EDistricts {
  vinnetskij("Винницкий район"),
  gajsinskij("Гайсинский район"),
  zhmerinskij("Жмеринский район"),
  mogilyovPodolskij("Могилёв-подольский район"),
  tulchinskij("Тульчинский район"),
  vladimirskij("Владимир-Волынский район"),
  kamenKashirskij("Камень-каширский район"),
  kovelskij("Ковельский район"),
  luckij("Луцкий район"),
  dneprovskij("Днепровский район"),
  kamenskij("Каменский район"),
  krivorozhskij("Криворожский район"),
  nikopolskij("Никопольский район"),
  novomoskovskij("Новомосковский район"),
  pavlogradskij("Павлоградский район"),
  sinelnikovskij("Синельниковский район"),
  bahmutskij("Бахмутский район"),
  volnovahskij("Волновахский район"),
  gorlovskij("Горловский район"),
  doneckij("Донецкий район"),
  kalmiusskij("Кальмиусский район"),
  kramatorskij("Краматорский район"),
  mariupolskij("Мариупольский район"),
  pokrovskij("Покровский район"),
  berdichevskij("Бердичевский район"),
  zhitomirskij("Житомирский район"),
  korostenskij("Коростенский район"),
  novogradVolynskij("Новоград-волынский район"),
  beregovskij("Береговский район"),
  mukachevskij("Мукачевский район"),
  rahovskij("Раховский район"),
  tyachevskij("Тячевский район"),
  uzhgorodskij("Ужгородский район"),
  hustskij("Хустский район"),
  berdyanskij("Бердянский район"),
  vasilevskij("Васильевский район"),
  zaporozhskij("Запорожский район"),
  melitopolskij("Мелитопольский район"),
  pologovskij("Пологовский район"),
  verhovinskij("Верховинский район"),
  ivanoFrankovskij("Ивано-франковский район"),
  kalushskij("Калушский район"),
  kolomyjskij("Коломыйский район"),
  kosovskij("Косовский район"),
  nadvornyanskij("Надворнянский район"),
  belocerkovskij("Белоцерковский район"),
  borispolskij("Бориспольский район"),
  brovarskij("Броварский район"),
  buchanskij("Бучанский район"),
  vyshgorodskij("Вышгородский район"),
  obuhovskij("Обуховский район"),
  fastovskij("Фастовский район"),
  golovanevskij("Голованевский район"),
  kropivnickij("Кропивницкий район"),
  novoukrainskij("Новоукраинский район"),
  aleksandrijskij("Александрийский район"),
  luganskij("Луганский район"),
  rovenkovskij("Ровеньковский район"),
  svatovskij("Сватовский район"),
  severodoneckij("Северодонецкий район"),
  starobelskij("Старобельский район"),
  schastinskij("Счастьинский район"),
  drogobychskij("Дрогобычский район"),
  lvovskij("Львовский район"),
  samborskij("Самборский район"),
  stryjskij("Стрыйский район"),
  chervonogradskij("Червоноградский район"),
  yavorovskij("Яворовский район"),
  bashtanskij("Баштанский район"),
  voznesenskij("Вознесенский район"),
  nikolaevskij("Николаевский район"),
  pervomajskij("Первомайский район"),
  berezovskij("Березовский район"),
  belgorodDnestrovskij("Белгород-днестровский район"),
  bolgradskij("Болградский район"),
  izmailskij("Измаильский район"),
  odesskij("Одесский район"),
  podolskij("Подольский район"),
  razdelnyanskij("Раздельнянский район"),
  kremenchugskij("Кременчугский район"),
  lubenskij("Лубенский район"),
  mirgorodskij("Миргородский район"),
  poltavskij("Полтавский район"),
  varashskij("Варашский район"),
  dubenskij("Дубенский район"),
  sarnenskij("Сарненский район"),
  ahtyrskij("Ахтырский район"),
  romenskij("Роменский район"),
  sumskij("Сумский район"),
  shostkinskij("Шосткинский район"),
  kremeneckij("Кременецкий район"),
  ternopolskij("Тернопольский район"),
  chortkovskij("Чортковский район"),
  bogoduhovskij("Богодуховский район"),
  izyumskij("Изюмский район"),
  krasnogradskij("Красноградский район"),
  kupyanskij("Купянский район"),
  lozovskij("Лозовский район"),
  harkovskij("Харьковский район"),
  chuguevskij("Чугуевский район"),
  berislavskij("Бериславский район"),
  genicheskij("Генический район"),
  kahovskij("Каховский район"),
  skadovskij("Скадовский район"),
  hersonskij("Херсонский район"),
  kamenecPodolskij("Каменец-подольский район"),
  hmelnickij("Хмельницкий район"),
  shepetovskij("Шепетовский район"),
  zvenigorodskij("Звенигородский район"),
  zolotonoshskij("Золотоношский район"),
  umanskij("Уманский район"),
  cherkasskij("Черкасский район"),
  vizhnickij("Вижницкий район"),
  koryukovskij("Корюковский район"),
  nezhinskij("Нежинский район"),
  novgorodSeverskij("Новгород-северский район"),
  prilukskij("Прилукский район"),
  chernigovskij("Черниговский район"),
  konotopskij("Конотопский район"),
  chernivetskij("Черневецкий район"),
  dnestrovskij("Днестровский район"),
  zolochevskij("Золочевский район");

  final String title;
  const EDistricts(this.title);
}

EDistricts getEDistrictsByString(String title) {
  switch (title) {
    case "Криворізький район":
      return EDistricts.krivorozhskij;
    case "Павлоградський район":
      return EDistricts.pavlogradskij;
    case "Кам’янський район":
      return EDistricts.kamenskij;
    case "Синельниківський район":
      return EDistricts.sinelnikovskij;
    case "Новомосковський район":
      return EDistricts.novomoskovskij;
    case "Дніпровський район":
      return EDistricts.dneprovskij;
    case "Нікопольський район":
      return EDistricts.nikopolskij;
    case "Бердянський район":
      return EDistricts.berdyanskij;
    case "Запорізький район":
      return EDistricts.zaporozhskij;
    case "Пологівський район":
      return EDistricts.pologovskij;
    case "Василівський район":
      return EDistricts.vasilevskij;
    case "Мелітопольський район":
      return EDistricts.melitopolskij;
    case "Броварський район":
      return EDistricts.brovarskij;
    case "Фастівський район":
      return EDistricts.fastovskij;
    case "Бучанський район":
      return EDistricts.buchanskij;
    case "Білоцерківський район":
      return EDistricts.belocerkovskij;
    case "Обухівський район":
      return EDistricts.obuhovskij;
    case "Бориспільський район":
      return EDistricts.borispolskij;
    case "Вишгородський район":
      return EDistricts.vyshgorodskij;
    case "Старобільський район":
      return EDistricts.starobelskij;
    case "Сватівський район":
      return EDistricts.svatovskij;
    case "Сєвєродонецький район":
      return EDistricts.severodoneckij;
    case "Щастинський район":
      return EDistricts.schastinskij;
    case "Ізюмський район":
      return EDistricts.izyumskij;
    case "Харківський район":
      return EDistricts.harkovskij;
    case "Лозівський район":
      return EDistricts.lozovskij;
    case "Богодухівський район":
      return EDistricts.bogoduhovskij;
    case "Куп’янський район":
      return EDistricts.kupyanskij;
    case "Чугуївський район":
      return EDistricts.chuguevskij;
    case "Красноградський район":
      return EDistricts.krasnogradskij;
    case "Покровський район":
      return EDistricts.pokrovskij;
    case "Краматорський район":
      return EDistricts.kramatorskij;
    case "Бахмутський район":
      return EDistricts.bahmutskij;
    case "Волноваський район":
      return EDistricts.volnovahskij;
    case "Маріупольський район":
      return EDistricts.mariupolskij;
    case "Донецький район":
      return EDistricts.doneckij;
    case "Кальміуський район":
      return EDistricts.kalmiusskij;
    case "Горлівський район":
      return EDistricts.gorlovskij;
    case "Бердичівський район":
      return EDistricts.berdichevskij;
    case "Житомирський район":
      return EDistricts.zhitomirskij;
    case "Новоград-Волинський район":
      return EDistricts.novogradVolynskij;
    case "Коростенський район":
      return EDistricts.korostenskij;
    case "Ужгородський район":
      return EDistricts.uzhgorodskij;
    case "Берегівський район":
      return EDistricts.beregovskij;
    case "Тячівський район":
      return EDistricts.tyachevskij;
    case "Хустський район":
      return EDistricts.hustskij;
    case "Рахівський район":
      return EDistricts.rahovskij;
    case "Мукачівський район":
      return EDistricts.mukachevskij;
    case "Верховинський район":
      return EDistricts.verhovinskij;
    case "Івано-Франківський район":
      return EDistricts.ivanoFrankovskij;
    case "Калуський район":
      return EDistricts.kalushskij;
    case "Надвірнянський район":
      return EDistricts.nadvornyanskij;
    case "Коломийський район":
      return EDistricts.kolomyjskij;
    case "Косівський район":
      return EDistricts.kosovskij;
    case "Кропивницький район":
      return EDistricts.kropivnickij;
    case "Голованівський район":
      return EDistricts.golovanevskij;
    case "Олександрійський район":
      return EDistricts.aleksandrijskij;
    case "Новоукраїнський район":
      return EDistricts.novoukrainskij;
    case "Червоноградський район":
      return EDistricts.chervonogradskij;
    case "Львівський район":
      return EDistricts.lvovskij;
    case "Самбірський район":
      return EDistricts.samborskij;
    case "Дрогобицький район":
      return EDistricts.drogobychskij;
    case "Золочівський район":
      return EDistricts.zolochevskij;
    case "Стрийський район":
      return EDistricts.stryjskij;
    case "Яворівський район":
      return EDistricts.yavorovskij;
    case "Первомайський район":
      return EDistricts.pervomajskij;
    case "Баштанський район":
      return EDistricts.bashtanskij;
    case "Миколаївський район":
      return EDistricts.nikolaevskij;
    case "Вознесенський район":
      return EDistricts.voznesenskij;
    case "Одеський район":
      return EDistricts.odesskij;
    case "Подільський район":
      return EDistricts.podolskij;
    case "Березівський район":
      return EDistricts.berezovskij;
    case "Болградський район":
      return EDistricts.bolgradskij;
    case "Білгород-Дністровський район":
      return EDistricts.belgorodDnestrovskij;
    case "Роздільнянський район":
      return EDistricts.razdelnyanskij;
    case "Ізмаїльський район":
      return EDistricts.izmailskij;
    case "Полтавський район":
      return EDistricts.poltavskij;
    case "Миргородський район":
      return EDistricts.mirgorodskij;
    case "Кременчуцький район":
      return EDistricts.kremenchugskij;
    case "Лубенський район":
      return EDistricts.lubenskij;
    case "Вараський район":
      return EDistricts.varashskij;
    case "Рівненський район":
      return EDistricts.rovenkovskij;
    case "Сарненський район":
      return EDistricts.sarnenskij;
    case "Дубенський район":
      return EDistricts.dubenskij;
    case "Роменський район":
      return EDistricts.romenskij;
    case "Сумський район":
      return EDistricts.sumskij;
    case "Шосткинський район":
      return EDistricts.shostkinskij;
    case "Охтирський район":
      return EDistricts.ahtyrskij;
    case "Конотопський район":
      return EDistricts.konotopskij;
    case "Тернопільський район":
      return EDistricts.ternopolskij;
    case "Чортківський район":
      return EDistricts.chortkovskij;
    case "Кременецький район":
      return EDistricts.kremeneckij;
    case "Каховський район":
      return EDistricts.kahovskij;
    case "Бериславський район":
      return EDistricts.berislavskij;
    case "Скадовський район":
      return EDistricts.skadovskij;
    case "Херсонський район":
      return EDistricts.hersonskij;
    case "Генічеський район":
      return EDistricts.genicheskij;
    case "Хмільницький район":
    case "Хмельницький район":
      return EDistricts.hmelnickij;
    case "Шепетівський район":
      return EDistricts.shepetovskij;
    case "Кам’янець-Подільський район":
      return EDistricts.kamenecPodolskij;
    case "Уманський район":
      return EDistricts.umanskij;
    case "Черкаський район":
      return EDistricts.cherkasskij;
    case "Звенигородський район":
      return EDistricts.zvenigorodskij;
    case "Золотоніський район":
      return EDistricts.zolotonoshskij;
    case "Вижницький район":
      return EDistricts.vizhnickij;
    case "Чернівецький район":
      return EDistricts.chernivetskij;
    case "Дністровський район":
      return EDistricts.dnestrovskij;
    case "Ніжинський район":
      return EDistricts.nezhinskij;
    case "Чернігівський район":
      return EDistricts.chernigovskij;
    case "Прилуцький район":
      return EDistricts.prilukskij;
    case "Новгород-Сіверський район":
      return EDistricts.novgorodSeverskij;
    case "Корюківський район":
      return EDistricts.koryukovskij;
    case "Вінницький район":
      return EDistricts.vinnetskij;
    case "Могилів-Подільський район":
      return EDistricts.mogilyovPodolskij;
    case "Жмеринський район":
      return EDistricts.zhmerinskij;
    case "Гайсинський район":
      return EDistricts.gajsinskij;
    case "Тульчинський район":
      return EDistricts.tulchinskij;
    case "Луцький район":
      return EDistricts.luganskij;
    case "Ковельський район":
      return EDistricts.kovelskij;
    case "Володимир-Волинський район":
      return EDistricts.vladimirskij;
    case "Камінь-Каширський район":
      return EDistricts.kamenKashirskij;
    default:
      throw Exception("No finde enum by string $title");
  }
}
