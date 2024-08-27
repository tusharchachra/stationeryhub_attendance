import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:pinput/pinput.dart';
import 'package:stationeryhub_attendance/albums/enum_user_type.dart';
import 'package:stationeryhub_attendance/form_fields/form_field_button1.dart';
import 'package:stationeryhub_attendance/services/firebase_auth_controller.dart';
import 'package:stationeryhub_attendance/services/firebase_error_controller.dart';
import 'package:stationeryhub_attendance/services/firebase_firestore_controller.dart';
import 'package:stationeryhub_attendance/services/shared_prefs_controller.dart';

import '../form_fields/form_field_otp.dart';
import '../helpers/constants.dart';
import '../scaffold/scaffold_onboarding.dart';
import '../services/login_screen_controller.dart';
import '../services/otp_screen_controller.dart';

class OtpScreen extends StatelessWidget {
  const OtpScreen({super.key});
  static LoginScreenController loginController = Get.find();
  static FirebaseAuthController authController = Get.find();
  static FirebaseFirestoreController firestoreController = Get.find();
  static OtpScreenController otpController = Get.find();
  static FirebaseErrorController errorController = Get.find();
  static SharedPrefsController sharedPrefsController = Get.find();

  @override
  Widget build(BuildContext context) {
    otpController.otpDigitController.value.setText('');
    otpController.isOtpValid.value = true;
    return ScaffoldOnboarding(
      bodyWidget: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 364.w,
              height: 353.h,
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(color: Colors.grey, blurRadius: 62.0.r),
                ],
                borderRadius: BorderRadius.circular(5.0.r),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 75.w,
                    height: 75.h,
                    decoration: BoxDecoration(
                      color: colourIconBackground,
                      shape: BoxShape.circle,
                    ),
                    child: FittedBox(
                      fit: BoxFit.fill,
                      child: Padding(
                        padding: const EdgeInsets.all(20.0).w,
                        child: const Icon(
                          Icons.sms_rounded,
                          color: colourPrimary,
                        ),
                      ),
                    ),
                  ),
                  Text(
                    'Enter the OTP',
                    style: Get.textTheme.displayLarge,
                  ),
                  Text(
                    'Received on ${loginController.phoneNum.value.substring(0, 1)}******${loginController.phoneNum.value.substring(7, loginController.phoneNum.value.length)}',
                    style: Get.textTheme.displayMedium,
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 12.w),
                    child: const FormFieldOtp(),
                  ),
                  Obx(
                    () => Wrap(
                      spacing: 5.w,
                      alignment: WrapAlignment.center,
                      children: [
                        Text(
                          'Not yet Received?',
                          style: Get.textTheme.displayMedium,
                        ),
                        otpController.isTimerRunning.value == true
                            ? Text(
                                '${otpController.countdownDuration} sec',
                                style: Get.textTheme.displayMedium,
                              )
                            : GestureDetector(
                                onTap: () {
                                  Get.showSnackbar(
                                    GetSnackBar(
                                      messageText: Text(
                                        'OTP resent successfully',
                                        textAlign: TextAlign.center,
                                        style: Get.textTheme.bodyMedium
                                            ?.copyWith(color: colourTextDark),
                                      ),
                                      duration: const Duration(seconds: 2),
                                      snackPosition: SnackPosition.BOTTOM,
                                      backgroundColor: Colors.white,
                                      boxShadows: [
                                        BoxShadow(
                                            color: Colors.grey,
                                            blurRadius: 62.0.r),
                                      ],
                                      snackStyle: SnackStyle.FLOATING,
                                      borderRadius: 50.r,
                                      margin: EdgeInsets.all(10.w),
                                    ),
                                  );
                                  otpController.startTimer();
                                  authController.signInPhone(
                                    phoneNum: loginController.phoneNum.value,
                                    smsCode: otpController.otp.value,
                                    forceResend: 1,
                                  );
                                },
                                child: Text(
                                  'Resend',
                                  style: Get.textTheme.displayMedium!
                                      .copyWith(color: colourPrimary),
                                ),
                              ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20.h),
            Obx(
              () => otpController.isLoading.value
                  ? SizedBox(
                      width: 25.w,
                      height: 25.h,
                      child: const CircularProgressIndicator(),
                    )
                  : FormFieldButton1(
                      width: 384.w,
                      height: 56.h,
                      buttonText: 'Continue',
                      onTapAction: () async {
                        otpController.isLoading.value = true;
                        if (kDebugMode) {
                          debugPrint(
                              'PhoneAuthCredential=${authController.credential.toString()}');
                        }
                        if (otpController.formKeyOtp.currentState!.validate()) {
                          //user sign in
                          await authController.signIn(
                              authCredential: authController.credential.value);
                          //store user to firestore
                          if (otpController.isNewUser.isTrue) {
                            await firestoreController.addNewUser(
                              phoneNum: loginController.phoneNum.value,
                              userType: UserType.admin,
                            );
                          }
                          //fetch registered user details from firestore
                          await firestoreController.onReady();
                          //Store registered user to shared prefs
                          final registeredUser =
                              firestoreController.registeredUser;
                          if (registeredUser != null) {
                            await sharedPrefsController.storeUserToSharedPrefs(
                                user: registeredUser.value);
                          }
                          otpController.isLoading.value = false;

                          ///TODO: set error on pinput if wrong OTP is used
                          if (errorController.errorMsg.isNotEmpty) {
                            otpController.isOtpValid.value = false;
                            otpController.error = errorController.errorMsg;
                          }
                        }
                      },
                    ),
            )
          ],
        ),
      ),
    );
  }
}
