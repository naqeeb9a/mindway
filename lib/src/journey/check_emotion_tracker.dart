import 'package:cloud_firestore/cloud_firestore.dart';

Future<int> checkEmotionTracked(String email) async {
  final CollectionReference collection =
  FirebaseFirestore.instance.collection('emotion_trackers');

  final DocumentSnapshot document = await collection.doc(email).get();

  if (document.exists) {
    final List<Map<String, dynamic>> records =
    List<Map<String, dynamic>>.from(document['emotion_days']);

    if (records.isNotEmpty) {
      bool todayRecordExists = false;
      DateTime today = DateTime.now();
      DateTime todayDate = DateTime(today.year, today.month, today.day);

      for (var record in records) {
        Timestamp recordTimestamp = record['date'];
        DateTime recordDate = recordTimestamp.toDate();

        if (isSameDate(recordDate, todayDate)) {
          todayRecordExists = true;
          break;
        }
      }

      if (todayRecordExists) {
        return 1;
      } else {
        return 0;
      }
    }
  }

  return 0;
}

bool isSameDate(DateTime date1, DateTime date2) {
  return date1.year == date2.year &&
      date1.month == date2.month &&
      date1.day == date2.day;
}
