import 'dart:convert';

import 'package:alarm/tools/connection/response/alarm_response.dart';
import 'package:alarm/tools/connection/response/news_response.dart';
import 'package:http/http.dart' as http;

import 'response/update_responce.dart';

class Conectrion {
  static Future<AlarmRespose> getAlarm() async {
    final response = await http.get(Uri.parse('https://emapa.fra1.cdn.digitaloceanspaces.com/statuses.json'));

    if (response.statusCode == 200) {
      return AlarmRespose.fromJson(jsonDecode(utf8.decode(response.bodyBytes)));
    } else {
      throw Exception('Failed to load alarms');
    }
  }

  static Future<UpdateRespose> chekUpdate() async {
    final response = await http.get(Uri.parse('https://raw.githubusercontent.com/VladlenRnd/AirAlarm-flutter/dev/apks/update.json'));

    if (response.statusCode == 200) {
      return UpdateRespose.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to load update JSON');
    }
  }

  static Future<NewsResponce> getNews() async {
    final response = await http.get(Uri.parse('https://liveuamap.com/ru'));

    if (response.statusCode == 200) {
      return NewsResponce.fromHtml(response.body);
    } else {
      throw Exception('Failed to load news');
    }

    //String sdf = element.children

    // return AlarmRespose.fromJson(jsonDecode(utf8.decode(response.bodyBytes)));
  }
}
