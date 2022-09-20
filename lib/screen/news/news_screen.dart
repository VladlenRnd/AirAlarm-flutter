import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';

import '../../dialog/full_screan_dialog.dart';
import '../../tools/connection/connection.dart';
import '../../tools/connection/response/news_response.dart';
import '../../tools/custom_color.dart';
import '../../tools/ui_tools.dart';

class NewsScreen extends StatelessWidget {
  const NewsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: CustomColor.background,
        appBar: AppBar(
          title: Row(children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text("События за сутки"),
                Text(
                  DateFormat('dd.MM.yyyy').format(DateTime.now()),
                  style: const TextStyle(fontSize: 14, color: Colors.grey),
                )
              ],
            ),
            // const SizedBox(width: 10),
            // const Text("beta", style: TextStyle(fontSize: 10, color: CustomColor.red))
          ]),
          backgroundColor: CustomColor.backgroundLight,
        ),
        body: StatefulBuilder(
          builder: (BuildContext context, setState) {
            return FutureBuilder<NewsResponce>(
              future: Conectrion.getNews(),
              builder: (BuildContext context, AsyncSnapshot<NewsResponce> snapshot) {
                if (snapshot.hasData) {
                  return RefreshIndicator(
                      color: CustomColor.primaryGreen,
                      backgroundColor: CustomColor.background,
                      child: Padding(
                          padding: const EdgeInsets.only(top: 10),
                          child: SingleChildScrollView(
                            child: Column(
                              children: snapshot.data!.news.map((e) {
                                return Column(
                                  children: [
                                    _buildCardNews(context, e.time, e.body, e.imgUrl),
                                    Container(height: 10, color: CustomColor.background),
                                  ],
                                );
                              }).toList(),
                            ),
                          )),
                      onRefresh: () async => setState(() {}));
                }

                return Center(
                  child: Lottie.asset(
                    'assets/lottie/load.json',
                    width: 180,
                    height: 180,
                    frameRate: FrameRate(60),
                  ),
                );
              },
            );
          },
        ));
  }

  Widget _buildCardNews(BuildContext context, String time, String body, String urlImage) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 24),
      margin: const EdgeInsets.symmetric(horizontal: 5),
      decoration: BoxDecoration(
        color: CustomColor.backgroundLight,
        borderRadius: BorderRadius.circular(5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 15),
          Text(
            body,
            style: const TextStyle(fontSize: 19, letterSpacing: 0.87),
          ),
          if (urlImage.isNotEmpty) const SizedBox(height: 15),
          if (urlImage.isNotEmpty)
            Center(
                child: GestureDetector(
              onTap: () => showFullScreanDialog(context, urlImage),
              child: Image.network(
                urlImage,
                height: 300,
                fit: BoxFit.fill,
                errorBuilder: (context, error, stackTrace) => const SizedBox.shrink(),
              ),
            )),
          Container(
              alignment: Alignment.bottomRight,
              padding: const EdgeInsets.only(top: 10),
              child: Text(
                _getTextCurrent(time),
                style: TextStyle(color: Colors.white.withOpacity(0.5)),
              )),
        ],
      ),
    );
  }
}

String _getTextCurrent(String time) {
  int number = int.parse(time.replaceAll(RegExp(r'[^0-9]'), ''));

  if (time.toLowerCase().contains("минут")) {
    return "$number ${UiTools.declinationWordByNumber(number, "минуту", "минуты", "минут")} назад";
  }
  if (time.toLowerCase().contains("час")) {
    return "$number ${UiTools.declinationWordByNumber(number, "час", "часа", "часов")} назад";
  }

  return time;
}

//Минут
//час

