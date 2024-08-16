import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:stationeryhub_attendance/form_fields/form_field_button1.dart';
import 'package:stationeryhub_attendance/form_fields/form_field_phone_num.dart';

import '../helpers/constants.dart';
import '../scaffold/scaffold_onboarding.dart';

class ScreenLoginNewController extends GetxController {
  final formKey = GlobalKey<FormState>();
  //Rx<TextEditingController> phoneNumController = TextEditingController().obs;
  RxBool isPhoneNumValid = false.obs;

  validatePhoneNum(String? value) {
    /*if (value == '7808814341') {
      return null;
    } else*/
    if (value!.length == 10) {
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
    (formKey.currentState!.validate());
    if (isPhoneNumValid.value) {}
  }
}

class ScreenLoginNew extends StatelessWidget {
  ScreenLoginNew({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ScreenLoginNewController());

    return ScaffoldOnboarding(
      bodyWidget: Center(
        child: Form(
          key: controller.formKey,
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
                      style: Theme.of(context).textTheme.displayLarge,
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 12.w),
                      child: FormFieldPhoneNum(
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
                          return controller.validatePhoneNum(value);
                        },
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20.h),
              FormFieldButton1(
                width: 384.w,
                height: 56.h,
                buttonText: 'Continue',
                onTapAction: () {
                  print('tapped');
                  controller.onLogin();
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
              )
            ],
          ),
        ),
      ),
    );
  }
}
