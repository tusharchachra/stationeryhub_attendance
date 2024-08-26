import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../screens/otp_screen.dart';
import 'firebase_auth_controller.dart';
import 'firebase_firestore_controller.dart';
import 'otp_screen_controller.dart';

class LoginScreenController extends GetxController {
  final formKey = GlobalKey<FormState>();
  //Rx<TextEditingController> phoneNumController = TextEditingController().obs;
  RxBool isPhoneNumValid = false.obs;
  RxBool isLoading = false.obs;
  RxString phoneNum = ('').obs;
  final FocusNode focusNode = FocusNode();
  static FirebaseAuthController authController = Get.find();
  static FirebaseFirestoreController firestoreController = Get.find();
  static OtpScreenController otpController = Get.find();

  validatePhoneNum(String? value) {
    /*if (value == '7808814341') {
      return null;    } else*/
    phoneNum = RxString(value!.trim());
    print('value=$value');
    String? temp;
    if (value == '') {
      isPhoneNumValid.value = false;
      temp = 'Invalid phone number';
    } else if (value.length == 10) {
      isPhoneNumValid.value = true;
      temp = null;
    } else if (value.length < 10) {
      isPhoneNumValid.value = false;
      temp = 'Invalid phone number';
    } else {
      isPhoneNumValid.value = false;
      temp = 'Unauthorised user';
    }
    return temp;
  }

  Future updateRegisteredUser() async {
    isLoading.value = true;
    // update();
    print('isLoading=$isLoading');
    //(formKey.currentState!.validate());
    var temp = await (firestoreController.getUser(phoneNum: phoneNum.value));
    // if (temp != null) {
    firestoreController.registeredUser?.update((user) {
      user?.phoneNum = temp?.phoneNum;
      user?.uid = temp?.uid;
      user?.name = temp?.name;
      user?.userType = temp?.userType;
      user?.organizationId = temp?.organizationId;
    });
    //  }
    isLoading.value = false;
  }

  Future<void> loginUser() async {
    isLoading.value = true;

    await authController.signInPhone(
      phoneNum: phoneNum.value,
      smsCode: otpController.otp.value,
      onCodeSentAction: () async {
        print('code sent');
        isLoading.value = false;

        ///TODO: change navigation route cancellation
        Get.to(() => OtpScreen(
            /*isNewUser:
                firestoreController.registeredUser == null ? true : false*/
            ));
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
