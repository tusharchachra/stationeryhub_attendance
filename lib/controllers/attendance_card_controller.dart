import 'package:get/get.dart';
import 'package:stationeryhub_attendance/controllers/admin_dashboard_screen_controller.dart';
import 'package:stationeryhub_attendance/controllers/firebase_firestore_controller.dart';
import 'package:stationeryhub_attendance/models/attendance_model_old.dart';
import 'package:stationeryhub_attendance/models/attendance_view_model.dart';

import '../helpers/api_service.dart';

class AttendanceCardController extends GetxController {
  final FirebaseFirestoreController firestoreController = Get.find();
  final AdminDashboardScreenController adminDashboardScreenController =
      Get.find();
  final ApiService apiService = ApiService();

  RxList<AttendanceViewModel> attendanceViewList = <AttendanceViewModel>[].obs;
  RxBool isLoading = false.obs;

/*  Future<UsersModel?> getUser(String empId) async {
    print(empId);
    var user = (await firestoreController.getUser(uid: empId));
    return user;
  }*/

  Future<void> loadAttendance(
      {String? empId, DateTime? startDate, String? endDate}) async {
    isLoading.value = true;
    // List<UserAttendanceModel> records = [];
    List<AttendanceModelOld> records = [];
    attendanceViewList.clear();
    //attendanceList.clear();
    try {
      if (empId != null) {
        records = await apiService.fetchAttendance(empId: empId);
      } else if (startDate != null) {
        //fetch all users from firestore
        //List<UsersModel> userList = await firestoreController.getAllUsers();
        attendanceViewList.value = List.generate(
            adminDashboardScreenController.employeeList.length,
            (index) => AttendanceViewModel(
                attendance: [],
                user: adminDashboardScreenController.employeeList[index]));

        //search for attendance of each user based on the empId on the date
        for (var user in adminDashboardScreenController.employeeList) {
          records = await apiService.fetchAttendance(
              empId: user.userId, startDate: startDate);

          //assign the fetched attendance to the attendanceViewList
          attendanceViewList
              .firstWhere((element) => element.user.userId == records[0].empId)
              .attendance = records;
        }

        //attendanceViewList.add(AttendanceViewModel(attendance: null, user: user));
      }
      /* for (var record in records) {
        // print(record.empId);
        UsersModel? userRecord =
            await firestoreController.getUser(uid: record.empId);
        // print(userRecord);
        attendanceViewList
            .add(AttendanceViewModel(attendance: record, user: userRecord!));
      }*/
      // attendanceViewList.value = records;
      //print('records=$records');
    } catch (e) {
      // Handle error
      //print(LoggerStackTrace.from(StackTrace.current));
      print('Error: $e');
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
