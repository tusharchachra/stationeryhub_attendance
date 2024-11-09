import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:stationeryhub_attendance/components/checkered_box_painter.dart';
import 'package:stationeryhub_attendance/controllers/capture_image_screen_controller.dart';
import 'package:stationeryhub_attendance/controllers/firebase_storage_controller.dart';
import 'package:stationeryhub_attendance/scaffold/scaffold_dashboard.dart';
import 'package:stationeryhub_attendance/screens/capture_image_screen.dart';

import '../helpers/constants.dart';

class DisplayCapturedImageScreen extends StatelessWidget {
  const DisplayCapturedImageScreen({super.key, this.displayForeground});

  final bool? displayForeground;

  static final FirebaseStorageController firebaseStorageController = Get.find();

  @override
  Widget build(BuildContext context) {
    final CaptureImageScreenController captureImageScreenController =
        Get.find();

    return ScaffoldDashboard(
      pageTitle: Text('Confirm Image'),
      bodyWidget: Container(
        width: 1.sw,
        height: 1.sh,
        child: Stack(
          children: [
            SizedBox(
              width: 1.sw,
              height: 1.sh,
              child: Image.file(
                File(captureImageScreenController.imageFile!.path),
                fit: BoxFit.fill,
              ),
            ),
            if (displayForeground ?? true)
              Positioned(
                top: 70.h,
                left: 0,
                right: 0,
                child: Center(
                  child: CustomPaint(
                    foregroundPainter: CheckeredBoxPainter(),
                    child: Container(
                      width: 350.w,
                      height: 350.h,
                      color: Colors.transparent,
                    ),
                  ),
                ),
              ),
            buildButtons(captureImageScreenController)
          ],
        ),
      ),
    );
  }

  Widget buildButtons(
      CaptureImageScreenController captureImageScreenController) {
    return Positioned(
      bottom: 69.h,
      left: 0,
      right: 0,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          GestureDetector(
            onTap: () {
              Get.off(() => const CaptureImageScreen());
            },
            child: Container(
              width: 61.w,
              height: 61.h,
              // alignment: Alignment.centerRight,
              padding: EdgeInsets.all(15.w),
              decoration: const BoxDecoration(
                  color: Constants.colourTextFieldIcon, shape: BoxShape.circle),
              child: const FittedBox(
                fit: BoxFit.fill,
                child: Icon(
                  Icons.camera,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          SizedBox(width: 35.w),
          GestureDetector(
            onTap: () async {
              /*  var x = firebaseStorageController
                  .uploadProfilePic((captureImageScreenController.imageFile));*/
              Get.back();
              //Get.offUntil(AdminDashboardScreen() as Route, (route) => false);
              //Get.offUntil(()=>UserOnboardingScreen(), predicate)
              //print(x);
            },
            child: Container(
              width: 94.w,
              height: 94.h,
              padding: EdgeInsets.all(10.w),
              decoration: const BoxDecoration(
                  color: Constants.colourPrimary, shape: BoxShape.circle),
              child: const FittedBox(
                fit: BoxFit.fill,
                child: Icon(
                  Icons.check,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          SizedBox(width: 35.w),
          GestureDetector(
            onTap: () {
              Get.off(() => const CaptureImageScreen());

              //  captureImageScreenController.switchCameraDirection();
            },
            child: Container(
              width: 61.w,
              height: 61.h,
              // alignment: Alignment.centerRight,
              padding: EdgeInsets.all(15.w),
              decoration: const BoxDecoration(
                  color: Constants.colourTextFieldIcon, shape: BoxShape.circle),
              child: const FittedBox(
                fit: BoxFit.fill,
                child: Icon(
                  Icons.delete,
                  color: Colors.white,
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
