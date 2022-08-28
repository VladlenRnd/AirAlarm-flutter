import 'dart:io';

import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';

import '../../service/download_service.dart';
import '../../tools/custom_color.dart';
import '../../tools/update_info.dart';
import '../main/main_screen.dart';

class DownloadScreen extends StatefulWidget {
  const DownloadScreen({Key? key}) : super(key: key);

  @override
  State<DownloadScreen> createState() => _DownloadScreenState();
}

class _DownloadScreenState extends State<DownloadScreen> {
  double valueLoadFile = 0;
  String mByteDownloadStr = "0.0";
  String mByteTotalStr = "0.0";

  @override
  void initState() {
    _initDownloadCallback();
    _runUpdate();
    super.initState();
  }

  void _initDownloadCallback() {
    DownloadService.downloadStatusCallback = (int percent, String mByteDownload, String mByteTotal) {
      setState(() {
        mByteDownloadStr = mByteDownload;
        mByteTotalStr = mByteTotal;
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
        child: Stack(
          alignment: AlignmentDirectional.center,
          children: [
            Positioned(
              child: Lottie.asset(
                'assets/lottie/download.json',
                width: 700,
                height: 700,
                frameRate: FrameRate(60),
              ),
            ),
            Positioned(
              child: Padding(
                padding: const EdgeInsets.only(top: 180),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "ЗАГРУЗКА ОБНОВЛЕНИЯ",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 21,
                        color: CustomColor.textColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Padding(padding: EdgeInsets.symmetric(vertical: 5)),
                    Text(
                      "Не закрывайте приложение",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 15,
                        color: CustomColor.textColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Padding(padding: EdgeInsets.symmetric(vertical: 10)),
                    Text(
                      "${mByteDownloadStr}MB / ${mByteTotalStr}MB",
                      style: TextStyle(
                        fontSize: 15,
                        color: CustomColor.textColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Padding(padding: EdgeInsets.symmetric(vertical: 7)),
                    ClipRRect(
                      borderRadius: const BorderRadius.all(Radius.circular(10)),
                      child: LinearProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(CustomColor.primaryGreen.withOpacity(0.8)),
                        color: CustomColor.primaryGreen,
                        backgroundColor: CustomColor.backgroundLight,
                        minHeight: 15,
                        value: valueLoadFile,
                      ),
                    )
                  ],
                ),
              ),
            )
          ],
        ));
  }

  Future<void> _runUpdate() async {
    Directory? tempDir = await getExternalStorageDirectory();
    Directory direct = Directory(tempDir!.path);

    if (!await direct.exists()) {
      await direct.create();
    }
    String _localPathAA = direct.path;

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

    await OpenFile.open(pathToFile, type: "application/vnd.android.package-archive");
    await Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => const MainScreen()), (route) => false);
  }
}
