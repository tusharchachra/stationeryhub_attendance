import 'package:get/get.dart';
import 'package:stationeryhub_attendance/helpers/api_service.dart';
import 'package:stationeryhub_attendance/models/attendance_count_model.dart';
import 'package:stationeryhub_attendance/models/attendance_count_view_model.dart';

import '../models/users_model.dart';
import 'firebase_firestore_controller.dart';

class EmployeeCardController extends GetxController {
  final ApiService apiService = ApiService();
  final FirebaseFirestoreController firestoreController = Get.find();

  RxBool isLoading = false.obs;
  RxDouble present = 0.0.obs;

  // RxList<AttendanceCountModel> attendanceCount = <AttendanceCountModel>[].obs;
  RxList<AttendanceCountViewModel> attendanceCountViewList =
      <AttendanceCountViewModel>[].obs;

  //Rx<Map<String, dynamic>> displayData = Rx({});

  Future<void> loadAttendance(
      {String? empId, DateTime? startDate, DateTime? endDate}) async {
    isLoading.value = true;
    // List<UserAttendanceModel> records = [];
    List<AttendanceCountModel> records = [];
    attendanceCountViewList.clear();
    //attendanceList.clear();
    try {
      if (empId != null) {
        records = await apiService.fetchAttendanceCount(
            empId: empId,
            startDate: startDate,
            endDate: endDate,
            getCount: true);
      } else if (startDate != null) {
        //fetch all users from firestore
        List<UsersModel> userList = await firestoreController.getAllUsers();
        attendanceCountViewList.value = List.generate(
            userList.length,
            (index) => AttendanceCountViewModel(
                attendanceCount: [], user: userList[index]));

        //search for attendance of each user based on the empId on the date
        for (var user in userList) {
          records = await apiService.fetchAttendanceCount(
              empId: user.userId, startDate: startDate, endDate: endDate);
          print(records.toString());
          //assign the fetched attendanceCount to the attendanceCountViewList
          attendanceCountViewList
              .firstWhere((element) => element.user.userId == records[0].empId)
              .attendanceCount = records;
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
      print(e);
    } finally {}
    isLoading.value = false;
  }

  /* Future<void> loadAttendanceCount(String empId) async {
    isLoading.value = true;
    DateTime start = DateTime(DateTime.now().year, DateTime.now().month - 1, 1);
    attendanceCount.clear();
    present(0);

    ///TODO: remove (-1) from month
    DateTime end = DateTime(
        DateTime.now().year,
        DateTime.now().month - 1,
        DateUtils.getDaysInMonth(
            DateTime.now().year, DateTime.now().month - 1));
    var tempAttendanceCount = await apiService.fetchAttendanceCount(
        empId: empId, startDate: start, endDate: end, getCount: true);
    attendanceCount(tempAttendanceCount);
    print('$empId\n${attendanceCount.toString()}');
    for (var e in attendanceCount) {
      present.value += e.count;
    }
  }*/
}
