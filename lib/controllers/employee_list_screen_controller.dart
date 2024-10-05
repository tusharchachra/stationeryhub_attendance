import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stationeryhub_attendance/controllers/employee_card_controller.dart';
import 'package:stationeryhub_attendance/controllers/firebase_firestore_controller.dart';
import 'package:stationeryhub_attendance/models/users_model.dart';

class EmployeeListScreenController extends GetxController {
  RxList<UsersModel> employeeList = <UsersModel>[].obs;
  RxBool isLoading = false.obs;
  static final FirebaseFirestoreController firestoreController = Get.find();
  static final EmployeeCardController employeeCardController = Get.find();

  Rx<Color> backgroundColor = Colors.white.obs;

  @override
  void onInit() async {
    // TODO: implement onReady
    super.onInit();
  }

  @override
  void onReady() async {
    // TODO: implement onReady
    super.onReady();
    isLoading.value = true;
    employeeList.value = await firestoreController.getAllUsers();
    await employeeCardController.loadAttendanceCount();
    isLoading.value = false;
  }
}
