import 'package:cloud_firestore/cloud_firestore.dart';

class FavoriteModel {
  String? id;
  String? type; //Normal and Sleep
  String? course;
  String? session;
  String? title;
  String? audio;
  String? image;
  String? color;

  FavoriteModel(
      {required this.type,
      required this.id,
      required this.course,
      required this.session,
      required this.title,
      required this.audio,
      required this.image,
      required this.color});

  factory FavoriteModel.fromJson(Map<String, dynamic> json) => FavoriteModel(
      id: json['id'],
      type: json['type'],
      course: json['course'],
      session: json['session'],
      title: json['title'],
      audio: json['audio'],
      image: json['image'],
      color: json['color']);

  Map<String, dynamic> toJson() => {
        'id': id,
        'type': type,
        'course': course,
        'session': session,
        'title': title,
        'audio': audio,
        'image': image,
        'color': color,
      };

  factory FavoriteModel.fromFirestore(DocumentSnapshot snap) {
    Map d = snap.data() as Map<dynamic, dynamic>;
    return FavoriteModel(
        id: d['id'],
        type: d['type'],
        course: d['course'],
        session: d['session'],
        title: d['title'],
        audio: d['audio'],
        image: d['image'],
        color: d['color']);
  }

  static Map<String, dynamic> getMap(FavoriteModel d) {
    return {
      'id': d.id,
      'type': d.type,
      'course': d.course,
      'session': d.session,
      'title': d.title,
      'audio': d.audio,
      'image': d.image,
      'color': d.color,
    };
  }
}
