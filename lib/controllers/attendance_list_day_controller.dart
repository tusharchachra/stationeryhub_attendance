import 'package:get/get.dart';
import 'package:stationeryhub_attendance/controllers/firebase_firestore_controller.dart';

import '../models/attendance_model.dart';
import '../models/attendance_view_model.dart';
import 'admin_dashboard_screen_controller.dart';

class AttendanceListDayController extends GetxController {
  final AdminDashboardScreenController adminDashboardScreenController =
      Get.find();
  final FirebaseFirestoreController firestoreController = Get.find();

  RxList<AttendanceViewModel> attendanceViewList = <AttendanceViewModel>[].obs;
  RxList<AttendanceModel> attendanceRecords = <AttendanceModel>[].obs;
  RxBool isLoading = false.obs;
  String empId = '';

  Future<void> loadAttendance() async {
    isLoading(true);
    attendanceViewList.clear();
    for (var user in firestoreController.userList) {
      var att = await firestoreController.fetchAttendanceDay(
          userId: user.userId!,
          date: adminDashboardScreenController.selectedDate.value);
      attendanceViewList.add(AttendanceViewModel(attendance: att, user: user));
    }
    print('attendanceViewList=$attendanceViewList');
    isLoading(false);
  }
}
