import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stationeryhub_attendance/screens/screen_otp.dart';

import 'firebase_auth_controller.dart';
import 'firebase_firestore_controller.dart';

class ScreenLoginNewController extends GetxController {
  final formKey = GlobalKey<FormState>();
  //Rx<TextEditingController> phoneNumController = TextEditingController().obs;
  RxBool isPhoneNumValid = false.obs;
  RxBool isLoading = false.obs;
  RxString phoneNum = ('').obs;
  final FocusNode focusNode = FocusNode();
  static FirebaseAuthController authController = Get.find();
  static FirebaseFirestoreController firestoreController = Get.find();

  validatePhoneNum(String? value) {
    /*if (value == '7808814341') {
      return null;
    } else*/

    phoneNum = RxString(value!.trim());
    if (value == null) {
      isPhoneNumValid.value = false;
      return null;
    } else if (value.length == 10) {
      isPhoneNumValid.value = true;
      return null;
    } else if (value.length < 10) {
      isPhoneNumValid.value = false;
      return 'Invalid phone number';
    } else {
      isPhoneNumValid.value = false;
      return 'Unauthorised user';
    }
  }

  Future onLogin() async {
    isLoading.value = true;
    // update();
    print('isLoading=$isLoading');
    (formKey.currentState!.validate());
    if (isPhoneNumValid.value) {
      firestoreController.registeredUser?.value =
          await (firestoreController.getUser(phoneNum: phoneNum.value));
    }
    isLoading.value = false;
  }

  Future<void> loginUser() async {
    isLoading.value = true;
    await authController.signInPhone(
      phoneNum: phoneNum.value,
      otp: '',
      onCodeSentAction: () async {
        print('code sent');

        ///TODO: change navigation route cancellation
        Get.to(() => OTPScreen(
            phoneNum: phoneNum.value,
            isNewUser:
                firestoreController.registeredUser == null ? true : false));
        /*setState(() {
          isLoading = true;
        });
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => OTPScreen(
              phoneNum: phoneNumController.text.trim(),
              isNewUser: registeredUser == null ? true : false,
              */ /*registeredUser: registeredUser!,*/ /*
            ),
          ),
        );*/
      },
    );
    /*  setState(() {
      isLoading = false;
    });*/
  }
}
