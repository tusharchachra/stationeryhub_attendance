import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:stationeryhub_attendance/helpers/constants.dart';
import 'package:stationeryhub_attendance/scaffold/scaffold_dashboard.dart';
import 'package:stationeryhub_attendance/screens/employee_list_screen.dart';
import 'package:stationeryhub_attendance/screens/leave_management_screen.dart';
import 'package:stationeryhub_attendance/screens/manage_salary_screen.dart';
import 'package:stationeryhub_attendance/screens/user_onboarding_screen.dart';

class EmployeeOptionsScreen extends StatelessWidget {
  const EmployeeOptionsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ScaffoldDashboard(
      pageTitle: Text(
        'Employees',
        style: Get.textTheme.displaySmall?.copyWith(color: Colors.white),
      ),
      bodyWidget: Padding(
        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 25.h),
        child: Column(
          //mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            buildOption(
              title: 'Add new employee',
              imgPath: 'assets/images/employee_options_screen/add.png',
              onTap: () {
                Get.to(() => UserOnboardingScreen());
              },
            ),
            buildOption(
              title: 'Employee List',
              imgPath: 'assets/images/employee_options_screen/list.png',
              onTap: () {
                Get.to(() => EmployeeListScreen());
              },
            ),
            buildOption(
              title: 'Working hours',
              imgPath: 'assets/images/employee_options_screen/hours.png',
              onTap: () {},
            ),
            buildOption(
              title: 'Manage Salary',
              imgPath: 'assets/images/employee_options_screen/salary.png',
              onTap: () {
                Get.to(() => ManageSalaryScreen());
              },
            ),
            buildOption(
              title: 'Payout slip',
              imgPath: 'assets/images/employee_options_screen/salarySlip.png',
              onTap: () {},
            ),
            buildOption(
              title: 'Manage leave requests',
              imgPath: 'assets/images/employee_options_screen/salarySlip.png',
              onTap: () {
                Get.to(() => LeaveManagementScreen());
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget buildOption(
      {required String title,
      required String imgPath,
      required Function onTap}) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 0, vertical: 9.h),
      child: GestureDetector(
        onTap: () {
          onTap();
        },
        child: Container(
          height: 60.h,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(4.r),
            border: Border.all(
              color: Constants.colourBorderMedium,
            ),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                width: 4.w,
                decoration: BoxDecoration(
                  color: Constants.colourPrimary,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(4.r),
                    bottomLeft: Radius.circular(4.r),
                  ),
                ),
              ),
              SizedBox(width: 20.w),
              Image.asset(
                imgPath,
                height: 36.h,
                width: 36.w,
              ),
              SizedBox(width: 26.w),
              Expanded(
                child: Text(
                  title,
                  style: Get.textTheme.titleMedium
                      ?.copyWith(color: Constants.colourTextDark),
                ),
              ),
              Align(
                alignment: Alignment.centerRight,
                child: Icon(
                  Icons.arrow_forward_ios_rounded,
                  size: 14.w,
                  color: Constants.colourTextLight,
                ),
              ),
              SizedBox(width: 15.w),
            ],
          ),
        ),
      ),
    );
  }
}
