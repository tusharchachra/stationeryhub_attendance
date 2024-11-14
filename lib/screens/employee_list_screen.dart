import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:stationeryhub_attendance/components/form_field_button.dart';
import 'package:stationeryhub_attendance/components/gradient_progress_bar.dart';
import 'package:stationeryhub_attendance/controllers/admin_dashboard_screen_controller.dart';
import 'package:stationeryhub_attendance/controllers/employee_list_screen_controller.dart';
import 'package:stationeryhub_attendance/helpers/constants.dart';
import 'package:stationeryhub_attendance/models/users_model.dart';
import 'package:stationeryhub_attendance/scaffold/scaffold_dashboard.dart';
import 'package:stationeryhub_attendance/screens/user_onboarding_screen.dart';

import '../components/employee_card.dart';

class EmployeeListScreen extends StatelessWidget {
  const EmployeeListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    //Get.put(EmployeeCardController());
    final employeeListScreenController =
        Get.put(EmployeeListScreenController());
    final AdminDashboardScreenController adminDashboardScreenController =
        Get.find();

    return ScaffoldDashboard(
      backgroundColour: employeeListScreenController.backgroundColor.value,
      pageTitle: Text(
        'Employees',
        style: Get.textTheme.displaySmall?.copyWith(color: Colors.white),
      ),
      bodyWidget: Obx(
        () => employeeListScreenController.isLoading.value == true
            ? buildPlaceholder(
                employeeListScreenController, adminDashboardScreenController)
            : adminDashboardScreenController.employeeList.isEmpty
                ? buildEmptyEmployeeList()
                : buildEmployeeList(
                    employeeListScreenController: employeeListScreenController,
                    adminDashboardScreenController:
                        adminDashboardScreenController),
      ),
    );
  }

  Widget buildPlaceholder(
      EmployeeListScreenController employeeListScreenController,
      AdminDashboardScreenController adminDashboardScreenController) {
    employeeListScreenController.backgroundColor.value =
        Constants.colourScaffoldBackground;
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Container(
          height: 65.h,
          color: Constants.colourBorderLight,
          padding: EdgeInsets.symmetric(vertical: 11.h, horizontal: 12.w),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Wrap(
                children: [
                  Icon(
                    Icons.person_add,
                    color: Constants.colourPrimary,
                    size: 17.w,
                  ),
                  SizedBox(width: 10.w),
                  buildGradientProgressBar150x20(),
                ],
              ),
              Container(
                  width: 44.w,
                  height: 44.h,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white,
                  ),
                  child: GradientProgressBar(size: Size(44.w, 44.h)))
            ],
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(vertical: 22.h, horizontal: 12.w),
          child: Row(
            children: [
              buildGradientProgressBar150x20(),
            ],
          ),
        ),
        Expanded(
          child: ListView.builder(
            itemCount: adminDashboardScreenController.employeeList.length,
            itemBuilder: (context, index) {
              return EmployeeCard(
                showPlaceholder: true,
                attendanceCountView: null,
                employee: UsersModel(),
              );
            },
          ),
        ),
      ],
    );
  }

  GradientProgressBar buildGradientProgressBar150x20() {
    return GradientProgressBar(
      size: Size(150.w, 20.h),
    );
  }

  Widget buildEmployeeList(
      {required EmployeeListScreenController employeeListScreenController,
      required AdminDashboardScreenController adminDashboardScreenController}) {
    employeeListScreenController.backgroundColor.value =
        Constants.colourScaffoldBackground;
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Container(
          height: 65.h,
          color: Constants.colourBorderLight,
          padding: EdgeInsets.symmetric(vertical: 11.h, horizontal: 12.w),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Wrap(
                children: [
                  Icon(
                    Icons.person_add,
                    color: Constants.colourPrimary,
                    size: 17.w,
                  ),
                  SizedBox(width: 10.w),
                  Text(
                    'Create new employee',
                    style: Get.textTheme.headlineMedium?.copyWith(
                      color: Constants.colourPrimary,
                    ),
                  ),
                ],
              ),
              GestureDetector(
                onTap: () {
                  Get.to(() => UserOnboardingScreen());
                },
                child: Container(
                  width: 44.w,
                  height: 44.h,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white,
                  ),
                  child: Icon(
                    Icons.add,
                  ),
                ),
              )
            ],
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(vertical: 22.h, horizontal: 12.w),
          child: Row(
            children: [
              Text(
                'Employee list',
                style: Get.textTheme.headlineMedium?.copyWith(
                  color: Constants.colourTextDark,
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: RefreshIndicator(
            onRefresh: () async {
              await employeeListScreenController.refreshScreen();
              Get.showSnackbar(
                GetSnackBar(
                  messageText: Text(
                    'Refreshed',
                    textAlign: TextAlign.center,
                    style: Get.textTheme.bodyMedium
                        ?.copyWith(color: Constants.colourTextDark),
                  ),
                  duration: const Duration(seconds: 2),
                  snackPosition: SnackPosition.BOTTOM,
                  backgroundColor: Colors.white,
                  boxShadows: [
                    BoxShadow(color: Colors.grey, blurRadius: 62.0.r),
                  ],
                  snackStyle: SnackStyle.FLOATING,
                  borderRadius: 50.r,
                  margin: EdgeInsets.all(10.w),
                ),
              );
              //return Future<void>.delayed(const Duration(seconds: 3));
            },
            backgroundColor: Colors.white,
            color: Constants.colourPrimary,
            child: ListView.builder(
              itemCount: adminDashboardScreenController.employeeList.length,
              itemBuilder: (context, index) {
                return Obx(() => EmployeeCard(
                      attendanceCountView: employeeListScreenController
                              .attendanceCountViewList.isEmpty
                          ? null
                          : employeeListScreenController
                              .attendanceCountViewList[index],
                      employee:
                          adminDashboardScreenController.employeeList[index],
                    ));
              },
            ),
          ),
        ),
      ],
    );
  }

  Column buildEmptyEmployeeList() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Wrap(
          alignment: WrapAlignment.center,
          children: [
            Image.asset('assets/images/employeeListBackground.png'),
            Text(
              'No employees found',
              style: Get.textTheme.headlineMedium
                  ?.copyWith(color: Constants.colourTextMedium),
            ),
          ],
        ),
        Align(
          alignment: Alignment.bottomCenter,
          child: FormFieldButton(
              width: 384.w,
              height: 56.h,
              buttonText: '+ Create new employee',
              onTapAction: () {}),
        )
      ],
    );
  }
}
