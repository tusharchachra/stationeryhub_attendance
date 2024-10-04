import 'package:flutter/material.dart';
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

  //RxList<AttendanceCountModel> attendanceCount = <AttendanceCountModel>[].obs;
  RxList<AttendanceCountViewModel> attendanceCountViewList =
      <AttendanceCountViewModel>[].obs;

  //Rx<Map<String, dynamic>> displayData = Rx({});

  Future<void> loadAttendanceCount(
      {String? empId, DateTime? startDate, DateTime? endDate}) async {
    isLoading.value = true;
    DateTime? start;
    DateTime? end;
    // List<UserAttendanceModel> records = [];
    List<AttendanceCountModel> records = [];
    //attendanceCountViewList.clear();
    //attendanceList.clear();

    //fetch all users from firestore
    List<UsersModel> userList = await firestoreController.getAllUsers();
    attendanceCountViewList.value = List.generate(
        userList.length,
        (index) => AttendanceCountViewModel(
            attendanceCount: [], user: userList[index]));

    //check if dates are set. if not, we shall consider the current month from 1st to date
    ///TODO switch commented lines when live data is available in the db
    if (startDate == null) {
      /*start = DateTime(DateTime.now().year, DateTime.now().month, 1);*/
      start = DateTime(DateTime.now().year, DateTime.now().month - 1, 1);
    } else {
      start = startDate;
    }

    ///TODO switch commented lines when live data is available in the db
    if (endDate == null) {
      /*end = DateTime(
          DateTime.now().year,
          DateTime.now().month,
          DateTime.now().date);*/
      end = DateTime(
          DateTime.now().year,
          DateTime.now().month - 1,
          DateUtils.getDaysInMonth(
              DateTime.now().year, DateTime.now().month - 1));
    } else {
      end = endDate;
    }
    try {
      //get attendanceCount of each user based on the empId between the dates
      for (var user in userList) {
        records = await apiService.fetchAttendanceCount(
            empId: user.userId, startDate: start, endDate: end, getCount: true);
        print('records=${records.toString()}');

        //assign the fetched attendance to the attendanceViewList
        attendanceCountViewList
            .firstWhere((element) => element.user.userId == records[0].empId)
            .attendanceCount = records;
      }

      print('attendanceCountViewList=${attendanceCountViewList.toString()}');

      /* try {
      if (empId != null && startDate != null && endDate != null) {
        records = await apiService.fetchAttendanceCount(
            empId: empId,
            startDate: startDate,
            endDate: endDate,
            getCount: true);
        print('records from api=${records.toString()}');
      } else if (startDate != null) {*/
      //fetch all users from firestore
      /*List<UsersModel> userList = await firestoreController.getAllUsers();
        attendanceCountViewList.value = List.generate(
            userList.length,
            (index) => AttendanceCountViewModel(
                attendanceCount: [], user: userList[index]));*/

      //search for attendance of each user based on the empId on the date
      /*for (var user in userList) {
          records = await apiService.fetchAttendanceCount(
              empId: user.userId, startDate: startDate, endDate: endDate);

          //assign the fetched attendanceCount to the attendanceCountViewList
          attendanceCountViewList
              .firstWhere((element) => element.user.userId == records[0].empId)
              .attendanceCount = records;
        }*/

      //attendanceViewList.add(AttendanceViewModel(attendance: null, user: user));
      // }
      /*for (var record in records) {
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
}

/*Future<void> loadAttendanceCount(String empId) async {
    isLoading.value = true;
    attendanceCount.clear();
    present(0);
    DateTime start = DateTime(DateTime.now().year, DateTime.now().month - 1, 1);

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
  }
}*/
