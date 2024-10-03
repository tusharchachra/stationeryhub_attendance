import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stationeryhub_attendance/helpers/api_service.dart';
import 'package:stationeryhub_attendance/models/user_attendance_model.dart';

class EmployeeCardController extends GetxController {
  final ApiService apiService = ApiService();
  RxBool isLoading = false.obs;

  RxList<AttendanceModel> attendance = <AttendanceModel>[].obs;
  Rx<Map<String, dynamic>> displayData = Rx({});

  Future<void> loadAttendance(String empId) async {
    isLoading.value = true;
    DateTime start = DateTime(DateTime.now().year, DateTime.now().month - 1, 1);
    DateTime end = DateTime(
        DateTime.now().year,
        DateTime.now().month - 1,
        DateUtils.getDaysInMonth(
            DateTime.now().year, DateTime.now().month - 1));
    var tempAttendance = await apiService.fetchAttendance(
        empId: empId, startDate: start, endDate: end);
    attendance(tempAttendance);
    var present = attendance.isLoading.value = false;
  }
}
