import 'package:alarm/tools/region/eregion.dart';
import 'package:csv/csv.dart';
import 'package:flutter/foundation.dart';

import 'connection/connection.dart';
import 'region/region_title_tools.dart';

Map<ERegion, List<List<DateTime>>> allHistory = {};

Future<bool> getAllHistory() async {
  try {
    String data = await Connection.getHistoryAlarm();
    List<List<dynamic>> rowsAsListOfValues = const CsvToListConverter().convert(data);
    for (List<dynamic> element in rowsAsListOfValues) {
      ERegion? reg = RegionTitleTools.getERegionByUkrString(element[0]);
      if (reg != null && element[3] != "True") {
        if (allHistory[reg] == null) {
          allHistory[reg] = [
            [DateTime.parse(element[1]).toLocal(), DateTime.parse(element[2]).toLocal()]
          ];
        } else {
          allHistory[reg]!.add([DateTime.parse(element[1]).toLocal(), DateTime.parse(element[2]).toLocal()]);
        }
      }
    }
    return true;
  } catch (e) {
    if (kDebugMode) print("Error get History :$e");
    return false;
  }
}
