import 'dart:convert';

import 'package:alarm/service/firebase_config_service.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';

import '../../models/region_model.dart';
import '../mock_data.dart';

class Connection {
  static Future<Response> _get(Uri uri, {Map<String, String>? headers}) => http.get(uri, headers: headers).timeout(const Duration(seconds: 15));

  static final bool _isMockData = false;

  static List<RegionModel> lastUpdateRegion = [];

  static Future<List<RegionModel>> getAllAlert() async {
    if (_isMockData) {
      return (jsonDecode(alertJson) as List).map((item) => RegionModel.fromJson(item)).toList();
    }

    final response = await _get(Uri.parse("${Config.baseUrl}/getAlert"));
    if (response.statusCode == 200) {
      lastUpdateRegion = (jsonDecode(utf8.decode(response.bodyBytes)) as List).map((item) => RegionModel.fromJson(item)).toList();
      return lastUpdateRegion;
    } else {
      throw Exception('Failed to load alarms');
    }
  }
}
