import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:stationeryhub_attendance/controllers/firebase_auth_controller.dart';

import '../components/form_field_button.dart';
import '../components/form_field_phone_num.dart';
import '../controllers/firebase_error_controller.dart';
import '../controllers/firebase_firestore_controller.dart';
import '../controllers/login_screen_controller.dart';
import '../controllers/otp_screen_controller.dart';
import '../helpers/constants.dart';
import '../models/users_model.dart';
import '../scaffold/scaffold_onboarding.dart';
import 'otp_screen.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});
  static LoginScreenController loginController = Get.find();
  static FirebaseAuthController authController = Get.find();
  static FirebaseFirestoreController firestoreController = Get.find();

  static OtpScreenController otpController = Get.put(OtpScreenController());
  static FirebaseErrorController errorController = Get.find();

  @override
  Widget build(BuildContext context) {
    errorController.resetValues();

    otpController.isNewUser.value = false;
    return ScaffoldOnboarding(
      bodyWidget: Center(
        child: Form(
          key: loginController.formKey,
          autovalidateMode: AutovalidateMode.onUserInteraction,
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
                            Icons.phone,
                            color: Constants.colourPrimary,
                          ),
                        ),
                      ),
                    ),
                    Text(
                      'Enter your phone number',
                      style: Get.textTheme.displayLarge,
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 12.w),
                      child: FormFieldPhoneNum(
                        focusNode: loginController.focusNode,
                        onChangedAction: (value) {},
                        validatorPhoneNum: (value) {
                          return loginController.validatePhoneNum(value);
                        },
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20.h),
              Obx(() => loginController.isLoading.value
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
                        loginController.isLoading.value = true;
                        loginController.focusNode.unfocus();
                        loginController.formKey.currentState!.validate();
                        loginController.isLoading.value = false;
                        if (loginController.isPhoneNumValid.value) {
                          /* await loginController.updateRegisteredUser();
                          if (kDebugMode) {
                            print(
                                'registered user= ${firestoreController.registeredUser}');
                          }*/
                          UsersModel? tempUser =
                              await firestoreController.getUser(
                                  phoneNum: loginController.phoneNum.value);
                          //if registered user is found in the firestore, send otp. if not, show bottom sheet to confirm usage
                          if (tempUser != null) {
                            loginProcess();
                            otpController.isNewUser.value = false;
                          } else {
                            if (kDebugMode) {
                              print(authController.firebaseMessage);
                            }
                            otpController.isNewUser.value = true;
                            //show dialog to register the new user or cancel
                            Get.bottomSheet(buildBottomSheet(),
                                backgroundColor: Colors.white);
                          }
                        } else {}
                        loginController.isLoading.value = false;
                      },
                    ))
            ],
          ),
        ),
      ),
    );
  }

  void loginProcess() {
    ///TODO:send otp
    authController.signInPhone(
        phoneNum: loginController.phoneNum.value,
        smsCode: otpController.otp.value,
        onCodeSentAction: () {});
    otpController.startTimer();
    Get.to(() => OtpScreen());
  }

  Widget buildBottomSheet() {
    return SizedBox(
      height: 0.5.sh,
      child: errorController.errorMsg.value != ''
          ? buildErrorBottomSheet()
          : buildUserNotFoundBottomSheet(),
    );
  }

  Padding buildUserNotFoundBottomSheet() {
    return Padding(
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
          FormFieldButton(
            width: 384.w,
            height: 56.h,
            buttonText: 'Create new organization',
            onTapAction: () {
              Get.back();
              loginProcess();
            },
          ),
          FormFieldButton(
            width: 384.w,
            height: 56.h,
            buttonText: 'Cancel',
            onTapAction: () {
              Get.back();
            },
          ),
        ],
      ),
    );
  }

  Padding buildErrorBottomSheet() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 20.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'Something went wrong',
            style: Get.textTheme.displayLarge,
            textAlign: TextAlign.center,
          ),
          Text(
            errorController.errorMsg.value,
            style: Get.textTheme.displayMedium,
            textAlign: TextAlign.center,
          ),
          FormFieldButton(
            width: 384.w,
            height: 56.h,
            buttonText: 'Close',
            onTapAction: () {
              Get.back();
            },
          ),
        ],
      ),
    );
  }
}
