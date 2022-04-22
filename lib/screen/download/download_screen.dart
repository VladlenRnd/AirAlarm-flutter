import 'dart:io';

import 'package:alarm/screen/main/tools/color.dart';
import 'package:flutter/material.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';

import '../../service/download_service.dart';
import '../../tools/update_info.dart';
import '../main/main_screen.dart';

class DownloadScreen extends StatefulWidget {
  const DownloadScreen({Key? key}) : super(key: key);

  @override
  State<DownloadScreen> createState() => _DownloadScreenState();
}

class _DownloadScreenState extends State<DownloadScreen> {
  double valueLoadFile = 0;

  @override
  void initState() {
    _initDownloadCallback();
    _runUpdate();
    super.initState();
  }

  void _initDownloadCallback() {
    DownloadService.downloadStatusCallback = (int percent) {
      setState(() {
        valueLoadFile = percent * 0.01;
      });
    };
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        child: Scaffold(
          backgroundColor: CustomColor.background,
          body: _buildBody(),
        ),
        onWillPop: () async => false);
  }

  Widget _buildBody() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            "ЗАГРУЗКА ОБНОВЛЕНИЯ",
            style: TextStyle(
              fontSize: 23,
              color: CustomColor.textColor,
              fontWeight: FontWeight.bold,
            ),
          ),
          const Padding(padding: EdgeInsets.symmetric(vertical: 5)),
          Text(
            "Не закрывайте приложение",
            style: TextStyle(
              fontSize: 15,
              color: CustomColor.textColor,
              fontWeight: FontWeight.bold,
            ),
          ),
          const Padding(padding: EdgeInsets.symmetric(vertical: 15)),
          ClipRRect(
            borderRadius: const BorderRadius.all(Radius.circular(10)),
            child: LinearProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(CustomColor.primaryGreen),
              color: CustomColor.primaryGreen,
              backgroundColor: CustomColor.backgroundLight,
              minHeight: 15,
              value: valueLoadFile,
            ),
          )
        ],
      ),
    );
  }

  Future<void> _runUpdate() async {
    Directory? tempDir = await getExternalStorageDirectory();
    Directory dd = Directory(tempDir!.path);

    if (!await dd.exists()) {
      await dd.create();
    }
    String _localPathAA = dd.path;

    String pathToFile = await DownloadService.downloadFile(UpdateInfo.infoUpdate.url, "flightAlarmUpdate.apk", _localPathAA);

    if (pathToFile == "EXEPTION") {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Ошибка загрузки обновления")));
      await Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => const MainScreen()), (route) => false);
      return;
    }
    if (pathToFile == "CODE_SERVER") {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Ошибка Сервера")));
      await Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => const MainScreen()), (route) => false);
      return;
    }

    OpenFile.open(pathToFile, type: "application/vnd.android.package-archive");
    await Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => const MainScreen()), (route) => false);
  }
}
