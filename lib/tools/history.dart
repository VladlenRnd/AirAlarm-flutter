import 'package:alarm/tools/region/eregion.dart';
import 'package:csv/csv.dart';
import 'package:flutter/foundation.dart';

import 'connection/connection.dart';
import 'region/region_title_tools.dart';

Map<ERegion, List<List<String>>> allHistory = {};

Future<bool> getAllHistory() async {
  try {
    String data = await Connection.getHistoryAlarm();
    List<List<dynamic>> rowsAsListOfValues = const CsvToListConverter().convert(data);
    for (List<dynamic> element in rowsAsListOfValues) {
      ERegion? reg = RegionTitleTools.getERegionByUkrString(element[0]);
      if (reg != null && element[3] != "True") {
        if (allHistory[reg] == null) {
          allHistory[reg] = [
            [element[1], element[2]]
          ];
        } else {
          allHistory[reg]!.add([element[1], element[2]]);
        }
      }
    }
    return true;
  } catch (e) {
    if (kDebugMode) print("Error get History :$e");
    return false;
  }
}
