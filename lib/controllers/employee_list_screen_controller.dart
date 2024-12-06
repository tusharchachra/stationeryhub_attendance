import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stationeryhub_attendance/controllers/firebase_firestore_controller.dart';

import '../helpers/api_service.dart';
import '../models/attendance_count_model.dart';
import '../models/attendance_count_view_model.dart';

class EmployeeListScreenController extends GetxController {
  //RxList<UsersModel> employeeList = <UsersModel>[].obs;
  RxBool isLoading = false.obs;
  RxDouble present = 0.0.obs;
  final ApiService apiService = ApiService();

  RxList<AttendanceCountViewModel> attendanceCountViewList =
      <AttendanceCountViewModel>[].obs;
  //static final EmployeeCardController employeeCardController = Get.find();

  Rx<Color> backgroundColor = Colors.white.obs;

  @override
  void onInit() async {
    // TODO: implement onReady
    super.onInit();
  }

  static final FirebaseFirestoreController firestoreController = Get.find();
  /*static final AdminDashboardScreenController adminDashboardScreenController =
      Get.find();*/

  @override
  void onReady() async {
    // TODO: implement onReady
    super.onReady();
    isLoading.value = true;

    //await loadAttendanceCount();
    isLoading.value = false;
  }

  Future<void> refreshScreen() async {
    firestoreController.userList.value =
        await firestoreController.getAllUsers();
    //await loadAttendanceCount();
  }

  Future<void> loadAttendanceCount(
      {String? empId, DateTime? startDate, DateTime? endDate}) async {
    //isLoading.value = true;
    DateTime? start;
    DateTime? end;
    List<AttendanceCountModel> records = [];

    print('loading attendance');

    //fetch all users from firestore
    //List<UsersModel> userList = await firestoreController.getAllUsers();
    attendanceCountViewList.value = List.generate(
        firestoreController.userList.length,
        (index) => AttendanceCountViewModel(
            attendanceCountList: [],
            user: firestoreController.userList[index]));

    //check if dates are set. if not, we shall consider the current month from 1st to date
    ///TODO switch commented lines when live data is available in the db
    if (startDate == null) {
      start = DateTime(DateTime.now().year, DateTime.now().month, 1);
      /*start = DateTime(DateTime.now().year, DateTime.now().month - 1, 1);*/
    } else {
      start = startDate;
    }

    ///TODO switch commented lines when live data is available in the db
    if (endDate == null) {
      end = DateTime(
          DateTime.now().year, DateTime.now().month, DateTime.now().day);
      /*end = DateTime(
          DateTime.now().year,
          DateTime.now().month - 1,
          DateUtils.getDaysInMonth(
              DateTime.now().year, DateTime.now().month - 1));*/
    } else {
      end = endDate;
    }
    try {
      //get attendanceCount of each user based on the empId between the dates
      for (var user in firestoreController.userList) {
        records = await apiService.fetchAttendanceCount(
            empId: user.userId, startDate: start, endDate: end, getCount: true);
        print('records=${records.toString()}');
        if (records.isNotEmpty) {
          //assign the fetched attendance to the attendanceViewList
          attendanceCountViewList
              .firstWhere((element) => element.user.userId == records[0].empId)
              .attendanceCountList = records;

          //assigning presentCount
          for (var rec in records) {
            attendanceCountViewList
                .firstWhere(
                    (element) => element.user.userId == records[0].empId)
                .presentCount += rec.count;
          }
          attendanceCountViewList.refresh();
        }
      }

      print('attendanceCountViewList=${attendanceCountViewList.length}');
    } catch (e) {
      // Handle error
      print(e);
    } finally {}
    //isLoading.value = false;
  }
}
