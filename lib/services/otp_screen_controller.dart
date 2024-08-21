import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';

import 'firebase_auth_controller.dart';
import 'login_screen_controller.dart';

class OtpScreenController extends GetxController {
  TextEditingController otpDigitController1 = TextEditingController();
  TextEditingController otpDigitController2 = TextEditingController();
  TextEditingController otpDigitController3 = TextEditingController();
  TextEditingController otpDigitController4 = TextEditingController();
  TextEditingController otpDigitController5 = TextEditingController();
  TextEditingController otpDigitController6 = TextEditingController();
  final FocusNode focusDigit1 = FocusNode();
  final FocusNode focusDigit2 = FocusNode();
  final FocusNode focusDigit3 = FocusNode();
  final FocusNode focusDigit4 = FocusNode();
  final FocusNode focusDigit5 = FocusNode();
  final FocusNode focusDigit6 = FocusNode();

  static FirebaseAuthController authController = Get.find();
  static LoginScreenController loginController = Get.find();

  String firebaseMessage = '';
  bool isOtpValid = false;
  RxBool isLoading = false.obs;
  RxString otp = ''.obs;
  RxString error = ''.obs;

  @override
  void dispose() {
    focusDigit1.dispose();
    focusDigit2.dispose();
    focusDigit3.dispose();
    focusDigit4.dispose();
    otpDigitController1.dispose();
    otpDigitController2.dispose();
    otpDigitController3.dispose();
    otpDigitController4.dispose();
    otpDigitController5.dispose();
    otpDigitController6.dispose();

    super.dispose();
  }

  Future<void> onLogin() async {
    otp = RxString(otpDigitController1.text.trim() +
        otpDigitController2.text.trim() +
        otpDigitController3.text.trim() +
        otpDigitController4.text.trim() +
        otpDigitController5.text.trim() +
        otpDigitController6.text.trim());
    firebaseMessage = await authController.signInPhone(
      phoneNum: loginController.phoneNum.value,
      otp: otp.value,
    );
  }

  void validateForm() {
    if (kDebugMode) {
      print('validating OTP');
    }
    otp = RxString(otpDigitController1.text.trim() +
        otpDigitController2.text.trim() +
        otpDigitController3.text.trim() +
        otpDigitController4.text.trim() +
        otpDigitController5.text.trim() +
        otpDigitController6.text.trim());

    if (otp.value.length < 6) {
      error.value = 'Invalid OTP';
      isOtpValid = false;
    } else {
      isOtpValid = true;
    }
  }
}
