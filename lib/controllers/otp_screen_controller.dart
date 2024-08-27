import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:stationeryhub_attendance/helpers/constants.dart';

import '../controllers/firebase_auth_controller.dart';
import 'login_screen_controller.dart';

class OtpScreenController extends GetxController {
  final formKeyOtp = GlobalKey<FormState>();
  Rx<TextEditingController> otpDigitController = TextEditingController().obs;
  final FocusNode focusDigit = FocusNode();

  static FirebaseAuthController authController = Get.find();
  static LoginScreenController loginController = Get.find();

  String firebaseMessage = '';
  RxBool isOtpValid = true.obs;
  RxBool isLoading = false.obs;
  RxString otp = ''.obs;
  RxString error = ''.obs;
  RxInt countdownDuration = otpResendTime.obs;
  RxBool isTimerRunning = true.obs;
  RxBool isNewUser = false.obs;

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
  }

  @override
  void dispose() {
    focusDigit.dispose();
    otpDigitController.value.dispose();
    super.dispose();
  }

  Future<void> onLogin(var otp) async {
    error.value = await authController.signInPhone(
      phoneNum: loginController.phoneNum.value,
      smsCode: otp.value,
    );
  }

  String? validateForm(var otp) {
    if (kDebugMode) {
      print('validating OTP');
    }
    if (otp.length < 6) {
      error = RxString('Invalid OTP');
      isOtpValid.value = false;
    } else {
      error.value = '';
      isOtpValid.value = true;
    }
    return error.value;
  }

  void startTimer() {
    countdownDuration = 5.obs;
    isTimerRunning.value = true;
    Timer.periodic(
      const Duration(seconds: 1),
      (Timer timer) {
        if (countdownDuration.value == 1) {
          timer.cancel();
          isTimerRunning.value = false;
        } else {
          countdownDuration--;
        }
        print(countdownDuration);
      },
    );
    //print(_start);
  }
}
