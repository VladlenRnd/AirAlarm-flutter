import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:http/http.dart';

import '../repository/config_repository.dart';
import 'response/alarm_response.dart';
import 'response/config_response.dart';
import 'response/news_response.dart';
import 'response/update_responce.dart';

class Connection {
  static Future<Response> _get(Uri uri) => http.get(uri).timeout(const Duration(seconds: 15));

  static Future<ConfigResponse> getRemoteConfig() async {
    final response = await _get(Uri.parse('https://raw.githubusercontent.com/VladlenRnd/AirAlarm-flutter/dev/apks/config.json'));

    if (response.statusCode == 200) {
      return ConfigResponse.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to load config JSON');
    }
  }

  static Future<AlarmRespose> getAlarm() async {
    final response = await _get(Uri.parse(ConfigRepository.instance.config.urlAlarm));

    if (response.statusCode == 200) {
      return AlarmRespose.fromJson(jsonDecode(utf8.decode(response.bodyBytes)));
    } else {
      throw Exception('Failed to load alarms');
    }
  }

  static Future<UpdateResposeOld> chekUpdate() async {
    final response = await _get(Uri.parse(ConfigRepository.instance.config.urlUpdate));

    if (response.statusCode == 200) {
      return UpdateResposeOld.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to load update JSON');
    }
  }

  static Future<String> getHistoryAlarm() async {
    final response = await _get(Uri.parse(ConfigRepository.instance.config.urlHistory));

    if (response.statusCode == 200) {
      return response.body;
    } else {
      throw Exception('Failed to load History Alarm JSON');
    }
  }

  static Future<NewsResponce> getNews() async {
    final response = await _get(Uri.parse('https://t.me/s/Novoeizdanie/'));

    if (response.statusCode == 200) {
      return NewsResponce.fromHtml(response.body);
    } else {
      throw Exception('Failed to load news');
    }
  }

  static Future<NewsResponce> getUpdateNews(String id) async {
    final response = await _get(Uri.parse('https://t.me/s/Novoeizdanie?before=$id'));

    if (response.statusCode == 200) {
      return NewsResponce.fromHtml(response.body);
    } else {
      throw Exception('Failed to load news');
    }
  }
}
