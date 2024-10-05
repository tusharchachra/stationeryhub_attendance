import 'package:stationeryhub_attendance/models/attendance_count_model.dart';
import 'package:stationeryhub_attendance/models/users_model.dart';

class AttendanceCountViewModel {
  List<AttendanceCountModel> attendanceCountList;
  final UsersModel user;
  double presentCount;

  AttendanceCountViewModel(
      {required this.attendanceCountList,
      required this.user,
      this.presentCount = 0.0});
  @override
  String toString() {
    // TODO: implement toString
    return '\n{$attendanceCountList,$user}';
  }
}
