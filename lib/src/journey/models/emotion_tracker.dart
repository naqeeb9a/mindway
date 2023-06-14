import 'package:cloud_firestore/cloud_firestore.dart';

class EmotionTrackerFirebaseModel {
  EmotionTrackerFirebaseModel({
    required this.id,
    required this.name,
    required this.image,
    required this.date,
  });

  String id;
  String name;
  String image;
  Timestamp date;

  factory EmotionTrackerFirebaseModel.fromJson(Map<String, dynamic> json) =>
      EmotionTrackerFirebaseModel(
        id: json["id"],
        name: json["name"],
        image: json["image"],
        date: json["date"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "image": image,
        "date": date,
      };
}
