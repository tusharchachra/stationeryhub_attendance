import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:stationeryhub_attendance/components/picture_circle.dart';
import 'package:stationeryhub_attendance/helpers/constants.dart';

class EmployeeAttendanceCard extends StatelessWidget {
  const EmployeeAttendanceCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
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
              ],
            )
          ],
        ),
      ),
    );
  }
}
