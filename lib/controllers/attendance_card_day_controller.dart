import 'package:get/get.dart';
import 'package:stationeryhub_attendance/controllers/firebase_firestore_controller.dart';

import '../models/attendance_model.dart';
import '../models/attendance_view_model.dart';
import 'admin_dashboard_screen_controller.dart';

class AttendanceCardDayController extends GetxController {
  final AdminDashboardScreenController adminDashboardScreenController =
      Get.find();
  final FirebaseFirestoreController firestoreController = Get.find();
  /* final ApiService apiService = ApiService();*/

  RxList<AttendanceViewModel> attendanceViewList = <AttendanceViewModel>[].obs;
  RxList<AttendanceModel> attendanceRecords = <AttendanceModel>[].obs;
  RxBool isLoading = false.obs;
  String empId = '';

/*  Future<UsersModel?> getUser(String empId) async {
    print(empId);
    var user = (await firestoreController.getUser(uid: empId));
    return user;
  }*/

  @override
  void onReady() async {
    // TODO: implement onReady
    super.onReady();
    //await att();
  }

  Future<void> att() async {
    attendanceViewList.clear();
    for (var user in firestoreController.userList) {
      var att = await firestoreController.fetchAttendanceDay(
          userId: user.userId!,
          date: adminDashboardScreenController.selectedDate.value);
      attendanceViewList.add(AttendanceViewModel(attendance: att, user: user));
    }
    print('attendanceViewList=$attendanceViewList');
  }

  Future<void> loadAttendance(
      {String? empId, DateTime? startDate, String? endDate}) async {
    isLoading.value = true;

    // List<UserAttendanceModel> attendanceRecords = [];

    //attendanceViewList.clear();
    //attendanceList.clear();
    try {
      if (empId != null) {
        //attendanceRecords = await apiService.fetchAttendance(empId: empId);
      }
      /*else if (startDate != null) */ {
        //fetch all users from firestore
        //List<UsersModel> userList = await firestoreController.getAllUsers();

        //  attendanceRecords(att);
        // print(att);
        /*attendanceRecords.value = List.generate(
            firestoreController.userList.length,
            (index) => AttendanceViewModel(
                attendance: att, user: firestoreController.userList[index]));
        print(attendanceViewList);*/
        /* await firestoreController.fetchAttendanceDay(
            userId: empId!, date: startDate);*/

        //search for attendance of each user based on the empId on the date
        /*  for (var user in adminDashboardScreenController.employeeList) {
          attendanceRecords = await firestoreController.fetchAttendanceDay(
              userId: empId!, date: startDate);

          //assign the fetched attendance to the attendanceViewList
          attendanceViewList.attendance = attendanceRecords;
        }*/

        //attendanceViewList.add(AttendanceViewModel(attendance: null, user: user));
      }
      /* for (var record in attendanceRecords) {
        // print(record.empId);
        UsersModel? userRecord =
            await firestoreController.getUser(uid: record.empId);
        // print(userRecord);
        attendanceViewList
            .add(AttendanceViewModel(attendance: record, user: userRecord!));
      }*/
      // attendanceViewList.value = attendanceRecords;
      //print('attendanceRecords=$attendanceRecords');
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
