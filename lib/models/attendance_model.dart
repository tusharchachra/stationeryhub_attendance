import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:stationeryhub_attendance/screens/mark_attendance_screen.dart';

class AttendanceModel {
  String? userId;
  DateTime? dateTime;

  /// Override marking attendance by Admin
  MarkedBy? markedBy;

  /// If overridden, when
  DateTime? markedAt;

  AttendanceModel({
    this.userId,
    this.dateTime,
    this.markedBy,
    this.markedAt,
  });

  factory AttendanceModel.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
    SnapshotOptions? options,
  ) {
    final data = snapshot.data();
    return AttendanceModel(
      userId: data?['userId'],
      dateTime: DateTime.parse(data!['dateTime'].toString()),
      markedBy: MarkedBy.values.byName(data['markedBy'].split('.').last),
      markedAt: DateTime.parse(data['markedAt'].toString()),
    );
  }

  AttendanceModel.fromJson(Map<String, dynamic> json)
      : userId =
            json['userId'].toString() == '' ? '' : json['userId'].toString(),
        dateTime = DateTime.parse(json['dateTime'].toString()),
        //json returns "MarkedBy.admin" hence splitting the string to get the exact enum
        markedBy = MarkedBy.values.byName(json['markedBy'].split('.').last),
        markedAt = DateTime.parse(json['markedAt'].toString());

  Map<String, dynamic> toJson() => {
        'userId': userId ?? 'null',
        'dateTime': dateTime?.toIso8601String(),
        'markedBy': markedBy.toString(),
        'markedAt': markedAt?.toIso8601String(),
      };

  @override
  String toString() {
    // TODO: implement toString
    return toJson().toString();
  }
}
