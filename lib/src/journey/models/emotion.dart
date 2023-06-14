class EmotionModel {
  EmotionModel({
    required this.id,
    required this.name,
    required this.emoji,
    this.deletedAt,
    this.createdAt,
    this.updatedAt,
  });

  int id;
  String name;
  String emoji;
  dynamic deletedAt;
  dynamic createdAt;
  dynamic updatedAt;

  factory EmotionModel.fromJson(Map<String, dynamic> json) => EmotionModel(
        id: json["id"],
        name: json["name"],
        emoji: json["emoji"],
        deletedAt: json["deleted_at"],
        createdAt: json["created_at"] == null ? '' : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null ? '' : DateTime.parse(json["updated_at"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "emoji": emoji,
        "deleted_at": deletedAt,
        // "created_at": createdAt?.toIso8601String(),
        // "updated_at": updatedAt?.toIso8601String(),
      };
}
