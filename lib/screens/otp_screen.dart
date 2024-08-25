import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:pinput/pinput.dart';
import 'package:stationeryhub_attendance/form_fields/form_field_button1.dart';
import 'package:stationeryhub_attendance/services/firebase_auth_controller.dart';
import 'package:stationeryhub_attendance/services/firebase_error_controller.dart';
import 'package:stationeryhub_attendance/services/firebase_firestore_controller.dart';

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
                                  otpController.startTimer();
                                  authController.signInPhone(
                                    phoneNum: loginController.phoneNum.value,
                                    otp: otpController.otp.value,
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
            Obx(() => otpController.isLoading.value
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
                      if (otpController.formKeyOtp.currentState!.validate()) {
                        ///TODO:login
                        otpController.isLoading.value = true;
                        await authController.signIn(
                            credential: authController.credential.value);
                        otpController.isLoading.value = false;
                        print('error:${errorController.errorMsg.value}');
                        //otpController.formKeyOtp

                        ///TODO: set error on pinput if wrong OTP is used
                        if (errorController.errorMsg.isNotEmpty) {
                          otpController.isOtpValid.value = false;
                          otpController.error = errorController.errorMsg;
                          //otpController.formKeyOtp.currentState.
                          // otpController.isOtpValid = false;
                          /*Get.snackbar(
                            '',
                            otpController.error.value,
                            snackPosition: SnackPosition.BOTTOM,
                            colorText: colourTextDark,
                          );*/
                        }
                      }
                    },
                  ))
          ],
        ),
      ),
    );
  }

  Widget buildBottomSheet() {
    return SizedBox(
      height: 0.5.sh,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 20.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'User not found',
              style: Get.textTheme.displayLarge,
              textAlign: TextAlign.center,
            ),
            Text(
              'If you are an employee, request your organization to grant access.',
              style: Get.textTheme.displayMedium,
              textAlign: TextAlign.center,
            ),
            Text(
              'Or',
              style: Get.textTheme.displayMedium,
              textAlign: TextAlign.center,
            ),
            FormFieldButton1(
              width: 384.w,
              height: 56.h,
              buttonText: 'Create new organization',
              onTapAction: () {
                loginController.loginUser();
              },
            ),
            FormFieldButton1(
              width: 384.w,
              height: 56.h,
              buttonText: 'Cancel',
              onTapAction: () {
                Get.back();
              },
            ),
          ],
        ),
      ),
    );
  }
}
