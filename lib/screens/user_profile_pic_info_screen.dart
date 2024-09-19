import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:stationeryhub_attendance/components/form_field_button.dart';

import '../scaffold/scaffold_dashboard.dart';
import 'capture_image_screen.dart';

class UserProfilePicInfoScreen extends StatelessWidget {
  const UserProfilePicInfoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ScaffoldDashboard(
      isLoading: false,
      pageTitle: 'New User',
      bodyWidget: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Wrap(
            runAlignment: WrapAlignment.start,
            //alignment: WrapAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.fromLTRB(12.w, 25.h, 12.w, 12.h),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(right: 12.w),
                      child: Icon(Icons.person_add_sharp),
                    ),
                    Text(
                      'Add a new user',
                      style: Get.textTheme.titleLarge,
                    )
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(39.w, 0, 12.w, 12.h),
                child: Text(
                  'Click a picture to use as profile picture',
                  style: Get.textTheme.displayMedium,
                ),
              ),
            ],
          ),
          Center(child: Image.asset('assets/images/addNewUserBackground.png')),
          Padding(
            padding: EdgeInsets.only(bottom: 48.h),
            child: FormFieldButton(
                width: 384.w,
                height: 56.h,
                buttonText: 'Capture face',
                onTapAction: () {
                  Get.off(() => CaptureImageScreen());
                }),
          )
        ],
      ),
    );
  }
}
