import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:stationeryhub_attendance/components/form_field_text.dart';
import 'package:stationeryhub_attendance/components/picture_circle.dart';
import 'package:stationeryhub_attendance/controllers/admin_dashboard_screen_controller.dart';
import 'package:stationeryhub_attendance/controllers/salary_management_screen_controller.dart';
import 'package:stationeryhub_attendance/helpers/constants.dart';
import 'package:stationeryhub_attendance/scaffold/scaffold_dashboard.dart';
import 'package:stationeryhub_attendance/screens/date_filter_dialog.dart';

import '../components/filter_button.dart';
import '../controllers/date_filter_dialog_controller.dart';

class SalaryManagementScreen extends StatelessWidget {
  const SalaryManagementScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final AdminDashboardScreenController adminDashboardScreenController =
        Get.find();
    final salaryManagementScreenController =
        Get.put(SalaryManagementScreenController());
    final dateFilterDialogController = Get.put(DateFilterDialogController());

    /* element.name
                  .splitMapJoin(RegExp(r"(?<=[a-z])(?=[A-Z])"),
                      onMatch: (m) => ' ')
                  .capitalize!*/
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
              child: Obx(
                () {
                  String selectedDate = DateFormat('d MMM y, E')
                      .format(dateFilterDialogController.selectedDate.value)
                      .toString();
                  String selectedRecent = dateFilterDialogController
                      .filterRecent.value.name
                      .splitMapJoin(RegExp(r"(?<=[a-z])(?=[A-Z])"),
                          onMatch: (m) => ' ')
                      .capitalize!;
                  return Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: 15.w, vertical: 10.h),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Total payout',
                              style: Get.textTheme.titleMedium!
                                  .copyWith(color: Colors.white),
                            ),
                            SizedBox(width: 10.w),
                            dateFilterDialogController.filter.value ==
                                    FilterOptions.calendar
                                ? Text(selectedDate)
                                : Text(selectedRecent),
                            ImageFiltered(
                              imageFilter: ImageFilter.blur(
                                sigmaX: 5.0,
                                sigmaY: 5.0,
                              ),
                              enabled: !salaryManagementScreenController
                                  .showTotal.value,
                              child: Text(
                                '\u{20B9}85000',
                                style: Get.textTheme.displayLarge!.copyWith(
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ],
                        ),
                        Obx(
                          () => GestureDetector(
                            onTap: () {
                              salaryManagementScreenController
                                  .invertShowTotal();
                            },
                            behavior: HitTestBehavior.translucent,
                            child: Icon(
                              salaryManagementScreenController
                                          .showTotal.value ==
                                      true
                                  ? Icons.visibility_off_outlined
                                  : Icons.visibility_outlined,
                              size: 30.w,
                              color: Colors.white,
                            ),
                          ),
                        )
                      ],
                    ),
                  );
                },
              ),
            ),
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: Padding(
                  padding: EdgeInsets.fromLTRB(12.w, 16.h, 24.w, 16.h),
                  child: SizedBox(
                    /* width: 278.w,
                    height: 50.h,*/
                    child: FormFieldText(
                      hintText: 'Search employee',
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.r),
                        borderSide:
                            BorderSide(color: Constants.colourBorderMedium),
                      ),
                      trailingWidget: Icon(
                        Icons.search,
                        color: Constants.colourBorderMedium,
                      ),
                      onChangedAction: (val) {
                        salaryManagementScreenController.filterList(val!);
                      },
                    ),
                  ),
                ),
              ),
              GestureDetector(
                onTap: () {
                  Get.dialog(
                    DateFilterDialog(),
                  );
                },
                child: Padding(
                  padding: EdgeInsets.only(right: 12.w),
                  child: Container(
                    width: 104.w,
                    height: 50.h,
                    decoration: BoxDecoration(
                      color: Colors.transparent,
                      border: Border.all(
                        color: Constants.colourBorderMedium,
                      ),
                      borderRadius: BorderRadius.circular(10.r),
                    ),
                    child: FilterButton(),
                  ),
                ),
              )
            ],
          ),
          Obx(
            () => Expanded(
              child: salaryManagementScreenController.tempEmpList.isEmpty
                  ? Center(
                      child: Text(
                        'No employee found',
                        style: Get.textTheme.displaySmall!
                            .copyWith(color: Constants.colourTextLight),
                      ),
                    )
                  : buildEmpList(salaryManagementScreenController,
                      adminDashboardScreenController),
            ),
          )
        ],
      ),
    );
  }

  ListView buildEmpList(
      SalaryManagementScreenController salaryManagementScreenController,
      AdminDashboardScreenController adminDashboardScreenController) {
    return ListView.builder(
        itemCount: salaryManagementScreenController.tempEmpList.length,
        itemBuilder: (context, index) {
          int salaryPerDay =
              (salaryManagementScreenController.tempEmpList[index].salary! /
                      adminDashboardScreenController
                          .getCurrentMonthDates(
                              month: DateTime.now().month,
                              year: DateTime.now().year)
                          .length)
                  .ceil();
          return Padding(
            padding: EdgeInsets.symmetric(vertical: 6.h, horizontal: 11.w),
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
                        padding: EdgeInsets.fromLTRB(7.w, 5.h, 17.w, 5.h),
                        child: PictureCircle(
                            height: 60.h,
                            width: 60.w,
                            imgPath: salaryManagementScreenController
                                .tempEmpList[index].profilePicPath!),
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            salaryManagementScreenController
                                .tempEmpList[index].name!,
                            style: Get.textTheme.headlineLarge!
                                .copyWith(color: Constants.colourTextDark),
                          ),
                          Row(
                            children: [
                              Image.asset(
                                  'assets/images/salary_management_screen/bag.png'),
                              SizedBox(width: 8.w),
                              Text(
                                salaryManagementScreenController
                                    .tempEmpList[index]
                                    .userType!
                                    .name
                                    .capitalizeFirst!,
                                style: Get.textTheme.titleMedium!.copyWith(
                                    color: Constants.colourTextMedium),
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
                          Obx(
                            () => ImageFiltered(
                              imageFilter: ImageFilter.blur(
                                sigmaX: 5.0,
                                sigmaY: 5.0,
                              ),
                              enabled: !salaryManagementScreenController
                                  .showTotal.value,
                              child: Text(
                                salaryPerDay.toString(),
                                style: Get.textTheme.headlineLarge!.copyWith(
                                  color: Constants.colourDashboardBox2,
                                ),
                              ),
                            ),
                          ),
                          /* Text(
                            '/day',
                            style: Get.textTheme.headlineLarge!.copyWith(
                              color: Constants.colourTextDark,
                            ),
                          )*/
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
          );
        });
  }
}
