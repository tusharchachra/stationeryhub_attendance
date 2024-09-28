import 'package:get/get.dart';
import 'package:stationeryhub_attendance/controllers/firebase_firestore_controller.dart';
import 'package:stationeryhub_attendance/models/attendance_view_model.dart';
import 'package:stationeryhub_attendance/models/user_attendance_model.dart';
import 'package:stationeryhub_attendance/models/users_model.dart';

import '../helpers/api_service.dart';

class AttendanceCardController extends GetxController {
  final FirebaseFirestoreController firestoreController = Get.find();
  final ApiService apiService = ApiService();

  RxList<AttendanceViewModel> attendanceViewList = <AttendanceViewModel>[].obs;
  RxBool isLoading = false.obs;

/*  Future<UsersModel?> getUser(String empId) async {
    print(empId);
    var user = (await firestoreController.getUser(uid: empId));
    return user;
  }*/

  Future<void> loadAttendance(
      {int? empId, DateTime? startDate, String? endDate}) async {
    isLoading.value = true;
    // List<UserAttendanceModel> records = [];
    List<AttendanceModel> records = [];
    attendanceViewList.clear();
    //attendanceList.clear();
    try {
      if (empId != null) {
        records = await apiService.fetchAttendance(empId: empId);
      } else if (startDate != null) {
        records = await apiService.fetchAttendance(startDate: startDate);
      }
      for (var record in records) {
        print(record.empId);
        UsersModel? userRecord =
            await firestoreController.getUser(uid: record.empId);
        attendanceViewList
            .add(AttendanceViewModel(attendance: record, user: userRecord!));
      }
      // attendanceViewList.value = records;
      //print('records=$records');
    } catch (e) {
      // Handle error
      print(e);
    } finally {}
    isLoading.value = false;
  }

  /* void createAttendance(Attendance attendance) async {
    final success = await apiService.createAttendance(attendance);
    if (success) {
      attendanceList.add(attendance); // Update the local list
    }
  }*/
}
