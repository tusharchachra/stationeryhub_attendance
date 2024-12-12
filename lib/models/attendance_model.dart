import 'package:stationeryhub_attendance/screens/mark_attendance_screen.dart';

class AttendanceModel {
  DateTime? dateTime;
  MarkedBy? markedBy;

  AttendanceModel({this.dateTime, this.markedBy});

  Map<String, dynamic> toJson() => {
        'dateTime': dateTime,
        'markedBy': markedBy,
      };

  AttendanceModel.fromJson(Map<String, dynamic> json)
      : dateTime = DateTime.parse(json.keys.first.toString()),
        markedBy = MarkedBy.values
            .byName(json.values.first.toString().split('.').last);

  /* factory AttendanceModel.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
    SnapshotOptions? options,
  ) {
    final data = snapshot.data();
    return AttendanceModel(
      dateTime:
          data?.keys.
      markedBy: data['markedBy'] != null
          ? MarkedBy.values.byName(data['markedBy'].split('.').last)
          : null,
    );
  }*/

  @override
  String toString() {
    // TODO: implement toString
    return toJson().toString();
  }
}
