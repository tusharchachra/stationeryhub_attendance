import 'package:carousel_slider/carousel_controller.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stationeryhub_attendance/controllers/firebase_firestore_controller.dart';

import '../models/users_model.dart';
import 'attendance_card_controller.dart';

class AdminDashboardScreenController extends GetxController {
  //final AttendanceCardController attendanceCardController = Get.find();

  RxList<UsersModel> employeeList = <UsersModel>[].obs;

  Rx<DateTime> selectedDate = DateTime.now().obs;
  Rx<int> selectedMonth = DateTime.now().month.obs;
  Rx<int> selectedYear = DateTime.now().year.obs;
  Rx<int> selectedDay = DateTime.now().day.obs;

  /* Rx<int> selectedDate = DateTime.now().day.obs;
  Rx<int> selectedMonth = DateTime.now().month.obs;
  Rx<int> selectedYear = DateTime.now().year.obs;*/

  final Rx<CarouselSliderController> dateCarouselController =
      CarouselSliderController().obs;
  final Rx<CarouselSliderController> yearCarouselController =
      CarouselSliderController().obs;
  final Rx<CarouselSliderController> monthCarouselController =
      CarouselSliderController().obs;
  final FirebaseFirestoreController firestoreController = Get.find();

  Rx<String> pageTitle = ''.obs;
  Rx<String> pageSubTitle1 = ''.obs;
  Rx<String> pageSubTitle2 = ''.obs;

  /* List<DateTime> getCurrentMonthDates({required int month, required int year}) {
    final daysCount = DateUtils.getDaysInMonth(year, month);
    List<DateTime> days = [];
    for (int i = 1; i < daysCount + 1; i++) {
      */ /*var temp= DateFormat.yMMMd().format(DateTime(DateTime.now().year, DateTime.now().month, i));*/ /*
      days.add(DateTime(year, month, i));
    }
    return days;
  }*/

  @override
  onReady() async {
    employeeList.value = await firestoreController.getAllUsers();
    final AttendanceCardController attendanceCardController = Get.find();
    selectedDate.listen((date) async {
      await attendanceCardController.loadAttendance(startDate: (date));
    });
  }

  List<int> getCurrentMonthDates({required int month, required int year}) {
    final daysCount = DateUtils.getDaysInMonth(year, month);
    List<int> days = [];
    for (int i = 1; i < daysCount + 1; i++) {
      /*var temp= DateFormat.yMMMd().format(DateTime(DateTime.now().year, DateTime.now().month, i));*/
      days.add(i);
    }
    return days;
  }

  void setDate() {
    if (selectedYear.value > DateTime.now().year) {
      selectedYear.value = selectedDate.value.year;
    }

    if (selectedYear.value == DateTime.now().year) {
      if (selectedMonth.value > DateTime.now().month) {
        selectedMonth.value = DateTime.now().month;
        selectedDay.value = DateTime.now().day;
      }
      if (selectedMonth.value == DateTime.now().month) {
        if (selectedDay.value > DateTime.now().day) {
          selectedDay.value = DateTime.now().day;
        }
      }
    }
    selectedDate.value =
        DateTime(selectedYear.value, selectedMonth.value, selectedDay.value);
    if (kDebugMode) {
      debugPrint('selectedDate=$selectedDate');
      /*debugPrint(
          '${LoggerStackTrace.from(StackTrace.current)}selectedDate=$selectedDate');*/
    }
  }
}
