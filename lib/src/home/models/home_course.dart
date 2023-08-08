// ignore_for_file: non_constant_identifier_names

class HomeCourseSessionModel {
  int id;
  String session_id;
  String audio_title;
  String audio;
  String duration;
  String course_title;
  String course_thumbnail;


  HomeCourseSessionModel({
   required this.id,
    required  this.session_id,
    required  this.audio_title,
    required  this.audio,
    required  this.duration,
    required  this.course_title,
    required  this.course_thumbnail,

  });

  factory HomeCourseSessionModel.fromJson(Map<String, dynamic> json) => HomeCourseSessionModel(
    id: json['id'] as int,
    session_id: json['session_id'] as String ,
    audio_title: json['audio_title'] as String,
    audio: json['audio'] as String,
    duration: json['duration'] as String,
    course_title: json['course_title'] as String,
    course_thumbnail: json['course_thumbnail'] as String,

  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "session_id": session_id,

    "audio_title": audio_title,
    "audio": audio  ,
    "duration": duration  ,
    "course_title": course_title  ,
    "course_thumbnail": course_thumbnail  ,

  };

}
