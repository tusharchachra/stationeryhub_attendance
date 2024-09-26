import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:stationeryhub_attendance/components/picture_circle.dart';
import 'package:stationeryhub_attendance/controllers/api_controller.dart';
import 'package:stationeryhub_attendance/helpers/constants.dart';
import 'package:stationeryhub_attendance/models/user_attendance_model.dart';

class EmployeeAttendanceCard extends StatelessWidget {
  const EmployeeAttendanceCard({super.key, required this.attendance});

  final UserAttendanceModel attendance;

  @override
  Widget build(BuildContext context) {
    final ApiController apiController = Get.find();

    return Padding(
      padding: EdgeInsets.symmetric(vertical: 14.h),
      child: Container(
        // width: 405.w,
        height: 132.h,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(5.r),
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 12.h),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  PictureCircle(
                    height: 34.h,
                    width: 34.w,
                    imgPath: '',
                    backgroundColor: Constants.colourTextLight,
                  ),
                  Text(
                    attendance.date.toString(),
                    style: Get.textTheme.displayMedium
                        ?.copyWith(color: Constants.colourTextDark),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
