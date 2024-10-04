import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:stationeryhub_attendance/components/form_field_button.dart';
import 'package:stationeryhub_attendance/controllers/employee_card_controller.dart';
import 'package:stationeryhub_attendance/controllers/employee_list_screen_controller.dart';
import 'package:stationeryhub_attendance/controllers/firebase_firestore_controller.dart';
import 'package:stationeryhub_attendance/helpers/constants.dart';
import 'package:stationeryhub_attendance/models/attendance_count_view_model.dart';
import 'package:stationeryhub_attendance/scaffold/scaffold_dashboard.dart';
import 'package:stationeryhub_attendance/screens/user_onboarding_screen.dart';

import '../components/employee_card.dart';

class EmployeeListScreen extends StatelessWidget {
  const EmployeeListScreen({super.key});

  static final EmployeeCardController employeeCardController =
      Get.put(EmployeeCardController());

  @override
  Widget build(BuildContext context) {
    final employeeListScreenController =
        Get.put(EmployeeListScreenController());
    final FirebaseFirestoreController firestoreController = Get.find();
    //print(employeeListScreenController.employeeList);
    return ScaffoldDashboard(
      backgroundColour: employeeListScreenController.backgroundColor.value,
      pageTitle: Text(
        ('Employees'),
        style: Get.textTheme.displaySmall?.copyWith(color: Colors.white),
      ),
      bodyWidget: Obx(
        () => employeeListScreenController.employeeList.isEmpty
            ? buildEmptyEmployeeList()
            : buildEmployeeList(
                employeeListScreenController: employeeListScreenController),
      ),
    );
  }

  Widget buildEmployeeList(
      {required EmployeeListScreenController employeeListScreenController}) {
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
        Obx(
          () => Expanded(
            child: ListView.builder(
              itemCount: employeeListScreenController.employeeList.length,
              itemBuilder: (context, index) {
                AttendanceCountViewModel? attendanceCountView;
                if (employeeCardController.attendanceCountViewList.isNotEmpty &&
                    employeeCardController.isLoading.value == false) {
                  attendanceCountView =
                      employeeCardController.attendanceCountViewList[index];
                }
                //print('attCountView=${attendanceCountView.toString()}');
                return EmployeeCard(
                  attendanceCountView: attendanceCountView,
                  employee: employeeListScreenController.employeeList[index],
                );
              },
            ),
          ),
        )
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
