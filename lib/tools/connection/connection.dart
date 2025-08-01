import 'dart:convert';

import 'package:alarm/service/firebase_config_service.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';

import '../../models/region_model.dart';

class Connection {
  static Future<Response> _get(Uri uri, {Map<String, String>? headers}) => http.get(uri, headers: headers).timeout(const Duration(seconds: 15));

  static Future<List<RegionModel>> getAllAlert() async {
    final response = await _get(Uri.parse("${Config.baseUrl}/getAlert"));

    if (response.statusCode == 200) {
      return (jsonDecode(utf8.decode(response.bodyBytes)) as List).map((item) => RegionModel.fromJson(item)).toList();
    } else {
      throw Exception('Failed to load alarms');
    }
  }
}
