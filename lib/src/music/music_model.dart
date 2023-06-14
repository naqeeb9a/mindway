class MusicModel {
  MusicModel({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.duration,
    required this.image,
    required this.musicAudio,
    this.deletedAt,
    required this.createdAt,
    required this.updatedAt,
  });

  int id;
  String title;
  String subtitle;
  String duration;
  String image;
  String musicAudio;
  dynamic deletedAt;
  DateTime createdAt;
  DateTime updatedAt;

  factory MusicModel.fromJson(Map<String, dynamic> json) => MusicModel(
        id: json["id"],
        title: json["title"],
        subtitle: json["subtitle"],
        duration: json["duration"],
        image: json["image"],
        musicAudio: json["music_audio"],
        deletedAt: json["deleted_at"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "title": title,
        "subtitle": subtitle,
        "duration": duration,
        "image": image,
        "music_audio": musicAudio,
        "deleted_at": deletedAt,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
      };
}
