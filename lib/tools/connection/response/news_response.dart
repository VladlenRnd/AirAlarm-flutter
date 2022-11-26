import 'package:html/dom.dart';
import 'package:html/parser.dart';

class NewsResponce {
  final List<News> news;

  NewsResponce({required this.news});

  factory NewsResponce.fromHtml(String html) {
    List<News> result = [];

    Document document = parse(html);
    List<Element> element = document.getElementsByClassName("tgme_widget_message_wrap");
    for (Element news in element) {
      String id = "";
      String msg = "";
      List<String> img = [];
      DateTime? t;
      List<Element> elem;

      //*********** */
      elem = news.getElementsByClassName("text_not_supported_wrap");
      if (elem.isNotEmpty) {
        id = elem[0].attributes["data-post"].toString().replaceAll("Novoeizdanie/", "");
      }

      elem = news.getElementsByClassName("tgme_widget_message_text");
      if (elem.isNotEmpty) {
        msg = elem.last.innerHtml
            .replaceRange(elem.last.innerHtml.indexOf("Подписаться</a>"), null, ""); //  .replaceAll("Подписаться Прислать новость", "");
      }

      elem = news.getElementsByClassName("tgme_widget_message_photo_wrap");
      for (Element pik in elem) {
        String style = pik.attributes["style"].toString();
        img.add(style.substring(style.indexOf("https"), style.indexOf("')")));
      }
      elem = news.getElementsByTagName("time"); //n.getElementsByClassName("tgme_widget_message_date");
      for (Element e in elem) {
        if (e.className == "time") {
          t = DateTime.parse(e.attributes["datetime"].toString()).toLocal();
        }
      }

      result.add(News(id: id, body: msg, imageUrl: img, publishTime: t));
      //*********** */
    }
    return NewsResponce(news: result);
  }
}

class News {
  final String id;
  final String body;
  final List<String> imageUrl;
  final DateTime? publishTime;

  News({required this.id, required this.body, required this.imageUrl, required this.publishTime});
}
