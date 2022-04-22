import 'dart:io';

import 'package:flutter/foundation.dart';

class DownloadService {
  static String? filePath;

  static Function(int percent)? downloadStatusCallback;

  static int _getPercent(int total, int cumulative) {
    int onePercent = total ~/ 100;
    return cumulative ~/ onePercent;
  }

  static Future<String> downloadFile(String url, String fileName, String dir) async {
    HttpClient httpClient = HttpClient();
    File file;
    String filePath = '';

    try {
      var request = await httpClient.getUrl(Uri.parse(url));
      var response = await request.close();
      if (response.statusCode == 200) {
        var bytes = await consolidateHttpClientResponseBytes(
          response,
          onBytesReceived: (cumulative, total) {
            downloadStatusCallback?.call(_getPercent(total!, cumulative));
          },
        );
        filePath = '$dir/$fileName';
        file = File(filePath);
        await file.writeAsBytes(bytes);
      } else {
        filePath = "CODE_SERVER";
      }
    } catch (ex) {
      filePath = "EXEPTION";
    }

    return filePath;
  }
}
