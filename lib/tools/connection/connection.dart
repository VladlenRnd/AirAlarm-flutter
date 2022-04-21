import 'dart:convert';

import 'package:alarm/tools/connection/response/alarm_response.dart';
import 'package:http/http.dart' as http;

class Conectrion {
  static Future<AlarmRespose> getAlarm() async {
    final response = await http.get(Uri.parse('https://emapa.fra1.cdn.digitaloceanspaces.com/statuses.json'));

    if (response.statusCode == 200) {
      return AlarmRespose.fromJson(jsonDecode(utf8.decode(response.bodyBytes)));
    } else {
      throw Exception('Failed to load alarms');
    }
  }

  static Future<AlarmRespose> chekUpdate() async {
    final response = await http.get(Uri.parse('https://emapa.fra1.cdn.digitaloceanspaces.com/statuses.json'));

    if (response.statusCode == 200) {
      return AlarmRespose.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to load alarms');
    }
  }
}
