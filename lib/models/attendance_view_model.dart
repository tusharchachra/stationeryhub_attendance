import 'package:stationeryhub_attendance/models/user_attendance_model.dart';
import 'package:stationeryhub_attendance/models/users_model.dart';

class AttendanceViewModel {
  final AttendanceModel attendance;
  final UsersModel user;

  AttendanceViewModel({required this.attendance, required this.user});
}
