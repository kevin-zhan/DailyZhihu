import 'package:flutter/material.dart';
import 'network_repo.dart';
import 'model.dart';
import 'view_model.dart';

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
    return Card(
      child: Text(story.title),
    );
  }

  Widget _buildLoadMoreView() {
    return Center(child: Text("加载中..."));
  }
}
