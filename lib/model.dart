import 'package:json_annotation/json_annotation.dart';

part 'model.g.dart';

@JsonSerializable(nullable: false)
class StoryModel {
  final List<String> images;
  final int id;
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

@JsonSerializable()
class StoryContentModel {
  final int id;
  final int type;
  final String title;
  final String body;
  final List<String> js;
  final List<String> css;
  final String share_url;
  final List recommenders;
  final String ga_prefix;
  final String image_source;
  final String image;
  final List<String> images;

  StoryContentModel(
      {this.id,
        this.type,
        this.title,
        this.body,
        this.js,
        this.css,
        this.share_url,
        this.recommenders,
        this.ga_prefix,
        this.image_source,
        this.image,
        this.images});


  factory StoryContentModel.fromJson(Map<String, dynamic> json) => _$StoryContentModelFromJson(json);

  Map<String, dynamic> toJson() => _$StoryContentModelToJson(this);
}