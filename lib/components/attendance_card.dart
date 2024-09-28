import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:stationeryhub_attendance/components/gradient_progress_bar.dart';
import 'package:stationeryhub_attendance/components/picture_circle.dart';
import 'package:stationeryhub_attendance/helpers/constants.dart';
import 'package:stationeryhub_attendance/models/attendance_view_model.dart';

class AttendanceCard extends StatelessWidget {
  const AttendanceCard({
    super.key,
    required this.attendanceView,
    this.showPlaceholder = false,
    /*required this.user*/
  });

  final bool showPlaceholder;
  final AttendanceViewModel? attendanceView;
  //final UsersModel? user;

  @override
  Widget build(BuildContext context) {
    bool showLocalPlaceholder = false;
    /*if (attendance != null) {
      attendanceCardController.setUser(attendance!.empId!);
    }*/
    if (attendanceView?.attendance == null) {
      showLocalPlaceholder = true;
    }
    return showPlaceholder || showLocalPlaceholder
        ? buildPlaceholder()
        : buildView();
  }

  Padding buildView() {
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
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  PictureCircle(
                    height: 34.h,
                    width: 34.w,
                    imgPath: '',
                    backgroundColor: Constants.colourTextLight,
                  ),
                  Text(
                    attendanceView?.user.name ?? '',
                    style: Get.textTheme.displaySmall
                        ?.copyWith(color: Constants.colourTextDark),
                  ),
                  Text(
                    attendanceView!.attendance.date.toString(),
                    style: Get.textTheme.displaySmall
                        ?.copyWith(color: Constants.colourTextDark),
                  ),
                  Text(
                    attendanceView!.attendance.empId.toString(),
                    style: Get.textTheme.displaySmall
                        ?.copyWith(color: Constants.colourTextDark),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Padding buildPlaceholder() {
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
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                /*  width: 34.w,
                              height:  34.h,*/
                decoration: BoxDecoration(shape: BoxShape.circle),
                child: GradientProgressBar(size: Size(34, 34)),
              ),
              SizedBox(width: 20.w),
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  GradientProgressBar(size: Size(200.w, 20.h)),
                  SizedBox(height: 20.w),
                  GradientProgressBar(size: Size(180.w, 15.h)),

                  /*  PictureCircle(
                  height: 34.h,
                  width: 34.w,
                  imgPath: '',
                  backgroundColor: Constants.colourTextLight,
                ),*/
                  /* Obx(
                  () => Text(
                    attendanceCardController.user.value.name ?? '',
                    style: Get.textTheme.displayMedium
                        ?.copyWith(color: Constants.colourTextDark),
                  ),
                ),*/
                  /* Text(
                  attendance!.date.toString(),
                  style: Get.textTheme.displayMedium
                      ?.copyWith(color: Constants.colourTextDark),
                ),*/
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
