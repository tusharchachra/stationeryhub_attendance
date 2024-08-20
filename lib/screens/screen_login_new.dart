import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:stationeryhub_attendance/form_fields/form_field_button1.dart';
import 'package:stationeryhub_attendance/form_fields/form_field_phone_num.dart';
import 'package:stationeryhub_attendance/services/firebase_auth_controller.dart';
import 'package:stationeryhub_attendance/services/firebase_firestore_controller.dart';

import '../helpers/constants.dart';
import '../scaffold/scaffold_onboarding.dart';
import '../services/screen_login_controller.dart';

class ScreenLoginNew extends StatelessWidget {
  const ScreenLoginNew({super.key});
  static ScreenLoginNewController loginController = Get.find();
  static FirebaseAuthController authController = Get.find();
  static FirebaseFirestoreController firestoreController = Get.find();
  @override
  Widget build(BuildContext context) {
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
                        color: colourIconBackground,
                        shape: BoxShape.circle,
                      ),
                      child: FittedBox(
                        fit: BoxFit.fill,
                        child: Padding(
                          padding: EdgeInsets.all(20.0).w,
                          child: Icon(
                            Icons.phone,
                            color: colourPrimary,
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
                        /* phoneNumController:
                                controller.phoneNumController.value,*/
                        onChangedAction: (value) {
                          /*if (controller.formKey.currentState!.validate() &&
                                controller.isPhoneNumValid != true) {
                              isPhoneNumValid.value = true;
                            } else {
                              isPhoneNumValid.value = false;
                            }
                            print(isPhoneNumValid);*/
                        },
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
                      child: CircularProgressIndicator(),
                    )
                  : FormFieldButton1(
                      width: 384.w,
                      height: 56.h,
                      buttonText: 'Continue',
                      onTapAction: () async {
                        if (loginController.isPhoneNumValid.value) {
                          await loginController.onLogin();
                          //check if user exists
                          //FirebaseFirestoreServices firestoreServices = FirebaseFirestoreServices();

                          /*registeredUser = await firestoreServices.getUser(
          phoneNum: phoneNumController.text.trim());*/
                          print(
                              'registered user= ${firestoreController.registeredUser}');
                          if (firestoreController.registeredUser?.value?.uid !=
                              null) {
                            await loginController.loginUser();
                          } else {
                            if (kDebugMode) {
                              print('User not registered');
                            }
                            //show dialog to register the new user or cancel
                            // buildShowAdaptiveDialog();
                            Get.bottomSheet(buildBottomSheet(),
                                backgroundColor: Colors.white);
                          }
                        }
                      }

                      /*if (isPhoneNumValid) {
                      isLoading = true;

                      //check if user exists
                      FirebaseFirestoreServices firestoreServices =
                          FirebaseFirestoreServices();
                      registeredUser = await firestoreServices.getUser(
                          phoneNum: phoneNumController.text.trim());
                      print('registered user= $registeredUser');
                      if (registeredUser != null) {
                        await loginUser();
                      } else {
                        if (kDebugMode) {
                          print('User not registered');
                        }
                        //show dialog to register the new user or cancel
                        buildShowAdaptiveDialog();
                      }
                    }*/
                      ,
                    ))
            ],
          ),
        ),
      ),
    );
  }

  Widget buildBottomSheet() {
    return Container(
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
