class HomeAudioSleepModel {
  int id;

  String title;
  String audio;
  String duration;

  String image;


  HomeAudioSleepModel({
   required this.id,

    required  this.title,
    required  this.audio,
    required  this.duration,

    required  this.image,

  });

  factory HomeAudioSleepModel.fromJson(Map<String, dynamic> json) => HomeAudioSleepModel(
    id: json['id'] as int,

    title: json['title'] as String,
    audio: json['audio'] as String,
    duration: json['duration'] as String,

    image: json['image'] as String,

  );

  Map<String, dynamic> toJson() => {
    "id": id,


    "title": title ?? '-',
    "audio": audio ?? '-',
    "duration": duration ?? '0 min',

    "image": image ?? '',

  };

}
