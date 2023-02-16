import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:intl/intl.dart';
import 'package:lazy_load_scrollview/lazy_load_scrollview.dart';
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
    List<News> listNews = [];
    return Scaffold(
        backgroundColor: CustomColor.background,
        appBar: AppBar(
          title: Row(children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text("Новости"),
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
              future: Connection.getNews(),
              builder: (BuildContext context, AsyncSnapshot<NewsResponce> snapshot) {
                if (snapshot.hasData) {
                  if (listNews.isEmpty) {
                    listNews = snapshot.data!.news;
                  }
                  return RefreshIndicator(
                      color: CustomColor.primaryGreen,
                      backgroundColor: CustomColor.background,
                      child: Padding(
                        padding: const EdgeInsets.only(top: 10),
                        child: LazyLoadScrollView(
                          isLoading: false,
                          scrollOffset: 200,
                          onEndOfPage: () async {
                            NewsResponce resp = await Connection.getUpdateNews(listNews.reversed.last.id);
                            setState(() {
                              listNews.insertAll(0, resp.news);
                            });
                          },
                          child: SingleChildScrollView(
                            child: Column(
                              children: listNews.reversed.map((e) {
                                return Column(
                                  children: [
                                    _buildCardNews(
                                        context,
                                        UiTools.getDateToDay(e.publishTime!, true) ?? DateFormat("dd/MM/yyyy : HH:mm").format(e.publishTime!),
                                        e.body,
                                        e.imageUrl),
                                    Container(height: 10, color: CustomColor.background),
                                  ],
                                );
                              }).toList(),
                            ),
                          ),
                        ),
                      ),
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

  Widget _buildImage(String img, List<String> urlList, BuildContext context) {
    return Center(
      child: GestureDetector(
        onTap: () => showFullScreanDialog(context, urlList),
        child: Image.network(
          img,
          height: 300,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) => const SizedBox.shrink(),
        ),
      ),
    );
  }

  Widget _buildCardNews(BuildContext context, String time, String body, List<String> urlImage) {
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
          if (urlImage.isNotEmpty)
            urlImage.length == 1
                ? _buildImage(urlImage[0], urlImage, context)
                : GridView.count(
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    crossAxisCount: 2,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                    children: urlImage.map((e) => _buildImage(e, urlImage, context)).toList(),
                  ),
          if (urlImage.isNotEmpty) const SizedBox(height: 15),
          Html(data: body),
          // Text(
          //   body,
          //   style: const TextStyle(fontSize: 19, letterSpacing: 0.87),
          // ),
          Container(
              alignment: Alignment.bottomRight,
              padding: const EdgeInsets.only(top: 10),
              child: Text(
                time,
                style: TextStyle(color: Colors.white.withOpacity(0.5)),
              )),
        ],
      ),
    );
  }
}

//Минут
//час

