import 'package:cloud_firestore/cloud_firestore.dart';

CollectionReference userCollection =
    FirebaseFirestore.instance.collection('users');
CollectionReference emotionTrackerCollection =
    FirebaseFirestore.instance.collection('emotion_trackers');
CollectionReference notesCollection =
    FirebaseFirestore.instance.collection('notes');

// final Reference imgStorageRef = FirebaseStorage.instance.ref().child(
//       'uploads/users/${DateTime.now().microsecondsSinceEpoch.remainder(1000000)}',
//     );
