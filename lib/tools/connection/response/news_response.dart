import 'package:html/dom.dart';
import 'package:html/parser.dart';

class NewsResponce {
  final List<News> news;

  NewsResponce({required this.news});

  factory NewsResponce.fromHtml(String html) {
    List<News> result = [];

    Document document = parse(html);
    List<Element> element = document.getElementById("feedler")!.children;
    for (Element s in element) {
      List<Element> img = s.getElementsByTagName("img");
      String image = img.isNotEmpty ? img[0].attributes["src"]! : "";

      result
          .add(News(time: s.getElementsByClassName("date_add")[0].text, body: s.getElementsByClassName("title")[0].nodes.last.text!, imgUrl: image));
    }
    return NewsResponce(news: result);
  }
}

class News {
  final String time;
  final String body;

  final String imgUrl;

  News({required this.time, required this.body, required this.imgUrl});
}
