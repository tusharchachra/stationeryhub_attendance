import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:stationeryhub_attendance/components/form_field_button.dart';
import 'package:stationeryhub_attendance/controllers/firebase_firestore_controller.dart';
import 'package:stationeryhub_attendance/controllers/mark_attendance_screen_controller.dart';
import 'package:stationeryhub_attendance/helpers/constants.dart';

class MarkAttendanceResultScreen extends StatelessWidget {
  const MarkAttendanceResultScreen({super.key});

  @override
  Widget build(BuildContext context) {
    //final FaceController faceController = Get.find();
    final MarkAttendanceScreenController markAttendanceScreenController =
        Get.find();
    /*final AdminDashboardScreenController adminDashboardScreenController =
        Get.find();
    final CaptureImageScreenController captureImageScreenController =
        Get.find();*/
    /*markAttendanceScreenController.markAttendance(
        faceController: faceController,
        captureImageScreenController: captureImageScreenController,
        adminDashboardScreenController: adminDashboardScreenController);*/
    return /*Obx(
      () => markAttendanceScreenController.isLoading.isTrue
          ? buildLoading(markAttendanceScreenController)
          :*/
        Dialog(
      child: markAttendanceScreenController.recognizedUser.value.userId != null
          ? buildSuccess(markAttendanceScreenController)
          : buildFailure(markAttendanceScreenController),
    );
  }

  Widget buildSuccess(
      MarkAttendanceScreenController markAttendanceScreenController) {
    final FirebaseFirestoreController firestoreController = Get.find();

    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: 20.w,
        vertical: 30.h,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(
            Icons.check,
            color: Colors.green,
            size: 60.w,
          ),
          SizedBox(height: 10.h),
          Text(
            markAttendanceScreenController.recognizedUser.value.name!,
            style: Get.textTheme.displaySmall!
                .copyWith(color: Constants.colourTextMedium),
          ),
          SizedBox(height: 10.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              FormFieldButton(
                width: 150.w,
                height: 50.h,
                buttonText: 'Correct',
                onTapAction: () async {
                  markAttendanceScreenController.isRecognitionCorrect(true);
                  Get.back();
                },
              ),
              FormFieldButton(
                width: 150.w,
                height: 50.h,
                buttonText: 'Wrong',
                onTapAction: () {
                  Get.back();
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget buildFailure(
      MarkAttendanceScreenController markAttendanceScreenController) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: 20.w,
        vertical: 30.h,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(
            Icons.close,
            color: Colors.red,
            size: 60.w,
          ),
          SizedBox(height: 10.h),
          Text(
            'No face recognized\nTry again with a close-up picture',
            textAlign: TextAlign.center,
            style: Get.textTheme.displaySmall!
                .copyWith(color: Constants.colourTextMedium),
          ),
          SizedBox(height: 10.h),
          FormFieldButton(
              width: 200.w,
              height: 50.h,
              buttonText: 'Okay',
              onTapAction: () {
                Get.back();
              })
        ],
      ),
    );
  }

  Column buildLoading(
      MarkAttendanceScreenController markAttendanceScreenController) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        CircularProgressIndicator(),
        Text(
          'Searching...',
          style: Get.textTheme.displaySmall!
              .copyWith(color: Constants.colourTextMedium),
        ),
      ],
    );
  }
}
