import 'dart:async';
import 'package:http/http.dart' as http;
import 'model.dart';
import 'dart:convert';
class NetWorkRepo {
  static const String FETCH_NEWS_LIST = "https://news-at.zhihu.com/api/4/news/before/";
  static Future<List> requestNewsList(int offset) async {
    var reqUrl = FETCH_NEWS_LIST + constructOffsetParam(offset);
    var response = await http.get(reqUrl);

    StoryListModel storyListModel = StoryListModel.fromJson(jsonDecode(response.body));
    return storyListModel.stories;
  }

  static String constructOffsetParam(int offset) {
    var targetDate = DateTime.now();
    targetDate = targetDate.add(Duration(days: 1));
    targetDate = targetDate.subtract(Duration(days: offset));
    return "${targetDate.year}${targetDate.month}${targetDate.day}";
  }

}