import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';

import 'firebase_auth_controller.dart';
import 'login_screen_controller.dart';

class OtpScreenController extends GetxController {
  final GlobalKey<FormState> formKeyOtp = GlobalKey<FormState>();
  TextEditingController otpDigitController = TextEditingController();
  final FocusNode focusDigit = FocusNode();

  static FirebaseAuthController authController = Get.find();
  static LoginScreenController loginController = Get.find();

  String firebaseMessage = '';
  bool isOtpValid = false;
  RxBool isLoading = false.obs;
  RxString otp = ''.obs;
  RxString error = ''.obs;

  @override
  void dispose() {
    focusDigit.dispose();
    otpDigitController.dispose();
    super.dispose();
  }

  Future<void> onLogin(var otp) async {
    firebaseMessage = await authController.signInPhone(
      phoneNum: loginController.phoneNum.value,
      otp: otp.value,
    );
  }

  String validateForm(var otp) {
    if (kDebugMode) {
      print('validating OTP');
    }
    if (otp.value.length < 6) {
      error.value = 'Invalid OTP';
      isOtpValid = false;
    } else {
      isOtpValid = true;
    }
    return error.value;
  }
}
