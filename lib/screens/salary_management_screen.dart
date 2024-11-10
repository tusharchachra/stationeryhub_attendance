import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:stationeryhub_attendance/helpers/constants.dart';
import 'package:stationeryhub_attendance/scaffold/scaffold_dashboard.dart';

class SalaryManagementScreen extends StatelessWidget {
  const SalaryManagementScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ScaffoldDashboard(
      pageTitle: Text(
        'Manage Salary',
        style: Get.textTheme.displaySmall?.copyWith(color: Colors.white),
      ),
      bodyWidget: Column(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 11.w, vertical: 12.h),
            child: Container(
              height: 111.h,
              width: 406.w,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10.r),
                gradient: Constants.gradientPayTotal,
                image: const DecorationImage(
                  image: AssetImage(
                      'assets/images/salary_management_screen/totalPayBoxBkgnd.png'),
                  alignment: Alignment.centerRight,
                ),
              ),
              child: Column(
                children: [
                  Text('Total pyout'),
                  Text('\u{20B9}85000'),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
