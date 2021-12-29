class ListChapterTitlesModel {
  ListChapterTitlesModel({
    required this.totalItems,
    required this.totalPages,
    required this.items,
  });

  int totalItems;
  int totalPages;
  List<ChapterTitleModel> items;

  factory ListChapterTitlesModel.fromJson(Map<String, dynamic> json) => ListChapterTitlesModel(
        totalItems: json["total_items"],
        totalPages: json["total_pages"],
        items: List<ChapterTitleModel>.from(json["items"].map((x) => ChapterTitleModel.fromJson(x))),
      );
}

class ChapterTitleModel {
  ChapterTitleModel({
    required this.id,
    this.link,
    this.chapTitle,
  });

  int id;
  String? link;
  String? chapTitle;

  factory ChapterTitleModel.fromJson(Map<String, dynamic> json) => ChapterTitleModel(
        id: json["id"],
        link: json["link"],
        chapTitle: json["chap_title"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "link": link,
        "chap_title": chapTitle,
      };
}
