import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stationeryhub_attendance/models/user_type_enum.dart';

class UserOnboardingScreenController extends GetxController {
  Rx<TextEditingController> nameController = TextEditingController().obs;
  Rx<TextEditingController> phoneNumController = TextEditingController().obs;
  Rx<TextEditingController> userTypeController = TextEditingController().obs;
  RxBool showUserTypeOptions = false.obs;
  FocusNode userTypeFocusNode = FocusNode();

  var selectedUserType = UserType.employee.obs;

  /* @override
  void onInit() {
    // TODO: implement onInit
    print('running init');
    userTypeFocusNode.addListener(() {
      if (userTypeFocusNode.hasFocus) {
        print('has focus');
        showUserTypeOptions.value = true;
        print('got focus');
      } else {
        showUserTypeOptions.value = false;
        print('lost focus');
      }
    });
    super.onInit();
  }*/

  @override
  void onReady() {
    // TODO: implement onReady
    super.onReady();
    userTypeFocusNode.addListener(() {
      if (userTypeFocusNode.hasFocus) {
        showUserTypeOptions.value = true;
      } else {
        showUserTypeOptions.value = false;
      }
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    userTypeFocusNode.dispose();
  }

  void invertShowUserTypeValue() {
    showUserTypeOptions.value = !showUserTypeOptions.value;
  }
}
