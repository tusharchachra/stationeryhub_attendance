import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stationeryhub_attendance/controllers/firebase_firestore_controller.dart';
import 'package:stationeryhub_attendance/models/users_model.dart';

class EmployeeListScreenController extends GetxController {
  RxList<UsersModel> employeeList = <UsersModel>[].obs;
  static final FirebaseFirestoreController firestoreController = Get.find();

  Rx<Color> backgroundColor = Colors.white.obs;

  @override
  void onInit() async {
    // TODO: implement onReady
    super.onInit();
    employeeList.value = await firestoreController.getAllUsers();
  }
}
