class JournalModel {
  JournalModel({
    required this.id,
    required this.email,
    required this.title,
    required this.description,
    required this.date,
    this.deletedAt,
    required this.createdAt,
    required this.updatedAt,
    required this.emoji,
  });

  String id;
  String email;
  String title;
  String description;
  String date;
  dynamic deletedAt;
  DateTime createdAt;
  DateTime updatedAt;
  List<JournalEmoji> emoji;

  factory JournalModel.fromJson(Map<String, dynamic> json) => JournalModel(
        id: json["id"],
        email: json["email"],
        title: json["title"],
        description: json["description"],
        date: json["date"],
        deletedAt: json["deleted_at"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
        emoji: List<JournalEmoji>.from(json["emoji"].map((x) => JournalEmoji.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "email": email,
        "title": title,
        "description": description,
        "date": date,
        "deleted_at": deletedAt,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
        "emoji": List<dynamic>.from(emoji.map((x) => x.toJson())),
      };
}

class JournalEmoji {
  JournalEmoji({
    required this.journalId,
    required this.emojiName,
    this.emojiImage,
  });

  String journalId;
  String emojiName;
  dynamic emojiImage;

  factory JournalEmoji.fromJson(Map<String, dynamic> json) => JournalEmoji(
        journalId: json["journal_id"],
        emojiName: json["emoji_name"],
        emojiImage: json["emoji_image"],
      );

  Map<String, dynamic> toJson() => {
        "journal_id": journalId,
        "emoji_name": emojiName,
        "emoji_image": emojiImage,
      };
}
