import 'dart:async';
import 'model.dart';
import 'network_repo.dart';
import 'story_renderer.dart';

class StoryListViewModel {
  var _storyListController = StreamController<StoryListModel>.broadcast();
  List<StoryModel> storyList = List();
  var offset = -1;

  Sink get inStoryListController => _storyListController;

  Stream<List<StoryModel>> get outStoryList => _storyListController.stream.map((stories) {
    storyList.addAll(stories.stories);
    return storyList;
  });

  refreshStoryList() async {
    offset = 0;
    storyList.clear();
    StoryListModel model = await NetWorkRepo.requestNewsList(offset);
    inStoryListController.add(model);
  }

  loadNextPage() async {
    offset++;
    StoryListModel model = await NetWorkRepo.requestNewsList(offset);
    inStoryListController.add(model);
  }

  depose() {
    _storyListController.close();
  }
}

class StoryContentViewModel {
  int storyId;

  StoryContentViewModel(this.storyId);

  var _storyContentController = StreamController<StoryContentModel>.broadcast();

  Sink get inStoryContentController => _storyContentController;

  Stream<StoryContentModel> get outStoryContent => _storyContentController.stream.map((storyContent) {
    return storyContent;
  });

  Stream<String> get outStoryTitle => _storyContentController.stream.map((storyContent) {
    if (storyContent == null) {
      return "加载中";
    }
    return storyContent.title;
  });

  Stream<String> get outStoryHtml => _storyContentController.stream.asyncMap((storyContent) {
    if (storyContent == null) {
      return "";
    }
    return makeStoryContextHtml(storyContent);

  });

  fetchStoryContent() async {
    StoryContentModel contentModel = await NetWorkRepo.requestNewsContent(storyId);
    inStoryContentController.add(contentModel);
  }

  depose() {
    _storyContentController.close();
  }

}