import 'package:get/get.dart';
import 'package:stationeryhub_attendance/models/user_attendance_model.dart';

import '../helpers/db_service.dart';

class AttendanceController extends GetxController {
  var attendanceList = <UserAttendanceModel>[].obs;
  var isLoading = true.obs;

  final ApiService apiService;

  AttendanceController(this.apiService);

  void fetchAttendance(
      {int? userId, String? startDate, String? endDate}) async {
    isLoading.value = true;
    try {
      final records = await apiService.fetchAttendance(
          userId: userId, startDate: startDate, endDate: endDate);
      attendanceList.value = records;
    } catch (e) {
      // Handle error
      print(e);
    } finally {
      isLoading.value = false;
    }
  }

  /* void createAttendance(Attendance attendance) async {
    final success = await apiService.createAttendance(attendance);
    if (success) {
      attendanceList.add(attendance); // Update the local list
    }
  }*/
}
