class TagModel {
  TagModel({required this.id, this.name, this.isCategory = true});

  int id;
  String? name;
  bool isCategory;

  factory TagModel.fromJson(Map<String, dynamic> json) => TagModel(
        id: json["id"],
        name: json["name"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
      };
}
