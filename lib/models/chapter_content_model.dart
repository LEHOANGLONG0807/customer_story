class ChapterContentModel {
  ChapterContentModel({
    required this.id,
    this.title,
    this.content,
  });

  int id;
  String? title;
  String? content;

  factory ChapterContentModel.fromJson(Map<String, dynamic> json) => ChapterContentModel(
        id: json["id"],
        title: json["title"],
        content: json["content"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "title": title,
        "content": content,
      };
}
