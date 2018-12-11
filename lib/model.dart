import 'package:json_annotation/json_annotation.dart';

part 'model.g.dart';

@JsonSerializable(nullable: false)
class StoryModel {
  final List<String> images;
  final String id;
  final String title;
  StoryModel({this.images, this.id, this.title});
  factory StoryModel.fromJson(Map<String, dynamic> json) => _$StoryModelFromJson(json);
  Map<String, dynamic> toJson() => _$StoryModelToJson(this);
}

@JsonSerializable(nullable: false)
class StoryListModel {
  final List<StoryModel> stories;
  StoryListModel(this.stories);
  factory StoryListModel.fromJson(Map<String, dynamic> json) => _$StoryListModelFromJson(json);
  Map<String, dynamic> toJson() => _$StoryListModelToJson(this);
}