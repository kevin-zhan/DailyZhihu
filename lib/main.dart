import 'package:flutter/material.dart';
import 'model.dart';
import 'view_model.dart';
import 'package:flutter_image/network.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '知乎日报',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: '知乎日报'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  StoryListViewModel storyListViewModel = StoryListViewModel();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    storyListViewModel.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
        ),
        body: StreamBuilder<List<StoryModel>>(
            stream: storyListViewModel.outStoryList,
            builder: (context, snapshot) {
              List stories = snapshot.data;
              return RefreshIndicator(
                onRefresh: () {
                  return storyListViewModel.refreshStoryList();
                },
                child: ListView.builder(
                    itemCount: (stories?.length ?? 0) + 1,
                    itemBuilder: (context, index) {
                      if (index >= (stories?.length ?? 0)) {
                        storyListViewModel.loadNextPage();
                        return _buildLoadMoreView();
                      }
                      return _buildRow(stories[index]);
                    }),
              );
            }));
  }

  Widget _buildRow(StoryModel story) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => StoryContentPage(storyId: story.id)));
      },
      child: Card(
        child: Container(
          height: 90,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                width: 10,
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      height: 10,
                    ),
                    Text(
                      story.title,
                      softWrap: true,
                      textAlign: TextAlign.left,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                    ),
                  ],
                ),
              ),
              Center(
                child: Image(
                  image: NetworkImageWithRetry(story.images[0]),
                  height: 70,
                  width: 70,
                ),
              ),
              Container(
                width: 10,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLoadMoreView() {
    return Center(child: Text("加载中..."));
  }
}

class StoryContentPage extends StatefulWidget {
  final int storyId;

  StoryContentPage({Key key, @required int storyId})
      : storyId = storyId,
        super(key: key);

  @override
  State<StatefulWidget> createState() => _StoryContentPageState(storyId);
}

class _StoryContentPageState extends State<StoryContentPage> {
  final StoryContentViewModel storyContentViewModel;

  _StoryContentPageState(int storyId)
      : storyContentViewModel = StoryContentViewModel(storyId),
        super();

  @override
  void initState() {
    super.initState();
    storyContentViewModel.fetchStoryContent();
  }

  @override
  void dispose() {
    super.dispose();
    storyContentViewModel.dispose();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
      appBar: AppBar(
        title: StreamBuilder(
            stream: storyContentViewModel.outStoryTitle,
            builder: (context, snapshot) {
              var title = snapshot.data;
              return Text(title == null ? "加载中..." : title);
            }),
      ),
      body: StreamBuilder(
          stream: storyContentViewModel.outStoryHtml,
          builder: (context, snapshot) {
            var html = snapshot.data;
            if (html != null) {
              return _buildStoryContent(context, html);
            } else {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
          }));

  Widget _buildStoryContent(BuildContext context, String html) =>
      WebviewScaffold(
          withJavascript: true,
          withZoom: false,
          allowFileURLs: false,
          url: Uri.dataFromString(html,
              mimeType: 'text/html',
              parameters: {'charset': "utf-8"}).toString());
}
