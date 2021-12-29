import 'models.dart';

class StoryModel {
  StoryModel({
    required this.id,
    this.title,
    this.aliasTitle,
    this.thumbnail,
    this.chap,
    this.isFull,
    this.isHot,
    this.isNew,
    this.star,
    this.totalRate,
    this.totalRead,
    this.totalCmt,
    this.listTag,
    this.authorId,
    this.authorName,
    this.desc,
    this.myRate,
  });

  int id;
  String? title;
  String? aliasTitle;
  String? thumbnail;
  int? chap;
  bool? isFull;
  bool? isHot;
  bool? isNew;
  double? star;
  int? totalRate;
  int? myRate;
  int? totalRead;
  int? totalCmt;
  List<TagModel>? listTag;
  int? authorId;
  String? authorName;
  String? desc;

  factory StoryModel.fromJson(Map<String, dynamic> json) => StoryModel(
        id: json["id"],
        title: json["title"],
        aliasTitle: json["alias_title"],
        thumbnail: json["thumbnail"],
        chap: json["chap"],
        isFull: json["is_full"],
        isHot: json["is_hot"],
        isNew: json["is_new"],
        myRate: json["my_rate"],
        star: json["star"].toDouble(),
        totalRate: json["total_rate"],
        totalRead: json["total_read"],
        totalCmt: json["total_cmt"],
        listTag: List<TagModel>.from(json["list_tag"].map((x) => TagModel.fromJson(x))),
        authorId: json["author_id"],
        authorName: json["author_name"],
        desc: json["desc"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "title": title,
        "alias_title": aliasTitle,
        "thumbnail": thumbnail,
        "chap": chap,
        "is_full": isFull,
        "is_hot": isHot,
        "is_new": isNew,
        "star": star,
        "my_rate": myRate,
        "total_rate": totalRate,
        "total_read": totalRead,
        "total_cmt": totalCmt,
        "list_tag": List<dynamic>.from((listTag ?? []).map((x) => x.toJson())),
        "author_id": authorId,
        "author_name": authorName,
        "desc": desc,
      };

  StoryBoardLocalModel get toStoryBroadLocalModel => StoryBoardLocalModel(id: id, title: title, thumbnail: thumbnail, chap: chap);
}
