import 'dart:async';
import 'package:http/http.dart' as http;
import 'model.dart';
import 'dart:convert';


class NetWorkRepo {
  static const String FETCH_NEWS_LIST =
      "https://news-at.zhihu.com/api/4/news/before/";

  static Future<StoryListModel> requestNewsList(int offset) async {
    var reqUrl = FETCH_NEWS_LIST + constructOffsetParam(offset);
    print("=======================");
    print(reqUrl);
    var response = await http.get(reqUrl);
    print(response.body);
    print("=======================");
    StoryListModel storyListModel =
        StoryListModel.fromJson(jsonDecode(response.body));
    return storyListModel;
  }

  static String constructOffsetParam(int offset) {
    var targetDate = DateTime.now();
    targetDate = targetDate.add(Duration(days: 1));
    targetDate = targetDate.subtract(Duration(days: offset));
    return "${targetDate.year}${_fixParam(targetDate.month)}${_fixParam(targetDate.day)}";
  }

  static String _fixParam(int time) {
    String timeStr = time.toString();
    timeStr = timeStr.length > 1 ? timeStr : "0" + timeStr;
    return timeStr;
  }

  static Future<StoryContentModel> requestNewsContent(int newsId) async {
    final response =
        await http.get("https://news-at.zhihu.com/api/4/news/$newsId");
    var content = StoryContentModel.fromJson(json.decode(response.body));
    return content;
  }
}
