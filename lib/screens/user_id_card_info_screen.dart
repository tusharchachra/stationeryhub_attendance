import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:stationeryhub_attendance/components/form_field_button.dart';
import 'package:stationeryhub_attendance/screens/user_id_card_upload_screen.dart';

import '../helpers/constants.dart';
import '../scaffold/scaffold_dashboard.dart';

class UserIdCardInfoScreen extends StatelessWidget {
  const UserIdCardInfoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ScaffoldDashboard(
      isLoading: false,
      pageTitle: 'ID card',
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
                      child: const Icon(Icons.person_add_sharp),
                    ),
                    Text(
                      'Add ID of the user',
                      style: Get.textTheme.titleLarge,
                    )
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(39.w, 0, 12.w, 12.h),
                child: Text(
                  'Click a picture or upload',
                  style: Get.textTheme.displayMedium,
                ),
              ),
            ],
          ),
          Center(child: Image.asset('assets/images/idScanBackground.png')),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Padding(
                padding: EdgeInsets.only(bottom: 48.h),
                child: FormFieldButton(
                    width: 384.w,
                    height: 56.h,
                    buttonText: 'Camera',
                    buttonStyle: Constants.buttonStyleWhite,
                    leadingIcon: const Icon(
                      Icons.camera_alt_outlined,
                    ),
                    onTapAction: () {
                      Get.off(() => UserIdCardUploadScreen());
                      //Get.to(() => const CaptureImageScreen());
                    }),
              ),
              /* Padding(
                padding: EdgeInsets.only(bottom: 48.h),
                child: FormFieldButton(
                    width: 190.w,
                    height: 56.h,
                    buttonText: 'Upload',
                    buttonStyle: Constants.buttonStyleWhite,
                    leadingIcon: const Icon(
                      Icons.file_upload_outlined,
                    ),
                    onTapAction: () {}),
              ),*/
            ],
          ),
        ],
      ),
    );
  }
}
