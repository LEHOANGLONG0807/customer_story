import 'package:hive/hive.dart';
import 'package:truyen_chu/models/models.dart';

part 'story_history_local_model.g.dart';

@HiveType(typeId: 0)
class StoryHistoryLocalModel extends HiveObject {
  StoryHistoryLocalModel({
    required this.id,
    this.title,
    this.thumbnail,
    this.chap,
    this.authorName,
    required this.chapterId,
    required this.pageIndex,
  });
  @HiveField(0)
  int id;
  @HiveField(1)
  String? title;
  @HiveField(2)
  String? thumbnail;
  @HiveField(3)
  int? chap;
  @HiveField(4)
  String? authorName;
  @HiveField(5)
  int chapterId;
  @HiveField(6)
  int pageIndex;

  factory StoryHistoryLocalModel.fromJson(Map<String, dynamic> json) => StoryHistoryLocalModel(
        id: json["id"],
        title: json["title"],
        thumbnail: json["thumbnail"],
        chap: json["chap"],
        chapterId: json["chapter_id"],
        pageIndex: json["page_index"],
        authorName: json["author_name"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "title": title,
        "thumbnail": thumbnail,
        "chap": chap,
        "chapter_id": chapterId,
        "page_index": pageIndex,
        "author_name": authorName,
      };

  StoryBoardLocalModel get toStoryBoardLocalModel => StoryBoardLocalModel(id: this.id, title: this.title, thumbnail: this.thumbnail, chap: this.chap);
}
