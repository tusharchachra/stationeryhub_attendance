import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:stationeryhub_attendance/helpers/constants.dart';
import 'package:stationeryhub_attendance/services/firebase_auth_controller.dart';

import '../scaffold/scaffold_onboarding.dart';

class ScreenLoginNew extends GetWidget<FirebaseAuthController> {
  const ScreenLoginNew({super.key});

  @override
  Widget build(BuildContext context) {
    return ScaffoldOnboarding(
      bodyWidget: Center(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 33.w),
          child: Container(
            width: 364.w,
            height: 353.h,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.all(
                  Radius.circular(5.r),
                ),
                color: Colors.white),
            child: Container(
              width: 75.w,
              height: 75.h,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: colourIconBackground,
              ),
              child: Icon(
                Icons.phone,
                color: colourPrimary,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
