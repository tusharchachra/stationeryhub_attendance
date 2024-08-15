import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:stationeryhub_attendance/form_fields/form_field_button1.dart';
import 'package:stationeryhub_attendance/form_fields/form_field_phone_num.dart';
import 'package:stationeryhub_attendance/services/firebase_auth_controller.dart';

import '../helpers/constants.dart';
import '../scaffold/scaffold_onboarding.dart';

class ScreenLoginNew extends GetWidget<FirebaseAuthController> {
  const ScreenLoginNew({super.key});

  @override
  Widget build(BuildContext context) {
    TextEditingController phoneNumController = TextEditingController();
    return ScaffoldOnboarding(
      bodyWidget: Center(
        child: Container(
          width: 364.w,
          height: 353.h,
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(color: Colors.grey, blurRadius: 30.0),
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
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
                  onChangedAction: () {},
                  phoneNumController: phoneNumController,
                  validatorPhoneNum: (value) {
                    return null;
                  },
                ),
              ),
              FormFieldButton1(
                width: 384.w,
                height: 56.h,
                buttonText: 'Continue',
                onTapAction: () {},
              )
            ],
          ),
        ),
      ),
    );
  }
}
