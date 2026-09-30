String alertJson = """
[
  {
    "uid": "13",
    "isAlert": false,
    "locationTitle": "Ивано-Франковская область",
    "finishedAt": "2026-09-13T00:55:31.335442",
    "listDistrict": [
      {
        "uid": "68",
        "isAlert": false,
        "locationTitle": "Ивано-Франковский район",
        "locationType": "raion",
        "finishedAt": "2026-09-13T01:14:43.557507",
        "alertLevel": "yellow",
        "threats": [
          {
            "threatType": "drones",
            "level": "yellow",
            "startedAt": "2026-09-12T22:00:05.164Z",
            "sourceMessage": "Дронова загроза (жовтий рівень)",
            "customMessage": "Дроны/БПЛА"
          }
        ],
        "listDistrict": []
      },
      {
        "uid": "67",
        "isAlert": false,
        "locationTitle": "Верховинский район",
        "finishedAt": "2026-09-13T00:55:31.335443",
        "listDistrict": []
      },
      {
        "uid": "71",
        "isAlert": false,
        "locationTitle": "Калушский район",
        "finishedAt": "2026-09-13T00:55:31.335444",
        "listDistrict": []
      },
      {
        "uid": "70",
        "isAlert": false,
        "locationTitle": "Коломыйский район",
        "finishedAt": "2026-09-13T00:55:31.335444",
        "listDistrict": []
      },
      {
        "uid": "69",
        "isAlert": false,
        "locationTitle": "Косовский район",
        "finishedAt": "2026-09-13T00:55:31.335448",
        "listDistrict": []
      },
      {
        "uid": "72",
        "isAlert": false,
        "locationTitle": "Надворнянский район",
        "finishedAt": "2026-09-13T00:55:31.335449",
        "listDistrict": []
      }
    ]
  },
  {
    "uid": "29",
    "isAlert": true,
    "locationTitle": "Автономная Республика Крым",
    "locationType": "oblast",
    "startedAt": "2022-12-10T22:22:00.000Z",
    "updatedAt": "2023-10-29T16:56:12.340Z",
    "alertType": "airRaid",
    "locationOblast": "Автономна Республіка Крим",
    "locationOblastUid": 29,
    "notes": "Згідно інформації з Офіційних карт тривог",
    "alertLevel": "red",
    "listDistrict": []
  },
  {
    "uid": "31",
    "isAlert": false,
    "locationTitle": "г. Киев",
    "finishedAt": "2026-09-13T00:55:31.335450",
    "listDistrict": []
  },
  {
    "uid": "30",
    "isAlert": false,
    "locationTitle": "г. Севастополь",
    "finishedAt": "2026-09-13T00:55:31.335450",
    "listDistrict": []
  },
  {
    "uid": "8",
    "isAlert": false,
    "locationTitle": "Волынская область",
    "finishedAt": "2026-09-13T00:55:31.335450",
    "listDistrict": [
      {
        "uid": "38",
        "isAlert": false,
        "locationTitle": "Владимирский район",
        "finishedAt": "2026-09-13T00:55:31.335451",
        "listDistrict": []
      },
      {
        "uid": "41",
        "isAlert": false,
        "locationTitle": "Камень-Каширский район",
        "finishedAt": "2026-09-13T00:55:31.335451",
        "listDistrict": []
      },
      {
        "uid": "40",
        "isAlert": false,
        "locationTitle": "Ковельский район",
        "finishedAt": "2026-09-13T00:55:31.335451",
        "listDistrict": []
      },
      {
        "uid": "39",
        "isAlert": false,
        "locationTitle": "Луцкий район",
        "locationType": "raion",
        "finishedAt": "2026-09-13T01:30:19.515434",
        "alertLevel": "yellow",
        "threats": [
          {
            "threatType": "drones",
            "level": "yellow",
            "startedAt": "2026-09-12T20:23:20.742Z",
            "sourceMessage": "Дронова загроза (жовтий рівень)",
            "customMessage": "Дроны/БПЛА"
          }
        ],
        "listDistrict": []
      }
    ]
  },
  {
    "uid": "4",
    "isAlert": false,
    "locationTitle": "Винницкая область",
    "finishedAt": "2026-09-13T00:55:31.335452",
    "listDistrict": [
      {
        "uid": "36",
        "isAlert": false,
        "locationTitle": "Винницкий район",
        "locationType": "raion",
        "finishedAt": "2026-09-13T01:04:12.500469",
        "alertLevel": "yellow",
        "threats": [
          {
            "threatType": "drones",
            "level": "yellow",
            "startedAt": "2026-09-12T20:11:05.399Z",
            "sourceMessage": "Дронова загроза (жовтий рівень)",
            "customMessage": "Дроны/БПЛА"
          }
        ],
        "listDistrict": []
      },
      {
        "uid": "37",
        "isAlert": false,
        "locationTitle": "Гайсинский район",
        "locationType": "raion",
        "finishedAt": "2026-09-13T01:04:12.500497",
        "alertLevel": "yellow",
        "threats": [
          {
            "threatType": "drones",
            "level": "yellow",
            "startedAt": "2026-09-12T19:41:18.190Z",
            "sourceMessage": "Дронова загроза (жовтий рівень)",
            "customMessage": "Дроны/БПЛА"
          }
        ],
        "listDistrict": []
      },
      {
        "uid": "35",
        "isAlert": false,
        "locationTitle": "Жмеринский район",
        "locationType": "raion",
        "finishedAt": "2026-09-13T01:04:12.500525",
        "alertLevel": "yellow",
        "threats": [
          {
            "threatType": "drones",
            "level": "yellow",
            "startedAt": "2026-09-12T20:27:55.997Z",
            "sourceMessage": "Дронова загроза (жовтий рівень)",
            "customMessage": "Дроны/БПЛА"
          }
        ],
        "listDistrict": []
      },
      {
        "uid": "33",
        "isAlert": false,
        "locationTitle": "Могилёв-Подольский район",
        "finishedAt": "2026-09-13T00:55:31.335453",
        "listDistrict": []
      },
      {
        "uid": "32",
        "isAlert": false,
        "locationTitle": "Тульчинский район",
        "locationType": "raion",
        "finishedAt": "2026-09-13T01:04:12.500581",
        "alertLevel": "yellow",
        "threats": [
          {
            "threatType": "drones",
            "level": "yellow",
            "startedAt": "2026-09-12T20:11:05.248Z",
            "sourceMessage": "Дронова загроза (жовтий рівень)",
            "customMessage": "Дроны/БПЛА"
          }
        ],
        "listDistrict": []
      },
      {
        "uid": "34",
        "isAlert": false,
        "locationTitle": "Хмельникский район",
        "locationType": "raion",
        "finishedAt": "2026-09-13T01:04:12.500609",
        "alertLevel": "yellow",
        "threats": [
          {
            "threatType": "drones",
            "level": "yellow",
            "startedAt": "2026-09-12T20:46:13.377Z",
            "sourceMessage": "Дронова загроза (жовтий рівень)",
            "customMessage": "Дроны/БПЛА"
          }
        ],
        "listDistrict": []
      }
    ]
  },
  {
    "uid": "9",
    "isAlert": false,
    "locationTitle": "Днепропетровская область",
    "finishedAt": "2026-09-13T00:55:31.335454",
    "listDistrict": [
      {
        "uid": "44",
        "isAlert": false,
        "locationTitle": "Днепровский район",
        "finishedAt": "2026-09-13T00:55:31.335455",
        "listDistrict": []
      },
      {
        "uid": "42",
        "isAlert": false,
        "locationTitle": "Каменский район",
        "finishedAt": "2026-09-13T00:55:31.335455",
        "listDistrict": []
      },
      {
        "uid": "46",
        "isAlert": false,
        "locationTitle": "Криворожский район",
        "finishedAt": "2026-09-13T00:55:31.335458",
        "listDistrict": []
      },
      {
        "uid": "47",
        "isAlert": false,
        "locationTitle": "Никопольский район",
        "finishedAt": "2026-09-13T00:55:31.335459",
        "listDistrict": []
      },
      {
        "uid": "45",
        "isAlert": false,
        "locationTitle": "Павлоградский район",
        "finishedAt": "2026-09-13T00:55:31.335459",
        "listDistrict": []
      },
      {
        "uid": "43",
        "isAlert": false,
        "locationTitle": "Самаровский район",
        "finishedAt": "2026-09-13T00:55:31.335459",
        "listDistrict": []
      },
      {
        "uid": "48",
        "isAlert": true,
        "locationTitle": "Синельниковский район",
        "locationType": "raion",
        "startedAt": "2026-09-12T21:40:03.108Z",
        "updatedAt": "2026-09-12T21:40:35.392Z",
        "alertType": "airRaid",
        "locationOblast": "Дніпропетровська область",
        "locationOblastUid": 48,
        "alertLevel": "red",
        "threats": [
          {
            "threatType": "drones",
            "level": "yellow",
            "startedAt": "2026-09-12T21:40:03.108Z",
            "sourceMessage": "Дронова загроза (жовтий рівень)",
            "customMessage": "Дроны/БПЛА"
          },
          {
            "threatType": "unspecifiedMissiles",
            "level": "red",
            "startedAt": "2026-09-12T21:40:33.624Z",
            "customMessage": "Ракетная угроза"
          }
        ],
        "listDistrict": []
      }
    ]
  },
  {
    "uid": "28",
    "isAlert": false,
    "locationTitle": "Донецкая область",
    "finishedAt": "2026-09-13T00:55:31.335460",
    "listDistrict": [
      {
        "uid": "54",
        "isAlert": true,
        "locationTitle": "Бахмутский район",
        "locationType": "raion",
        "startedAt": "2026-09-12T21:27:24.840Z",
        "updatedAt": "2026-09-12T21:27:31.606Z",
        "alertType": "airRaid",
        "locationOblast": "Донецька область",
        "locationOblastUid": 54,
        "alertLevel": "yellow",
        "threats": [
          {
            "threatType": "drones",
            "level": "yellow",
            "startedAt": "2026-09-12T21:27:24.840Z",
            "sourceMessage": "Дронова загроза (жовтий рівень)",
            "customMessage": "Дроны/БПЛА"
          }
        ],
        "listDistrict": []
      },
      {
        "uid": "55",
        "isAlert": true,
        "locationTitle": "Волновахский район",
        "locationType": "raion",
        "startedAt": "2026-09-12T21:27:26.302Z",
        "updatedAt": "2026-09-12T21:27:31.736Z",
        "alertType": "airRaid",
        "locationOblast": "Донецька область",
        "locationOblastUid": 55,
        "alertLevel": "yellow",
        "threats": [
          {
            "threatType": "drones",
            "level": "yellow",
            "startedAt": "2026-09-12T21:27:26.302Z",
            "sourceMessage": "Дронова загроза (жовтий рівень)",
            "customMessage": "Дроны/БПЛА"
          }
        ],
        "listDistrict": []
      },
      {
        "uid": "51",
        "isAlert": true,
        "locationTitle": "Горловский район",
        "locationType": "raion",
        "startedAt": "2026-09-12T21:27:24.867Z",
        "updatedAt": "2026-09-12T21:27:31.658Z",
        "alertType": "airRaid",
        "locationOblast": "Донецька область",
        "locationOblastUid": 51,
        "alertLevel": "yellow",
        "threats": [
          {
            "threatType": "drones",
            "level": "yellow",
            "startedAt": "2026-09-12T21:27:24.867Z",
            "sourceMessage": "Дронова загроза (жовтий рівень)",
            "customMessage": "Дроны/БПЛА"
          }
        ],
        "listDistrict": []
      },
      {
        "uid": "53",
        "isAlert": true,
        "locationTitle": "Донецкий район",
        "locationType": "raion",
        "startedAt": "2026-09-12T21:27:24.663Z",
        "updatedAt": "2026-09-12T21:27:31.632Z",
        "alertType": "airRaid",
        "locationOblast": "Донецька область",
        "locationOblastUid": 53,
        "alertLevel": "yellow",
        "threats": [
          {
            "threatType": "drones",
            "level": "yellow",
            "startedAt": "2026-09-12T21:27:24.663Z",
            "sourceMessage": "Дронова загроза (жовтий рівень)",
            "customMessage": "Дроны/БПЛА"
          }
        ],
        "listDistrict": []
      },
      {
        "uid": "49",
        "isAlert": true,
        "locationTitle": "Кальмиусский район",
        "locationType": "raion",
        "startedAt": "2026-09-12T21:27:26.192Z",
        "updatedAt": "2026-09-12T21:27:31.720Z",
        "alertType": "airRaid",
        "locationOblast": "Донецька область",
        "locationOblastUid": 49,
        "alertLevel": "yellow",
        "threats": [
          {
            "threatType": "drones",
            "level": "yellow",
            "startedAt": "2026-09-12T21:27:26.192Z",
            "sourceMessage": "Дронова загроза (жовтий рівень)",
            "customMessage": "Дроны/БПЛА"
          }
        ],
        "listDistrict": []
      },
      {
        "uid": "50",
        "isAlert": true,
        "locationTitle": "Краматорский район",
        "locationType": "raion",
        "startedAt": "2026-09-12T21:27:24.670Z",
        "updatedAt": "2026-09-12T21:27:31.565Z",
        "alertType": "airRaid",
        "locationOblast": "Донецька область",
        "locationOblastUid": 50,
        "alertLevel": "yellow",
        "threats": [
          {
            "threatType": "drones",
            "level": "yellow",
            "startedAt": "2026-09-12T21:27:24.670Z",
            "sourceMessage": "Дронова загроза (жовтий рівень)",
            "customMessage": "Дроны/БПЛА"
          }
        ],
        "listDistrict": []
      },
      {
        "uid": "52",
        "isAlert": true,
        "locationTitle": "Мариупольский район",
        "locationType": "raion",
        "startedAt": "2026-09-12T21:27:26.201Z",
        "updatedAt": "2026-09-12T21:27:31.702Z",
        "alertType": "airRaid",
        "locationOblast": "Донецька область",
        "locationOblastUid": 52,
        "alertLevel": "yellow",
        "threats": [
          {
            "threatType": "drones",
            "level": "yellow",
            "startedAt": "2026-09-12T21:27:26.201Z",
            "sourceMessage": "Дронова загроза (жовтий рівень)",
            "customMessage": "Дроны/БПЛА"
          }
        ],
        "listDistrict": []
      },
      {
        "uid": "56",
        "isAlert": true,
        "locationTitle": "Покровский район",
        "locationType": "raion",
        "startedAt": "2026-09-12T21:27:25.299Z",
        "updatedAt": "2026-09-12T21:27:31.681Z",
        "alertType": "airRaid",
        "locationOblast": "Донецька область",
        "locationOblastUid": 56,
        "alertLevel": "yellow",
        "threats": [
          {
            "threatType": "drones",
            "level": "yellow",
            "startedAt": "2026-09-12T21:27:25.299Z",
            "sourceMessage": "Дронова загроза (жовтий рівень)",
            "customMessage": "Дроны/БПЛА"
          }
        ],
        "listDistrict": []
      }
    ]
  },
  {
    "uid": "10",
    "isAlert": false,
    "locationTitle": "Житомирская область",
    "finishedAt": "2026-09-13T00:55:31.335462",
    "listDistrict": [
      {
        "uid": "57",
        "isAlert": false,
        "locationTitle": "Бердичевский район",
        "locationType": "raion",
        "finishedAt": "2026-09-13T01:30:19.516108",
        "alertLevel": "yellow",
        "threats": [
          {
            "threatType": "drones",
            "level": "yellow",
            "startedAt": "2026-09-12T21:02:53.936Z",
            "sourceMessage": "Дронова загроза (жовтий рівень)",
            "customMessage": "Дроны/БПЛА"
          }
        ],
        "listDistrict": []
      },
      {
        "uid": "59",
        "isAlert": true,
        "locationTitle": "Житомирский район",
        "locationType": "raion",
        "startedAt": "2026-09-12T07:56:57.650Z",
        "updatedAt": "2026-09-12T12:35:22.934Z",
        "alertType": "airRaid",
        "locationOblast": "Житомирська область",
        "locationOblastUid": 59,
        "alertLevel": "red",
        "threats": [
          {
            "threatType": "drones",
            "level": "yellow",
            "startedAt": "2026-09-12T07:56:57.650Z",
            "sourceMessage": "Дронова загроза (жовтий рівень)",
            "customMessage": "Дроны/БПЛА"
          },
          {
            "threatType": "unspecifiedMissiles",
            "level": "red",
            "startedAt": "2026-09-12T12:35:13.473Z",
            "sourceMessage": "Ракетна загроза (червоний рівень)",
            "customMessage": "Ракетная угроза"
          }
        ],
        "listDistrict": []
      },
      {
        "uid": "60",
        "isAlert": true,
        "locationTitle": "Звягельский район",
        "locationType": "raion",
        "startedAt": "2026-09-12T11:54:22.906Z",
        "updatedAt": "2026-09-12T12:35:23.004Z",
        "alertType": "airRaid",
        "locationOblast": "Житомирська область",
        "locationOblastUid": 60,
        "alertLevel": "red",
        "threats": [
          {
            "threatType": "drones",
            "level": "yellow",
            "startedAt": "2026-09-12T11:54:22.906Z",
            "sourceMessage": "Дронова загроза (жовтий рівень)",
            "customMessage": "Дроны/БПЛА"
          },
          {
            "threatType": "unspecifiedMissiles",
            "level": "red",
            "startedAt": "2026-09-12T12:35:17.174Z",
            "sourceMessage": "Ракетна загроза (червоний рівень)",
            "customMessage": "Ракетная угроза"
          }
        ],
        "listDistrict": []
      },
      {
        "uid": "58",
        "isAlert": true,
        "locationTitle": "Коростенский район",
        "locationType": "raion",
        "startedAt": "2026-09-12T06:22:33.747Z",
        "updatedAt": "2026-09-12T12:35:22.889Z",
        "alertType": "airRaid",
        "locationOblast": "Житомирська область",
        "locationOblastUid": 58,
        "alertLevel": "red",
        "threats": [
          {
            "threatType": "drones",
            "level": "yellow",
            "startedAt": "2026-09-12T06:22:33.747Z",
            "sourceMessage": "Дронова загроза (жовтий рівень)",
            "customMessage": "Дроны/БПЛА"
          },
          {
            "threatType": "unspecifiedMissiles",
            "level": "red",
            "startedAt": "2026-09-12T12:35:17.483Z",
            "sourceMessage": "Ракетна загроза (червоний рівень)",
            "customMessage": "Ракетная угроза"
          }
        ],
        "listDistrict": []
      }
    ]
  },
  {
    "uid": "11",
    "isAlert": false,
    "locationTitle": "Закарпатская область",
    "finishedAt": "2026-09-13T00:55:31.335464",
    "listDistrict": [
      {
        "uid": "61",
        "isAlert": false,
        "locationTitle": "Береговский район",
        "finishedAt": "2026-09-13T00:55:31.335464",
        "listDistrict": []
      },
      {
        "uid": "65",
        "isAlert": false,
        "locationTitle": "Мукачевский район",
        "finishedAt": "2026-09-13T00:55:31.335465",
        "listDistrict": []
      },
      {
        "uid": "63",
        "isAlert": false,
        "locationTitle": "Раховский район",
        "finishedAt": "2026-09-13T00:55:31.335468",
        "listDistrict": []
      },
      {
        "uid": "64",
        "isAlert": false,
        "locationTitle": "Тячевский район",
        "finishedAt": "2026-09-13T00:55:31.335468",
        "listDistrict": []
      },
      {
        "uid": "66",
        "isAlert": false,
        "locationTitle": "Ужгородский район",
        "finishedAt": "2026-09-13T00:55:31.335469",
        "listDistrict": []
      },
      {
        "uid": "62",
        "isAlert": false,
        "locationTitle": "Хустский район",
        "finishedAt": "2026-09-13T00:55:31.335469",
        "listDistrict": []
      }
    ]
  },
  {
    "uid": "12",
    "isAlert": false,
    "locationTitle": "Запорожская область",
    "finishedAt": "2026-09-13T00:55:31.335470",
    "listDistrict": [
      {
        "uid": "147",
        "isAlert": true,
        "locationTitle": "Бердянский район",
        "locationType": "raion",
        "startedAt": "2026-09-12T22:27:42.214Z",
        "updatedAt": "2026-09-12T22:27:51.544Z",
        "alertType": "airRaid",
        "locationOblast": "Запорізька область",
        "locationOblastUid": 147,
        "alertLevel": "yellow",
        "threats": [
          {
            "threatType": "drones",
            "level": "yellow",
            "startedAt": "2026-09-12T22:27:42.214Z",
            "sourceMessage": "Дронова загроза (жовтий рівень)",
            "customMessage": "Дроны/БПЛА"
          }
        ],
        "listDistrict": []
      },
      {
        "uid": "146",
        "isAlert": true,
        "locationTitle": "Васильевский район",
        "locationType": "raion",
        "startedAt": "2026-09-12T22:27:41.046Z",
        "updatedAt": "2026-09-12T22:27:51.490Z",
        "alertType": "airRaid",
        "locationOblast": "Запорізька область",
        "locationOblastUid": 146,
        "alertLevel": "yellow",
        "threats": [
          {
            "threatType": "drones",
            "level": "yellow",
            "startedAt": "2026-09-12T22:27:41.046Z",
            "sourceMessage": "Дронова загроза (жовтий рівень)",
            "customMessage": "Дроны/БПЛА"
          }
        ],
        "listDistrict": []
      },
      {
        "uid": "149",
        "isAlert": true,
        "locationTitle": "Запорожский район",
        "locationType": "raion",
        "startedAt": "2026-09-12T22:27:40.847Z",
        "updatedAt": "2026-09-12T22:27:51.465Z",
        "alertType": "airRaid",
        "locationOblast": "Запорізька область",
        "locationOblastUid": 149,
        "alertLevel": "yellow",
        "threats": [
          {
            "threatType": "drones",
            "level": "yellow",
            "startedAt": "2026-09-12T22:27:40.847Z",
            "sourceMessage": "Дронова загроза (жовтий рівень)",
            "customMessage": "Дроны/БПЛА"
          }
        ],
        "listDistrict": []
      },
      {
        "uid": "148",
        "isAlert": true,
        "locationTitle": "Мелитопольский район",
        "locationType": "raion",
        "startedAt": "2026-09-12T22:27:42.355Z",
        "updatedAt": "2026-09-12T22:27:51.565Z",
        "alertType": "airRaid",
        "locationOblast": "Запорізька область",
        "locationOblastUid": 148,
        "alertLevel": "yellow",
        "threats": [
          {
            "threatType": "drones",
            "level": "yellow",
            "startedAt": "2026-09-12T22:27:42.355Z",
            "sourceMessage": "Дронова загроза (жовтий рівень)",
            "customMessage": "Дроны/БПЛА"
          }
        ],
        "listDistrict": []
      },
      {
        "uid": "145",
        "isAlert": true,
        "locationTitle": "Пологовский район",
        "locationType": "raion",
        "startedAt": "2026-09-12T22:27:41.801Z",
        "updatedAt": "2026-09-12T22:27:51.510Z",
        "alertType": "airRaid",
        "locationOblast": "Запорізька область",
        "locationOblastUid": 145,
        "alertLevel": "yellow",
        "threats": [
          {
            "threatType": "drones",
            "level": "yellow",
            "startedAt": "2026-09-12T22:27:41.801Z",
            "sourceMessage": "Дронова загроза (жовтий рівень)",
            "customMessage": "Дроны/БПЛА"
          }
        ],
        "listDistrict": []
      }
    ]
  },
  {
    "uid": "14",
    "isAlert": false,
    "locationTitle": "Киевская область",
    "finishedAt": "2026-09-13T00:55:31.335472",
    "listDistrict": [
      {
        "uid": "78",
        "isAlert": false,
        "locationTitle": "Бориспольский район",
        "locationType": "raion",
        "finishedAt": "2026-09-13T01:30:19.516573",
        "alertLevel": "yellow",
        "threats": [
          {
            "threatType": "drones",
            "level": "yellow",
            "startedAt": "2026-09-12T19:30:13.391Z",
            "sourceMessage": "Дронова загроза (жовтий рівень)",
            "customMessage": "Дроны/БПЛА"
          }
        ],
        "listDistrict": []
      },
      {
        "uid": "79",
        "isAlert": true,
        "locationTitle": "Броварский район",
        "locationType": "raion",
        "startedAt": "2026-09-12T04:45:21.537Z",
        "updatedAt": "2026-09-12T12:35:22.869Z",
        "alertType": "airRaid",
        "locationOblast": "Київська область",
        "locationOblastUid": 79,
        "alertLevel": "red",
        "threats": [
          {
            "threatType": "drones",
            "level": "yellow",
            "startedAt": "2026-09-12T04:45:21.537Z",
            "sourceMessage": "Дронова загроза (жовтий рівень)",
            "customMessage": "Дроны/БПЛА"
          },
          {
            "threatType": "unspecifiedMissiles",
            "level": "red",
            "startedAt": "2026-09-12T12:35:14.465Z",
            "sourceMessage": "Ракетна загроза (червоний рівень)",
            "customMessage": "Ракетная угроза"
          }
        ],
        "listDistrict": []
      },
      {
        "uid": "75",
        "isAlert": true,
        "locationTitle": "Бучанский район",
        "locationType": "raion",
        "startedAt": "2026-09-12T07:08:04.568Z",
        "updatedAt": "2026-09-12T12:35:22.912Z",
        "alertType": "airRaid",
        "locationOblast": "Київська область",
        "locationOblastUid": 75,
        "alertLevel": "red",
        "threats": [
          {
            "threatType": "drones",
            "level": "yellow",
            "startedAt": "2026-09-12T07:08:04.568Z",
            "sourceMessage": "Дронова загроза (жовтий рівень)",
            "customMessage": "Дроны/БПЛА"
          },
          {
            "threatType": "unspecifiedMissiles",
            "level": "red",
            "startedAt": "2026-09-12T12:35:17.291Z",
            "sourceMessage": "Ракетна загроза (червоний рівень)",
            "customMessage": "Ракетная угроза"
          }
        ],
        "listDistrict": []
      },
      {
        "uid": "73",
        "isAlert": false,
        "locationTitle": "Белоцерковский район",
        "locationType": "raion",
        "finishedAt": "2026-09-13T01:04:12.501712",
        "alertLevel": "yellow",
        "threats": [
          {
            "threatType": "drones",
            "level": "yellow",
            "startedAt": "2026-09-12T20:07:48.375Z",
            "sourceMessage": "Дронова загроза (жовтий рівень)",
            "customMessage": "Дроны/БПЛА"
          }
        ],
        "listDistrict": []
      },
      {
        "uid": "74",
        "isAlert": true,
        "locationTitle": "Вышгородский район",
        "locationType": "raion",
        "startedAt": "2026-09-12T03:53:49.220Z",
        "updatedAt": "2026-09-12T12:35:22.836Z",
        "alertType": "airRaid",
        "locationOblast": "Київська область",
        "locationOblastUid": 74,
        "alertLevel": "red",
        "threats": [
          {
            "threatType": "drones",
            "level": "yellow",
            "startedAt": "2026-09-12T03:53:49.220Z",
            "sourceMessage": "Дронова загроза (жовтий рівень)",
            "customMessage": "Дроны/БПЛА"
          },
          {
            "threatType": "unspecifiedMissiles",
            "level": "red",
            "startedAt": "2026-09-12T12:35:17.659Z",
            "sourceMessage": "Ракетна загроза (червоний рівень)",
            "customMessage": "Ракетная угроза"
          }
        ],
        "listDistrict": []
      },
      {
        "uid": "76",
        "isAlert": false,
        "locationTitle": "Обуховский район",
        "finishedAt": "2026-09-13T00:55:31.335473",
        "listDistrict": []
      },
      {
        "uid": "77",
        "isAlert": false,
        "locationTitle": "Фастовский район",
        "finishedAt": "2026-09-13T00:55:31.335474",
        "listDistrict": []
      }
    ]
  },
  {
    "uid": "15",
    "isAlert": false,
    "locationTitle": "Кировоградская область",
    "finishedAt": "2026-09-13T00:55:31.335474",
    "listDistrict": [
      {
        "uid": "82",
        "isAlert": false,
        "locationTitle": "Голованевский район",
        "finishedAt": "2026-09-13T00:55:31.335475",
        "listDistrict": []
      },
      {
        "uid": "81",
        "isAlert": false,
        "locationTitle": "Кропивницкий район",
        "finishedAt": "2026-09-13T00:55:31.335475",
        "listDistrict": []
      },
      {
        "uid": "83",
        "isAlert": false,
        "locationTitle": "Новоукраинский район",
        "finishedAt": "2026-09-13T00:55:31.335478",
        "listDistrict": []
      },
      {
        "uid": "80",
        "isAlert": false,
        "locationTitle": "Александрийский район",
        "locationType": "raion",
        "finishedAt": "2026-09-13T01:30:19.516857",
        "alertLevel": "yellow",
        "threats": [
          {
            "threatType": "drones",
            "level": "yellow",
            "startedAt": "2026-09-12T20:46:49.588Z",
            "sourceMessage": "Дронова загроза (жовтий рівень)",
            "customMessage": "Дроны/БПЛА"
          }
        ],
        "listDistrict": []
      }
    ]
  },
  {
    "uid": "16",
    "isAlert": true,
    "locationTitle": "Луганская область",
    "locationType": "oblast",
    "startedAt": "2022-04-04T16:45:39.000Z",
    "updatedAt": "2023-10-29T18:22:37.357Z",
    "alertType": "airRaid",
    "locationOblast": "Луганська область",
    "locationOblastUid": 16,
    "alertLevel": "red",
    "listDistrict": [
      {
        "uid": "1803",
        "isAlert": false,
        "locationTitle": "Алчевский район",
        "finishedAt": "2026-09-13T00:55:31.335479",
        "listDistrict": []
      },
      {
        "uid": "1804",
        "isAlert": false,
        "locationTitle": "Должанский район",
        "finishedAt": "2026-09-13T00:55:31.335479",
        "listDistrict": []
      },
      {
        "uid": "1801",
        "isAlert": false,
        "locationTitle": "Луганский район",
        "finishedAt": "2026-09-13T00:55:31.335480",
        "listDistrict": []
      },
      {
        "uid": "1802",
        "isAlert": false,
        "locationTitle": "Ровеньковский район",
        "finishedAt": "2026-09-13T00:55:31.335480",
        "listDistrict": []
      },
      {
        "uid": "85",
        "isAlert": false,
        "locationTitle": "Сватовский район",
        "finishedAt": "2026-09-13T00:55:31.335480",
        "listDistrict": []
      },
      {
        "uid": "86",
        "isAlert": false,
        "locationTitle": "Старобельский район",
        "finishedAt": "2026-09-13T00:55:31.335481",
        "listDistrict": []
      },
      {
        "uid": "84",
        "isAlert": false,
        "locationTitle": "Северодонецкий район",
        "finishedAt": "2026-09-13T00:55:31.335481",
        "listDistrict": []
      },
      {
        "uid": "87",
        "isAlert": false,
        "locationTitle": "Счастьенский район",
        "finishedAt": "2026-09-13T00:55:31.335481",
        "listDistrict": []
      }
    ]
  },
  {
    "uid": "27",
    "isAlert": false,
    "locationTitle": "Львовская область",
    "finishedAt": "2026-09-13T00:55:31.335482",
    "listDistrict": [
      {
        "uid": "91",
        "isAlert": false,
        "locationTitle": "Дрогобычский район",
        "finishedAt": "2026-09-13T00:55:31.335482",
        "listDistrict": []
      },
      {
        "uid": "94",
        "isAlert": false,
        "locationTitle": "Золочевский район",
        "finishedAt": "2026-09-13T00:55:31.335482",
        "listDistrict": []
      },
      {
        "uid": "90",
        "isAlert": false,
        "locationTitle": "Львовский район",
        "locationType": "raion",
        "finishedAt": "2026-09-13T01:14:43.559699",
        "alertLevel": "yellow",
        "threats": [
          {
            "threatType": "drones",
            "level": "yellow",
            "startedAt": "2026-09-12T22:00:06.343Z",
            "sourceMessage": "Дронова загроза (жовтий рівень)",
            "customMessage": "Дроны/БПЛА"
          }
        ],
        "listDistrict": []
      },
      {
        "uid": "88",
        "isAlert": false,
        "locationTitle": "Самборский район",
        "finishedAt": "2026-09-13T00:55:31.335483",
        "listDistrict": []
      },
      {
        "uid": "89",
        "isAlert": false,
        "locationTitle": "Стрыйский район",
        "finishedAt": "2026-09-13T00:55:31.335483",
        "listDistrict": []
      },
      {
        "uid": "92",
        "isAlert": false,
        "locationTitle": "Шептицкий район",
        "finishedAt": "2026-09-13T00:55:31.335483",
        "listDistrict": []
      },
      {
        "uid": "93",
        "isAlert": false,
        "locationTitle": "Яворовский район",
        "finishedAt": "2026-09-13T00:55:31.335484",
        "listDistrict": []
      }
    ]
  },
  {
    "uid": "17",
    "isAlert": false,
    "locationTitle": "Николаевская область",
    "finishedAt": "2026-09-13T00:55:31.335484",
    "listDistrict": [
      {
        "uid": "96",
        "isAlert": false,
        "locationTitle": "Баштанский район",
        "finishedAt": "2026-09-13T00:55:31.335485",
        "listDistrict": []
      },
      {
        "uid": "95",
        "isAlert": false,
        "locationTitle": "Вознесенский район",
        "finishedAt": "2026-09-13T00:55:31.335488",
        "listDistrict": []
      },
      {
        "uid": "98",
        "isAlert": false,
        "locationTitle": "Николаевский район",
        "finishedAt": "2026-09-13T00:55:31.335489",
        "listDistrict": []
      },
      {
        "uid": "97",
        "isAlert": false,
        "locationTitle": "Первомайский район",
        "finishedAt": "2026-09-13T00:55:31.335489",
        "listDistrict": []
      }
    ]
  },
  {
    "uid": "18",
    "isAlert": false,
    "locationTitle": "Одесская область",
    "finishedAt": "2026-09-13T00:55:31.335489",
    "listDistrict": [
      {
        "uid": "101",
        "isAlert": false,
        "locationTitle": "Измаильский район",
        "finishedAt": "2026-09-13T00:55:31.335489",
        "listDistrict": []
      },
      {
        "uid": "100",
        "isAlert": false,
        "locationTitle": "Березовский район",
        "finishedAt": "2026-09-13T00:55:31.335490",
        "listDistrict": []
      },
      {
        "uid": "105",
        "isAlert": false,
        "locationTitle": "Болградский район",
        "finishedAt": "2026-09-13T00:55:31.335490",
        "listDistrict": []
      },
      {
        "uid": "102",
        "isAlert": false,
        "locationTitle": "Белгород-Днестровский район",
        "finishedAt": "2026-09-13T00:55:31.335490",
        "listDistrict": []
      },
      {
        "uid": "104",
        "isAlert": false,
        "locationTitle": "Одесский район",
        "finishedAt": "2026-09-13T00:55:31.335491",
        "listDistrict": []
      },
      {
        "uid": "99",
        "isAlert": false,
        "locationTitle": "Подольский район",
        "finishedAt": "2026-09-13T00:55:31.335491",
        "listDistrict": []
      },
      {
        "uid": "103",
        "isAlert": false,
        "locationTitle": "Раздельнянский район",
        "finishedAt": "2026-09-13T00:55:31.335491",
        "listDistrict": []
      }
    ]
  },
  {
    "uid": "19",
    "isAlert": false,
    "locationTitle": "Полтавская область",
    "finishedAt": "2026-09-13T00:55:31.335492",
    "listDistrict": [
      {
        "uid": "107",
        "isAlert": false,
        "locationTitle": "Кременчугский район",
        "finishedAt": "2026-09-13T00:55:31.335492",
        "listDistrict": []
      },
      {
        "uid": "106",
        "isAlert": false,
        "locationTitle": "Лубенский район",
        "finishedAt": "2026-09-13T00:55:31.335492",
        "listDistrict": []
      },
      {
        "uid": "108",
        "isAlert": true,
        "locationTitle": "Миргородский район",
        "locationType": "raion",
        "startedAt": "2026-09-12T22:08:10.097Z",
        "updatedAt": "2026-09-12T22:08:11.529Z",
        "alertType": "airRaid",
        "locationOblast": "Полтавська область",
        "locationOblastUid": 108,
        "alertLevel": "yellow",
        "threats": [
          {
            "threatType": "drones",
            "level": "yellow",
            "startedAt": "2026-09-12T22:08:10.097Z",
            "sourceMessage": "Дронова загроза (жовтий рівень)",
            "customMessage": "Дроны/БПЛА"
          }
        ],
        "listDistrict": []
      },
      {
        "uid": "109",
        "isAlert": false,
        "locationTitle": "Полтавский район",
        "finishedAt": "2026-09-13T00:55:31.335493",
        "listDistrict": []
      }
    ]
  },
  {
    "uid": "5",
    "isAlert": false,
    "locationTitle": "Ровненская область",
    "finishedAt": "2026-09-13T00:55:31.335493",
    "listDistrict": [
      {
        "uid": "110",
        "isAlert": false,
        "locationTitle": "Варашский район",
        "locationType": "raion",
        "finishedAt": "2026-09-13T01:30:19.517822",
        "alertLevel": "yellow",
        "threats": [
          {
            "threatType": "drones",
            "level": "yellow",
            "startedAt": "2026-09-12T19:44:53.950Z",
            "sourceMessage": "Дронова загроза (жовтий рівень)",
            "customMessage": "Дроны/БПЛА"
          }
        ],
        "listDistrict": []
      },
      {
        "uid": "111",
        "isAlert": false,
        "locationTitle": "Дубенский район",
        "locationType": "raion",
        "finishedAt": "2026-09-13T01:30:19.517849",
        "alertLevel": "yellow",
        "threats": [
          {
            "threatType": "drones",
            "level": "yellow",
            "startedAt": "2026-09-12T20:18:26.468Z",
            "sourceMessage": "Дронова загроза (жовтий рівень)",
            "customMessage": "Дроны/БПЛА"
          }
        ],
        "listDistrict": []
      },
      {
        "uid": "112",
        "isAlert": true,
        "locationTitle": "Ровненский район",
        "locationType": "raion",
        "startedAt": "2026-09-12T19:44:53.270Z",
        "updatedAt": "2026-09-12T19:45:01.246Z",
        "alertType": "airRaid",
        "locationOblast": "Рівненська область",
        "locationOblastUid": 112,
        "alertLevel": "yellow",
        "threats": [
          {
            "threatType": "drones",
            "level": "yellow",
            "startedAt": "2026-09-12T19:44:53.270Z",
            "sourceMessage": "Дронова загроза (жовтий рівень)",
            "customMessage": "Дроны/БПЛА"
          }
        ],
        "listDistrict": []
      },
      {
        "uid": "113",
        "isAlert": false,
        "locationTitle": "Сарненский район",
        "locationType": "raion",
        "finishedAt": "2026-09-13T01:30:19.517901",
        "alertLevel": "yellow",
        "threats": [
          {
            "threatType": "drones",
            "level": "yellow",
            "startedAt": "2026-09-12T19:24:19.663Z",
            "sourceMessage": "Дронова загроза (жовтий рівень)",
            "customMessage": "Дроны/БПЛА"
          }
        ],
        "listDistrict": []
      }
    ]
  },
  {
    "uid": "20",
    "isAlert": false,
    "locationTitle": "Сумская область",
    "finishedAt": "2026-09-13T00:55:31.335498",
    "listDistrict": [
      {
        "uid": "117",
        "isAlert": true,
        "locationTitle": "Конотопский район",
        "locationType": "raion",
        "startedAt": "2026-09-12T01:35:51.250Z",
        "updatedAt": "2026-09-12T01:57:51.136Z",
        "alertType": "airRaid",
        "locationOblast": "Сумська область",
        "locationOblastUid": 117,
        "alertLevel": "red",
        "threats": [
          {
            "threatType": "drones",
            "level": "yellow",
            "startedAt": "2026-09-12T01:35:51.250Z",
            "sourceMessage": "Дронова загроза (жовтий рівень)",
            "customMessage": "Дроны/БПЛА"
          },
          {
            "threatType": "unspecifiedMissiles",
            "level": "red",
            "startedAt": "2026-09-12T01:57:48.315Z",
            "sourceMessage": "Ракетна загроза (червоний рівень)",
            "customMessage": "Ракетная угроза"
          }
        ],
        "listDistrict": []
      },
      {
        "uid": "118",
        "isAlert": true,
        "locationTitle": "Ахтырский район",
        "locationType": "raion",
        "startedAt": "2026-09-12T02:15:53.932Z",
        "updatedAt": "2026-09-12T02:15:56.863Z",
        "alertType": "airRaid",
        "locationOblast": "Сумська область",
        "locationOblastUid": 118,
        "alertLevel": "red",
        "threats": [
          {
            "threatType": "unspecifiedMissiles",
            "level": "red",
            "startedAt": "2026-09-12T02:15:53.932Z",
            "sourceMessage": "Ракетна загроза (червоний рівень)",
            "customMessage": "Ракетная угроза"
          }
        ],
        "listDistrict": []
      },
      {
        "uid": "116",
        "isAlert": true,
        "locationTitle": "Роменский район",
        "locationType": "raion",
        "startedAt": "2026-09-12T01:51:21.988Z",
        "updatedAt": "2026-09-12T01:57:51.192Z",
        "alertType": "airRaid",
        "locationOblast": "Сумська область",
        "locationOblastUid": 116,
        "alertLevel": "red",
        "threats": [
          {
            "threatType": "drones",
            "level": "yellow",
            "startedAt": "2026-09-12T01:51:21.988Z",
            "sourceMessage": "Дронова загроза (жовтий рівень)",
            "customMessage": "Дроны/БПЛА"
          },
          {
            "threatType": "unspecifiedMissiles",
            "level": "red",
            "startedAt": "2026-09-12T01:57:49.128Z",
            "sourceMessage": "Ракетна загроза (червоний рівень)",
            "customMessage": "Ракетная угроза"
          }
        ],
        "listDistrict": []
      },
      {
        "uid": "114",
        "isAlert": true,
        "locationTitle": "Сумской район",
        "locationType": "raion",
        "startedAt": "2026-09-12T01:35:51.740Z",
        "updatedAt": "2026-09-12T01:57:51.156Z",
        "alertType": "airRaid",
        "locationOblast": "Сумська область",
        "locationOblastUid": 114,
        "alertLevel": "red",
        "threats": [
          {
            "threatType": "drones",
            "level": "yellow",
            "startedAt": "2026-09-12T01:35:51.740Z",
            "sourceMessage": "Дронова загроза (жовтий рівень)",
            "customMessage": "Дроны/БПЛА"
          },
          {
            "threatType": "unspecifiedMissiles",
            "level": "red",
            "startedAt": "2026-09-12T01:57:49.260Z",
            "sourceMessage": "Ракетна загроза (червоний рівень)",
            "customMessage": "Ракетная угроза"
          }
        ],
        "listDistrict": []
      },
      {
        "uid": "115",
        "isAlert": true,
        "locationTitle": "Шосткинский район",
        "locationType": "raion",
        "startedAt": "2026-09-12T01:51:21.891Z",
        "updatedAt": "2026-09-12T01:57:51.173Z",
        "alertType": "airRaid",
        "locationOblast": "Сумська область",
        "locationOblastUid": 115,
        "alertLevel": "red",
        "threats": [
          {
            "threatType": "drones",
            "level": "yellow",
            "startedAt": "2026-09-12T01:51:21.891Z",
            "sourceMessage": "Дронова загроза (жовтий рівень)",
            "customMessage": "Дроны/БПЛА"
          },
          {
            "threatType": "unspecifiedMissiles",
            "level": "red",
            "startedAt": "2026-09-12T01:57:49.360Z",
            "sourceMessage": "Ракетна загроза (червоний рівень)",
            "customMessage": "Ракетная угроза"
          }
        ],
        "listDistrict": []
      }
    ]
  },
  {
    "uid": "21",
    "isAlert": false,
    "locationTitle": "Тернопольская область",
    "finishedAt": "2026-09-13T00:55:31.335500",
    "listDistrict": [
      {
        "uid": "120",
        "isAlert": false,
        "locationTitle": "Кременецкий район",
        "locationType": "raion",
        "finishedAt": "2026-09-13T01:14:43.560630",
        "alertLevel": "yellow",
        "threats": [
          {
            "threatType": "drones",
            "level": "yellow",
            "startedAt": "2026-09-12T21:19:51.802Z",
            "sourceMessage": "Дронова загроза (жовтий рівень)",
            "customMessage": "Дроны/БПЛА"
          }
        ],
        "listDistrict": []
      },
      {
        "uid": "119",
        "isAlert": false,
        "locationTitle": "Тернопольский район",
        "locationType": "raion",
        "finishedAt": "2026-09-13T01:14:43.560657",
        "alertLevel": "yellow",
        "threats": [
          {
            "threatType": "drones",
            "level": "yellow",
            "startedAt": "2026-09-12T21:19:51.755Z",
            "sourceMessage": "Дронова загроза (жовтий рівень)",
            "customMessage": "Дроны/БПЛА"
          }
        ],
        "listDistrict": []
      },
      {
        "uid": "121",
        "isAlert": false,
        "locationTitle": "Чортковский район",
        "locationType": "raion",
        "finishedAt": "2026-09-13T01:14:43.560684",
        "alertLevel": "yellow",
        "threats": [
          {
            "threatType": "drones",
            "level": "yellow",
            "startedAt": "2026-09-12T21:19:51.612Z",
            "sourceMessage": "Дронова загроза (жовтий рівень)",
            "customMessage": "Дроны/БПЛА"
          }
        ],
        "listDistrict": []
      }
    ]
  },
  {
    "uid": "22",
    "isAlert": false,
    "locationTitle": "Харьковская область",
    "finishedAt": "2026-09-13T00:55:31.335502",
    "listDistrict": [
      {
        "uid": "125",
        "isAlert": false,
        "locationTitle": "Изюмский район",
        "locationType": "raion",
        "finishedAt": "2026-09-13T01:15:55.525759",
        "alertLevel": "yellow",
        "threats": [
          {
            "threatType": "drones",
            "level": "yellow",
            "startedAt": "2026-09-12T21:40:02.932Z",
            "sourceMessage": "Дронова загроза (жовтий рівень)",
            "customMessage": "Дроны/БПЛА"
          }
        ],
        "listDistrict": []
      },
      {
        "uid": "127",
        "isAlert": false,
        "locationTitle": "Берестинский район",
        "finishedAt": "2026-09-13T00:55:31.335502",
        "listDistrict": []
      },
      {
        "uid": "126",
        "isAlert": false,
        "locationTitle": "Богодуховский район",
        "finishedAt": "2026-09-13T00:55:31.335503",
        "listDistrict": []
      },
      {
        "uid": "123",
        "isAlert": false,
        "locationTitle": "Купянский район",
        "locationType": "raion",
        "finishedAt": "2026-09-13T01:15:55.525832",
        "alertLevel": "yellow",
        "threats": [
          {
            "threatType": "drones",
            "level": "yellow",
            "startedAt": "2026-09-12T21:22:38.615Z",
            "sourceMessage": "Дронова загроза (жовтий рівень)",
            "customMessage": "Дроны/БПЛА"
          }
        ],
        "listDistrict": []
      },
      {
        "uid": "128",
        "isAlert": false,
        "locationTitle": "Лозовский район",
        "locationType": "raion",
        "finishedAt": "2026-09-13T01:15:55.525857",
        "alertLevel": "yellow",
        "threats": [
          {
            "threatType": "drones",
            "level": "yellow",
            "startedAt": "2026-09-12T21:46:41.209Z",
            "sourceMessage": "Дронова загроза (жовтий рівень)",
            "customMessage": "Дроны/БПЛА"
          }
        ],
        "listDistrict": []
      },
      {
        "uid": "124",
        "isAlert": false,
        "locationTitle": "Харьковский район",
        "finishedAt": "2026-09-13T00:55:31.335503",
        "listDistrict": []
      },
      {
        "uid": "122",
        "isAlert": false,
        "locationTitle": "Чугуевский район",
        "locationType": "raion",
        "finishedAt": "2026-09-13T01:16:43.502112",
        "alertLevel": "red",
        "threats": [
          {
            "threatType": "unspecifiedMissiles",
            "level": "red",
            "startedAt": "2026-09-12T18:09:19.211Z",
            "sourceMessage": "Ракетна загроза (червоний рівень)",
            "customMessage": "Ракетная угроза"
          }
        ],
        "listDistrict": []
      }
    ]
  },
  {
    "uid": "23",
    "isAlert": false,
    "locationTitle": "Херсонская область",
    "finishedAt": "2026-09-13T00:55:31.335504",
    "listDistrict": [
      {
        "uid": "129",
        "isAlert": false,
        "locationTitle": "Бериславский район",
        "finishedAt": "2026-09-13T00:55:31.335505",
        "listDistrict": []
      },
      {
        "uid": "133",
        "isAlert": false,
        "locationTitle": "Генический район",
        "finishedAt": "2026-09-13T00:55:31.335505",
        "listDistrict": []
      },
      {
        "uid": "131",
        "isAlert": false,
        "locationTitle": "Каховский район",
        "finishedAt": "2026-09-13T00:55:31.335505",
        "listDistrict": []
      },
      {
        "uid": "130",
        "isAlert": false,
        "locationTitle": "Скадовский район",
        "finishedAt": "2026-09-13T00:55:31.335508",
        "listDistrict": []
      },
      {
        "uid": "132",
        "isAlert": false,
        "locationTitle": "Херсонский район",
        "finishedAt": "2026-09-13T00:55:31.335509",
        "listDistrict": []
      }
    ]
  },
  {
    "uid": "3",
    "isAlert": false,
    "locationTitle": "Хмельницкая область",
    "finishedAt": "2026-09-13T00:55:31.335509",
    "listDistrict": [
      {
        "uid": "135",
        "isAlert": false,
        "locationTitle": "Каменец-Подольский район",
        "finishedAt": "2026-09-13T00:55:31.335509",
        "listDistrict": []
      },
      {
        "uid": "134",
        "isAlert": false,
        "locationTitle": "Хмельницкий район",
        "locationType": "raion",
        "finishedAt": "2026-09-13T01:30:19.518596",
        "alertLevel": "yellow",
        "threats": [
          {
            "threatType": "drones",
            "level": "yellow",
            "startedAt": "2026-09-12T20:39:20.871Z",
            "sourceMessage": "Дронова загроза (жовтий рівень)",
            "customMessage": "Дроны/БПЛА"
          }
        ],
        "listDistrict": []
      },
      {
        "uid": "136",
        "isAlert": false,
        "locationTitle": "Шепетовский район",
        "locationType": "raion",
        "finishedAt": "2026-09-13T01:30:19.518622",
        "alertLevel": "yellow",
        "threats": [
          {
            "threatType": "drones",
            "level": "yellow",
            "startedAt": "2026-09-12T22:13:02.776Z",
            "sourceMessage": "Дронова загроза (жовтий рівень)",
            "customMessage": "Дроны/БПЛА"
          }
        ],
        "listDistrict": []
      }
    ]
  },
  {
    "uid": "24",
    "isAlert": false,
    "locationTitle": "Черкасская область",
    "finishedAt": "2026-09-13T00:55:31.335511",
    "listDistrict": [
      {
        "uid": "150",
        "isAlert": false,
        "locationTitle": "Звенигородский район",
        "finishedAt": "2026-09-13T00:55:31.335511",
        "listDistrict": []
      },
      {
        "uid": "153",
        "isAlert": false,
        "locationTitle": "Золотоношский район",
        "finishedAt": "2026-09-13T00:55:31.335511",
        "listDistrict": []
      },
      {
        "uid": "151",
        "isAlert": false,
        "locationTitle": "Уманский район",
        "finishedAt": "2026-09-13T00:55:31.335511",
        "listDistrict": []
      },
      {
        "uid": "152",
        "isAlert": false,
        "locationTitle": "Черкасский район",
        "finishedAt": "2026-09-13T00:55:31.335512",
        "listDistrict": []
      }
    ]
  },
  {
    "uid": "26",
    "isAlert": false,
    "locationTitle": "Черновицкая область",
    "finishedAt": "2026-09-13T00:55:31.335512",
    "listDistrict": [
      {
        "uid": "138",
        "isAlert": false,
        "locationTitle": "Вижницкий район",
        "finishedAt": "2026-09-13T00:55:31.335512",
        "listDistrict": []
      },
      {
        "uid": "139",
        "isAlert": false,
        "locationTitle": "Днестровский район",
        "finishedAt": "2026-09-13T00:55:31.335513",
        "listDistrict": []
      },
      {
        "uid": "137",
        "isAlert": false,
        "locationTitle": "Черновицкий район",
        "finishedAt": "2026-09-13T00:55:31.335513",
        "listDistrict": []
      }
    ]
  },
  {
    "uid": "25",
    "isAlert": false,
    "locationTitle": "Черниговская область",
    "finishedAt": "2026-09-13T00:55:31.335514",
    "listDistrict": [
      {
        "uid": "144",
        "isAlert": true,
        "locationTitle": "Корюковский район",
        "locationType": "raion",
        "startedAt": "2026-09-12T01:21:14.032Z",
        "updatedAt": "2026-09-12T12:35:22.746Z",
        "alertType": "airRaid",
        "locationOblast": "Чернігівська область",
        "locationOblastUid": 144,
        "alertLevel": "red",
        "threats": [
          {
            "threatType": "drones",
            "level": "yellow",
            "startedAt": "2026-09-12T01:21:14.032Z",
            "sourceMessage": "Дронова загроза (жовтий рівень)",
            "customMessage": "Дроны/БПЛА"
          },
          {
            "threatType": "unspecifiedMissiles",
            "level": "red",
            "startedAt": "2026-09-12T12:35:13.627Z",
            "sourceMessage": "Ракетна загроза (червоний рівень)",
            "customMessage": "Ракетная угроза"
          }
        ],
        "listDistrict": []
      },
      {
        "uid": "141",
        "isAlert": true,
        "locationTitle": "Новгород-Северский район",
        "locationType": "raion",
        "startedAt": "2026-09-12T04:15:39.616Z",
        "updatedAt": "2026-09-12T12:35:22.854Z",
        "alertType": "airRaid",
        "locationOblast": "Чернігівська область",
        "locationOblastUid": 141,
        "alertLevel": "red",
        "threats": [
          {
            "threatType": "drones",
            "level": "yellow",
            "startedAt": "2026-09-12T04:15:39.616Z",
            "sourceMessage": "Дронова загроза (жовтий рівень)",
            "customMessage": "Дроны/БПЛА"
          },
          {
            "threatType": "unspecifiedMissiles",
            "level": "red",
            "startedAt": "2026-09-12T12:35:17.410Z",
            "sourceMessage": "Ракетна загроза (червоний рівень)",
            "customMessage": "Ракетная угроза"
          }
        ],
        "listDistrict": []
      },
      {
        "uid": "142",
        "isAlert": true,
        "locationTitle": "Нежинский район",
        "locationType": "raion",
        "startedAt": "2026-09-12T02:20:09.722Z",
        "updatedAt": "2026-09-12T12:35:22.814Z",
        "alertType": "airRaid",
        "locationOblast": "Чернігівська область",
        "locationOblastUid": 142,
        "alertLevel": "red",
        "threats": [
          {
            "threatType": "drones",
            "level": "yellow",
            "startedAt": "2026-09-12T02:20:09.722Z",
            "sourceMessage": "Дронова загроза (жовтий рівень)",
            "customMessage": "Дроны/БПЛА"
          },
          {
            "threatType": "unspecifiedMissiles",
            "level": "red",
            "startedAt": "2026-09-12T12:35:17.370Z",
            "sourceMessage": "Ракетна загроза (червоний рівень)",
            "customMessage": "Ракетная угроза"
          }
        ],
        "listDistrict": []
      },
      {
        "uid": "143",
        "isAlert": true,
        "locationTitle": "Прилукский район",
        "locationType": "raion",
        "startedAt": "2026-09-12T02:13:56.139Z",
        "updatedAt": "2026-09-12T12:35:22.761Z",
        "alertType": "airRaid",
        "locationOblast": "Чернігівська область",
        "locationOblastUid": 143,
        "alertLevel": "red",
        "threats": [
          {
            "threatType": "drones",
            "level": "yellow",
            "startedAt": "2026-09-12T02:13:56.139Z",
            "sourceMessage": "Дронова загроза (жовтий рівень)",
            "customMessage": "Дроны/БПЛА"
          },
          {
            "threatType": "unspecifiedMissiles",
            "level": "red",
            "startedAt": "2026-09-12T12:35:17.961Z",
            "sourceMessage": "Ракетна загроза (червоний рівень)",
            "customMessage": "Ракетная угроза"
          }
        ],
        "listDistrict": []
      },
      {
        "uid": "140",
        "isAlert": true,
        "locationTitle": "Черниговский район",
        "locationType": "raion",
        "startedAt": "2026-09-12T01:21:13.858Z",
        "updatedAt": "2026-09-12T12:35:22.724Z",
        "alertType": "airRaid",
        "locationOblast": "Чернігівська область",
        "locationOblastUid": 140,
        "alertLevel": "red",
        "threats": [
          {
            "threatType": "drones",
            "level": "yellow",
            "startedAt": "2026-09-12T01:21:13.858Z",
            "sourceMessage": "Дронова загроза (жовтий рівень)",
            "customMessage": "Дроны/БПЛА"
          },
          {
            "threatType": "unspecifiedMissiles",
            "level": "red",
            "startedAt": "2026-09-12T12:35:17.540Z",
            "sourceMessage": "Ракетна загроза (червоний рівень)",
            "customMessage": "Ракетная угроза"
          }
        ],
        "listDistrict": []
      }
    ]
  }
]
""";
