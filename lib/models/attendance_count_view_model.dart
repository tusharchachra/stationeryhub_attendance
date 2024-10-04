import 'package:stationeryhub_attendance/models/attendance_count_model.dart';
import 'package:stationeryhub_attendance/models/users_model.dart';

class AttendanceCountViewModel {
  List<AttendanceCountModel> attendanceCount;
  final UsersModel user;

  AttendanceCountViewModel({required this.attendanceCount, required this.user});
  @override
  String toString() {
    // TODO: implement toString
    return '\n{$attendanceCount,$user}';
  }
}
