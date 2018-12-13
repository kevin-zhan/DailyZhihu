import 'dart:async';
import 'model.dart';
import 'network_repo.dart';

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