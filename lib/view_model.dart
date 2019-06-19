import 'dart:async';
import 'model.dart';
import 'network_repo.dart';
import 'story_renderer.dart';

abstract class BaseViewModel<T> {
  var _dataSourceController = StreamController<T>.broadcast();

  Sink get inputData => _dataSourceController;

  Stream get outputData => _dataSourceController.stream;

  dispose() {
    _dataSourceController.close();
  }
}

class StoryListViewModel extends BaseViewModel<StoryListModel> {
  List<StoryModel> storyList = List();
  var offset = -1;

  Stream<List<StoryModel>> get outStoryList => outputData.map((stories) {
        storyList.addAll(stories.stories);
        return storyList;
      });

  refreshStoryList() async {
    offset = 0;
    storyList.clear();
    StoryListModel model = await NetWorkRepo.requestNewsList(offset);
    inputData.add(model);
  }

  loadNextPage() async {
    offset++;
    StoryListModel model = await NetWorkRepo.requestNewsList(offset);
    inputData.add(model);
  }
}

class StoryContentViewModel extends BaseViewModel<StoryContentModel> {
  int storyId;

  StoryContentViewModel(this.storyId);

  Stream<StoryContentModel> get outStoryContent =>
      outputData.map((storyContent) {
        return storyContent;
      });

  Stream<String> get outStoryTitle => outputData.map((storyContent) {
        if (storyContent == null) {
          return "加载中";
        }
        return storyContent.title;
      });

  Stream<String> get outStoryHtml => outputData.asyncMap((storyContent) {
        if (storyContent == null) {
          return "";
        }
        return makeStoryContextHtml(storyContent);
      });

  fetchStoryContent() async {
    StoryContentModel contentModel =
        await NetWorkRepo.requestNewsContent(storyId);
    inputData.add(contentModel);
  }
}