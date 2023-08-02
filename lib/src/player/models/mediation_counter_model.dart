class MediationCounter {
  final String email;
  final List<Map<String, dynamic>> records;

  MediationCounter({required this.email, required this.records});

  factory MediationCounter.fromMap(Map<String, dynamic> map) {
    return MediationCounter(
      email: map['email'],
      records: List<Map<String, dynamic>>.from(map['records']),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'email': email,
      'records': records,
    };
  }
}
// class MediationCounter {
//   String email;
//   int time_count_in_minutes;
//   DateTime date;
//   String mediationType;
//
//   MediationCounter({
//     required this.email,
//     required this.time_count_in_minutes,
//     required this.date,
//     required this.mediationType,
//   });
//
//   Map<String, dynamic> toMap() {
//     return {
//       'email': email,
//       'time_count_in_minutes': time_count_in_minutes,
//       'date': Timestamp.fromDate(date),
//       'mediation_type': mediationType,
//     };
//   }
//
//   factory MediationCounter.fromMap(Map<String, dynamic> map) {
//     return MediationCounter(
//       email: map['email'],
//       time_count_in_minutes: map['time_count_in_minutes'],
//       date: (map['date'] as Timestamp).toDate(),
//       mediationType: map['mediation_type'],
//     );
//   }
// }
