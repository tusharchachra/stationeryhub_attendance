import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:stationeryhub_attendance/components/picture_circle.dart';
import 'package:stationeryhub_attendance/controllers/employee_card_controller.dart';
import 'package:stationeryhub_attendance/helpers/constants.dart';
import 'package:stationeryhub_attendance/models/attendance_count_view_model.dart';
import 'package:stationeryhub_attendance/models/user_type_enum.dart';
import 'package:stationeryhub_attendance/models/users_model.dart';

class EmployeeCard extends StatelessWidget {
  const EmployeeCard(
      {super.key, required this.employee, this.attendanceCountView});
  final UsersModel employee;
  final AttendanceCountViewModel? attendanceCountView;

  @override
  Widget build(BuildContext context) {
    final EmployeeCardController employeeCardController =
        Get.put(EmployeeCardController());

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(4.r),
          border: Border.all(color: Constants.colourBorderMedium, width: 1.w),
        ),
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 3.h),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Wrap(
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: [
                      PictureCircle(
                        height: 38.h,
                        width: 53.w,
                        imgPath: employee.profilePicPath!,
                        isNetworkPath: true,
                      ),
                      Text(
                        employee.name ?? '',
                        style: Get.textTheme.headlineLarge
                            ?.copyWith(color: Constants.colourTextDark),
                      ),
                    ],
                  ),
                  Wrap(
                    children: [
                      Container(
                        padding: EdgeInsets.symmetric(
                            vertical: 6.h, horizontal: 9.w),
                        decoration: BoxDecoration(
                          color: employee.userType == UserType.employee
                              ? Constants.employeeBoxColour
                              : employee.userType == UserType.admin
                                  ? Constants.adminBoxColour
                                  : Constants.colourTextLight,
                          borderRadius: BorderRadius.all(
                            Radius.circular(2.r),
                          ),
                        ),
                        child: Text(
                          employee.userType!.getName().capitalizeFirst!,
                          style: Get.textTheme.titleSmall?.copyWith(
                              color: employee.userType == UserType.employee
                                  ? Constants.employeeTextColour
                                  : employee.userType == UserType.admin
                                      ? Constants.adminTextColour
                                      : Constants.colourTextLight),
                        ),
                      ),
                      SizedBox(width: 18.w),
                      const Icon(
                        Icons.more_vert,
                        color: Constants.colourTextDark,
                      )
                    ],
                  )
                ],
              ),
            ),
            // SizedBox(height: 20.h),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
              child: Row(
                children: [
                  Wrap(
                    children: [
                      Icon(
                        Icons.phone,
                        color: Constants.colourTextDark,
                        size: 19.w,
                      ),
                      SizedBox(width: 6.w),
                      Text(
                        employee.phoneNum!,
                        style: Get.textTheme.titleMedium?.copyWith(
                          color: Constants.colourTextDark,
                        ),
                      )
                    ],
                  )
                ],
              ),
            ),
            Divider(
              height: 1.h,
              color: Constants.colourBorderMedium,
            ),
            SizedBox(height: 5.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                buildAttendanceColumn(
                    controller: employeeCardController,
                    title: 'Present',
                    body: ''),
                buildDivider(),
                /* buildAttendanceColumn(title: 'Absent', body: ''),
                buildDivider(),
                buildAttendanceColumn(title: 'Total hours', body: ''),*/
              ],
            )
          ],
        ),
      ),
    );
  }

  Container buildDivider() {
    return Container(
      width: 1.w,
      height: 62.h,
      decoration: const BoxDecoration(
        color: Constants.colourBorderMedium,
      ),
    );
  }

  Widget buildAttendanceColumn(
      {required EmployeeCardController controller,
      required String title,
      required String body}) {
    final EmployeeCardController employeeCardController =
        Get.put(EmployeeCardController());
    DateTime start = DateTime(DateTime.now().year, DateTime.now().month - 1, 1);

    ///TODO: remove (-1) from month
    DateTime end = DateTime(
        DateTime.now().year,
        DateTime.now().month - 1,
        DateUtils.getDaysInMonth(
            DateTime.now().year, DateTime.now().month - 1));
    employeeCardController.loadAttendance(
        empId: employee.userId!, startDate: start, endDate: end);

    return /*Obx(() => controller.isLoading.value == true
        ? CircularProgressIndicator()
        : */
        Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          title,
          style: Get.textTheme.titleMedium?.copyWith(
            color: Constants.colourTextDark,
          ),
        ),
        Text(
          attendanceCountView == null
              ? ''
              : attendanceCountView!.attendanceCount.length.toString(),
          style: Get.textTheme.titleMedium?.copyWith(color: Colors.blue),
        )
      ],
      // ),
    );
  }
}
