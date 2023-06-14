class LinkModel {
  LinkModel({
    required this.id,
    required this.urlName,
    required this.title,
    required this.subTitle,
    required this.icon,
    this.deletedAt,
    required this.createdAt,
    required this.updatedAt,
  });

  int id;
  String urlName;
  String title;
  String subTitle;
  String icon;
  String? deletedAt;
  DateTime createdAt;
  DateTime updatedAt;

  factory LinkModel.fromJson(Map<String, dynamic> json) => LinkModel(
        id: json["id"],
        urlName: json["url_name"],
        title: json["title"],
        subTitle: json["sub_title"],
        icon: json["icon"],
        deletedAt: json["deleted_at"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "url_name": urlName,
        "title": title,
        "sub_title": subTitle,
        "icon": icon,
        "deleted_at": deletedAt,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
      };
}
