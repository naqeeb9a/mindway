class SingleMeditationAudio {
  SingleMeditationAudio({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.duration,
    required this.image,
    required this.singleAudio,
    this.deletedAt,
    required this.createdAt,
    required this.updatedAt,
    this.color,
  });

  int id;
  String title;
  String subtitle;
  String duration;
  String image;
  String singleAudio;
  dynamic deletedAt;
  DateTime createdAt;
  DateTime updatedAt;
  String? color;

  factory SingleMeditationAudio.fromJson(Map<String, dynamic> json) =>
      SingleMeditationAudio(
          id: json["id"],
          title: json["title"],
          subtitle: json["subtitle"],
          duration: json["duration"],
          image: json["image"],
          singleAudio: json["single_audio"],
          deletedAt: json["deleted_at"],
          createdAt: DateTime.parse(json["created_at"]),
          updatedAt: DateTime.parse(json["updated_at"]),
          color: json["color"]);

  Map<String, dynamic> toJson() => {
        "id": id,
        "title": title,
        "subtitle": subtitle,
        "duration": duration,
        "image": image,
        "single_audio": singleAudio,
        "deleted_at": deletedAt,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
      };
}
