import 'package:alarm/tools/region/eregion.dart';
import 'package:csv/csv.dart';

import 'connection/connection.dart';
import 'region/region_title_tools.dart';

Map<ERegion, List<List<String>>> allHistory = {};

Future<void> getAllHistory() async {
  String data = await Conectrion.getHistoryAlarm();
  try {
    List<List<dynamic>> rowsAsListOfValues = const CsvToListConverter().convert(data);
    for (List<dynamic> element in rowsAsListOfValues) {
      ERegion? reg = RegionTitleTools.getERegionByUkrString(element[0]);
      if (reg != null) {
        if (allHistory[reg] == null) {
          allHistory[reg] = [
            [element[1], element[2]]
          ];
        } else {
          allHistory[reg]!.add([element[1], element[2]]);
        }
      }
    }
  } catch (e) {
    print("Error get History :$e");
  }
}
