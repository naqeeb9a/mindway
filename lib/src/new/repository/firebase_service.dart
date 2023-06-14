import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:mindway/src/new/models/note_model.dart';

class FirebaseService {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  Future<NoteModel?> getNoteByDate(String date) async {
    NoteModel? data;
    String dbDate = date.replaceAll("-", "_");
    await firestore
        .collection('notes')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection(dbDate)
        .doc("note")
        .get()
        .then((value) {
      if (value.data() != null) {
        data = NoteModel.fromFirestore(value);
      }
    });

    return data;
  }
}
