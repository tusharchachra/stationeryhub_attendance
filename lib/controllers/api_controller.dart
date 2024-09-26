import 'package:get/get.dart';
import 'package:stationeryhub_attendance/models/user_attendance_model.dart';

import '../helpers/api_service.dart';

class ApiController extends GetxController {
  RxList<UserAttendanceModel> attendanceList = <UserAttendanceModel>[].obs;
  var isLoading = true.obs;

  final ApiService apiService;

  ApiController(this.apiService);

  void fetchAttendance({int? empId, String? startDate, String? endDate}) async {
    isLoading.value = true;
    try {
      final records = await apiService.fetchAttendance(empId: empId);
      attendanceList.value = records;
      print('records=$records');
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
