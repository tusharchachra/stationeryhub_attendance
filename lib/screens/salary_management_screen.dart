import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:stationeryhub_attendance/components/picture_circle.dart';
import 'package:stationeryhub_attendance/controllers/admin_dashboard_screen_controller.dart';
import 'package:stationeryhub_attendance/helpers/constants.dart';
import 'package:stationeryhub_attendance/scaffold/scaffold_dashboard.dart';

class SalaryManagementScreen extends StatelessWidget {
  const SalaryManagementScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final AdminDashboardScreenController adminDashboardScreenController =
        Get.find();
    print(adminDashboardScreenController.employeeList.toString());
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
              width: 1.sw,
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
                  Text('Total payout'),
                  Text('\u{20B9}85000'),
                ],
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
                itemCount: adminDashboardScreenController.employeeList.length,
                itemBuilder: (context, index) {
                  int salaryPerDay = (adminDashboardScreenController
                              .employeeList[index].salary! /
                          adminDashboardScreenController
                              .getCurrentMonthDates(
                                  month: DateTime.now().month,
                                  year: DateTime.now().year)
                              .length)
                      .ceil();
                  return Padding(
                    padding:
                        EdgeInsets.symmetric(vertical: 6.h, horizontal: 11.w),
                    child: Container(
                      width: 1.sw,
                      height: 73.h,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10.r),
                        border: Border.all(color: Constants.colourBorderLight),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Wrap(
                            crossAxisAlignment: WrapCrossAlignment.center,
                            children: [
                              Padding(
                                padding:
                                    EdgeInsets.fromLTRB(7.w, 5.h, 17.w, 5.h),
                                child: PictureCircle(
                                    height: 60.h,
                                    width: 60.w,
                                    imgPath: adminDashboardScreenController
                                        .employeeList[index].profilePicPath!),
                              ),
                              Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    adminDashboardScreenController
                                        .employeeList[index].name!,
                                    style: Get.textTheme.headlineLarge!
                                        .copyWith(
                                            color: Constants.colourTextDark),
                                  ),
                                  Row(
                                    children: [
                                      Image.asset(
                                          'assets/images/salary_management_screen/bag.png'),
                                      SizedBox(width: 8.w),
                                      Text(
                                        adminDashboardScreenController
                                            .employeeList[index]
                                            .userType!
                                            .name
                                            .capitalizeFirst!,
                                        style: Get.textTheme.titleMedium!
                                            .copyWith(
                                                color:
                                                    Constants.colourTextMedium),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 17.0.w),
                            child: Align(
                              alignment: Alignment.centerRight,
                              child: Wrap(
                                children: [
                                  Text(
                                    salaryPerDay.toString(),
                                    style:
                                        Get.textTheme.headlineLarge!.copyWith(
                                      color: Constants.colourDashboardBox2,
                                    ),
                                  ),
                                  Text(
                                    '/day',
                                    style:
                                        Get.textTheme.headlineLarge!.copyWith(
                                      color: Constants.colourTextDark,
                                    ),
                                  )
                                ],
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  );
                }),
          )
        ],
      ),
    );
  }
}
