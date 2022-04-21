import 'dart:convert';

import 'package:alarm/src/tools/connection/responce/alarm_responce.dart';
import 'package:http/http.dart' as http;

class Conectrion {
  static Future<Alarm> getAlarm() async {
    final response = await http.get(Uri.parse('https://emapa.fra1.cdn.digitaloceanspaces.com/statuses.json'));

    if (response.statusCode == 200) {
      return Alarm.fromJson(jsonDecode(utf8.decode(response.bodyBytes)));
    } else {
      throw Exception('Failed to load alarms');
    }
  }
}
