import 'package:hive/hive.dart';

part 'story_board_local_model.g.dart';

@HiveType(typeId: 1)
class StoryBoardLocalModel extends HiveObject {
  @HiveField(0)
  int id;
  @HiveField(1)
  String? title;
  @HiveField(2)
  String? thumbnail;
  @HiveField(3)
  int? chap;

  StoryBoardLocalModel({required this.id, this.title, this.thumbnail, this.chap});
}
