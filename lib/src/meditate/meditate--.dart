// ignore_for_file: file_names

class CourseModel {
  CourseModel({
    required this.courseTitle,
    this.courseDescription,
    required this.courseThumbnail,
    required this.courseDuration,
    this.sessions,
    this.sosAudio,
    this.color,
  });

  String courseTitle;
  String? courseDescription;
  String courseThumbnail;
  String courseDuration;
  List<CourseSession>? sessions;
  List<SosAudio>? sosAudio;
  String? color;

  factory CourseModel.fromJson(Map<String, dynamic> json) => CourseModel(
        courseTitle: json["course_title"],
        courseDescription: json["course_description"],
        courseThumbnail: json["course_thumbnail"],
        courseDuration: json["course_duration"],
        color: json["color"],
        sessions: json["sessions"] == null
            ? []
            : List<CourseSession>.from(
                json["sessions"].map((x) => CourseSession.fromJson(x))),
        sosAudio: json['sos_audio'] == null
            ? []
            : List<SosAudio>.from(
                json["sos_audio"].map((x) => SosAudio.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "course_title": courseTitle,
        "course_description": courseDescription,
        "course_thumbnail": courseThumbnail,
        "course_duration": courseDuration,
        "color": color,
      };

  @override
  String toString() {
    return toJson().toString();
  }
}

class CourseSession {
  CourseSession({
    required this.id,
    required this.courseId,
    required this.audioTitle,
    required this.audio,
    required this.duration,
  });

  String id;
  String courseId;
  String audioTitle;
  String audio;
  String? duration;

  factory CourseSession.fromJson(Map<String, dynamic> json) => CourseSession(
        id: json["id"],
        courseId: json["session_id"],
        audioTitle: json["audio_title"],
        audio: json["audio"],
        duration: json["duration"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "session_id": courseId,
        "audio_title": audioTitle,
        "audio": audio,
        "duration": duration,
      };
}

class SosAudio {
  SosAudio({
    required this.id,
    required this.audioTitle,
    required this.sosAudio,
  });

  String id;
  String audioTitle;
  String sosAudio;

  factory SosAudio.fromJson(Map<String, dynamic> json) => SosAudio(
        id: json["id"],
        audioTitle: json["audio_title"],
        sosAudio: json["sos_audio"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "audio_title": audioTitle,
        "sos_audio": sosAudio,
      };
}
