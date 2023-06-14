class SleepDedicatedAudio {
  SleepDedicatedAudio({
    required this.id,
    required this.audioTitle,
    required this.sleepAudio,
    required this.image,
    required this.duration,
  });

  int id;
  String audioTitle;
  String sleepAudio;
  String image;
  String duration;

  factory SleepDedicatedAudio.fromJson(Map<String, dynamic> json) => SleepDedicatedAudio(
        id: json["id"],
        audioTitle: json["audio_title"],
        sleepAudio: json["sleep_audio"],
        image: json["image"],
        duration: json["duration"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "audio_title": audioTitle,
        "sleep_audio": sleepAudio,
        "image": image,
        "duration": duration,
      };
}
