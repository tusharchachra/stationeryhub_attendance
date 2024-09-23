import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:pinput/pinput.dart';

import '../components/form_field_button.dart';
import '../components/form_field_otp.dart';
import '../controllers/firebase_auth_controller.dart';
import '../controllers/firebase_error_controller.dart';
import '../controllers/firebase_firestore_controller.dart';
import '../controllers/login_screen_controller.dart';
import '../controllers/otp_screen_controller.dart';
import '../helpers/constants.dart';
import '../models/user_type_enum.dart';
import '../scaffold/scaffold_onboarding.dart';

class OtpScreen extends StatelessWidget {
  const OtpScreen({super.key});
  static LoginScreenController loginController = Get.find();
  static FirebaseAuthController authController = Get.find();
  static FirebaseFirestoreController firestoreController = Get.find();
  static OtpScreenController otpController = Get.find();
  static FirebaseErrorController errorController = Get.find();
  //static SharedPrefsController sharedPrefsController = Get.find();

  @override
  Widget build(BuildContext context) {
    otpController.otpDigitController.value.setText('');
    otpController.isOtpValid.value = true;
    otpController.isLoading.value = false;
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
                      color: Constants.colourIconBackground,
                      shape: BoxShape.circle,
                    ),
                    child: FittedBox(
                      fit: BoxFit.fill,
                      child: Padding(
                        padding: const EdgeInsets.all(20.0).w,
                        child: const Icon(
                          Icons.sms_rounded,
                          color: Constants.colourPrimary,
                        ),
                      ),
                    ),
                  ),
                  Text(
                    'Enter the OTP',
                    style: Get.textTheme.displayMedium
                        ?.copyWith(color: Constants.colourTextDark),
                  ),
                  Text(
                    'Received on ${loginController.phoneNum.value.substring(0, 1)}-----${loginController.phoneNum.value.substring(6, loginController.phoneNum.value.length)}',
                    style: Get.textTheme.headlineLarge
                        ?.copyWith(color: Constants.colourTextDark),
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
                          style: Get.textTheme.titleLarge?.copyWith(
                            color: Constants.colourTextDark,
                          ),
                        ),
                        otpController.isTimerRunning.value == true
                            ? Text(
                                '${otpController.countdownDuration} sec',
                                style: Get.textTheme.titleLarge?.copyWith(
                                  color: Constants.colourTextDark,
                                ),
                              )
                            : GestureDetector(
                                onTap: () {
                                  Get.showSnackbar(
                                    GetSnackBar(
                                      messageText: Text(
                                        'OTP resent successfully',
                                        textAlign: TextAlign.center,
                                        style: Get.textTheme.bodyMedium
                                            ?.copyWith(
                                                color:
                                                    Constants.colourTextDark),
                                      ),
                                      duration: const Duration(
                                          seconds: Constants.otpResendTime),
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
                                  style: Get.textTheme.titleLarge?.copyWith(
                                    color: Constants.colourPrimary,
                                  ),
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
                  : FormFieldButton(
                      width: 384.w,
                      height: 56.h,
                      buttonText: 'Continue',
                      onTapAction: () async {
                        otpController.isLoading.value = true;
                        /*if (kDebugMode) {
                          debugPrint(
                              'PhoneAuthCredential=${authController.credential.toString()}');
                        }*/
                        otpController.validateForm(otpController.otp.value);
                        if (otpController.isOtpValid.value == true &&
                            otpController.error.value == '') {
                          //user sign in
                          await authController.signIn(
                              authCredential: authController.credential?.value);

                          //store user to firestore
                          print(
                              '{authController.firebaseUser.value?.uid=${authController.firebaseUser.value?.uid}');
                          print(otpController.isNewUser);
                          if (authController.firebaseUser.value?.uid != null) {
                            if (otpController.isNewUser.isTrue) {
                              await firestoreController.registerNewUser(
                                phoneNum: loginController.phoneNum.value,
                                userType: UserType.admin,
                              );
                              otpController.isNewUser.value = false;
                            }
                            firestoreController.attachUserListener();
                          }

                          ///TODO: set error on pinput if wrong OTP is used
                          if (errorController.errorMsg.isNotEmpty) {
                            otpController.isOtpValid.value = false;
                            otpController.error = errorController.errorMsg;
                          }

                          //Fetch from firestore and Store registered user to shared prefs
                          /*final registeredUser =
                              firestoreController.registeredUser;*/
                          /*if (registeredUser != null) {
                            await sharedPrefsController.storeUserToSharedPrefs(
                                user: registeredUser.value);
                          }*/

                          //fetch organization from firestore
                          /*AlbumOrganization? newOrganization =
                              await firestoreController.getOrganization(
                                  user: registeredUser?.value);
                          if (newOrganization != null) {
                            await sharedPrefsController
                                .storeOrganizationToSharedPrefs(
                                    organization: newOrganization);

                            firestoreController.registeredOrganization?.value =
                                newOrganization;
                          }*/

                          otpController.isLoading.value = false;
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
