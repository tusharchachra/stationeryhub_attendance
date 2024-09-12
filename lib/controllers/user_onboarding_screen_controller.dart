import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stationeryhub_attendance/models/user_type_enum.dart';

class UserOnboardingScreenController extends GetxController {
  Rx<TextEditingController> nameController = TextEditingController().obs;
  Rx<TextEditingController> phoneNumController = TextEditingController().obs;
  Rx<TextEditingController> userTypeController = TextEditingController().obs;

  var selectedUserType = UserType.employee.obs;
}
