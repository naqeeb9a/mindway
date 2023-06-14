import 'package:cloud_firestore/cloud_firestore.dart';

class NoteModel {
  String? date;
  String? notes;

  NoteModel({
    required this.date,
    required this.notes,
  });

  factory NoteModel.fromFirestore(DocumentSnapshot snap) {
    Map d = snap.data() as Map<dynamic, dynamic>;
    return NoteModel(
      date: d['date'],
      notes: d['notes'],
    );
  }

  static Map<String, dynamic> getMap(NoteModel d) {
    return {
      'date': d.date,
      'notes': d.notes,
    };
  }
}
