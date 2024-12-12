import 'package:stationeryhub_attendance/models/attendance_model.dart';
import 'package:stationeryhub_attendance/models/users_model.dart';

class AttendanceViewModel {
  List<AttendanceModel> attendance;
  final UsersModel user;

  AttendanceViewModel({required this.attendance, required this.user});
  @override
  String toString() {
    // TODO: implement toString
    return '\n{$attendance,$user}';
  }
}
