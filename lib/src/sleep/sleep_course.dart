class SleepCourseModel {
  SleepCourseModel({
    required this.id,
    required this.title,
    required this.description,
    required this.thumbnail,
    required this.categoryId,
    required this.sleepCourse,
  });

  String id;
  String title;
  String description;
  String thumbnail;
  String categoryId;
  List<SleepCourseAudioSession> sleepCourse;

  factory SleepCourseModel.fromJson(Map<String, dynamic> json) =>
      SleepCourseModel(
        id: json["id"],
        title: json["title"],
        description: json["description"],
        thumbnail: json["thumbnail"],
        categoryId: json["category_id"],
        sleepCourse: List<SleepCourseAudioSession>.from(json["sleep_course"]
            .map((x) => SleepCourseAudioSession.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "title": title,
        "description": description,
        "thumbnail": thumbnail,
        "category_id": categoryId,
        "sleep_course": List<dynamic>.from(sleepCourse.map((x) => x.toJson())),
      };
}

class SleepCourseAudioSession {
  SleepCourseAudioSession({
    required this.id,
    required this.courseId,
    required this.audio,
    required this.image,
    required this.title,
    required this.description,
    required this.duration,
    this.color,
  });

  String id;
  String courseId;
  String audio;
  String image;
  String title;
  String description;
  String duration;
  String? color;

  factory SleepCourseAudioSession.fromJson(Map<String, dynamic> json) =>
      SleepCourseAudioSession(
          id: json["id"],
          courseId: json["course_id"],
          audio: json["audio"],
          image: json["image"],
          title: json["title"],
          description: json["description"],
          duration: json["duration"],
          color: json["color"]);

  Map<String, dynamic> toJson() => {
        "id": id,
        "course_id": courseId,
        "audio": audio,
        "image": image,
        "title": title,
        "description": description,
        "duration": duration
      };
}
