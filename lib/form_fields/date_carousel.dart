import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../controllers/admin_dashboard_screen_controller.dart';
import '../helpers/constants.dart';

class DateCarousel extends StatelessWidget {
  const DateCarousel({
    super.key,
  });

  static AdminDashboardScreenController adminDashboardScreenController =
      Get.find();

  @override
  Widget build(BuildContext context) {
    List<int> years = List<int>.generate(
        /*DateTime.now().year*/ 2026 - 2020, (i) => (i + 1) + 2020);
    List<String> months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec'
    ];

    return Obx(
      () => Column(
        children: [
          //for year
          CarouselSlider(
            disableGesture: false,
            carouselController:
                adminDashboardScreenController.yearCarouselController.value,
            items: years.map(
              (item) {
                return Builder(builder: (BuildContext context) {
                  return GestureDetector(
                    onTap: () {
                      if (item <= (DateTime.now().year)) {
                        adminDashboardScreenController.selectedYear.value =
                            item;

                        adminDashboardScreenController.selectedDate.value =
                            DateTime(
                                adminDashboardScreenController
                                    .selectedYear.value,
                                adminDashboardScreenController
                                    .selectedDate.value.month,
                                adminDashboardScreenController
                                    .selectedDay.value);
                        print(
                            'selected Date=${adminDashboardScreenController.selectedDate}');
                      }
                    },
                    child: Container(
                      width: 50.w,
                      height: 525.h,
                      alignment: Alignment.center,
                      decoration: getContainerDecoration(
                          condition1: item > (DateTime.now().year),
                          condition2: /* item ==
                            adminDashboardScreenController
                                .selectedDate.value.year,*/
                              item ==
                                  adminDashboardScreenController
                                      .selectedYear.value),
                      child: Text(
                        item.toString(),
                        style: /*item ==
                                adminDashboardScreenController
                                    .selectedYear.value.year*/
                            item ==
                                    adminDashboardScreenController
                                        .selectedYear.value
                                ? Get.textTheme.bodySmall
                                : Get.textTheme.displaySmall,
                      ),
                    ),
                  );
                });
              },
            ).toList(),
            options: CarouselOptions(
              initialPage: years
                  .indexOf(adminDashboardScreenController.selectedYear.value),
              height: 40.h,
              enableInfiniteScroll: false,
              viewportFraction: 0.2.w,
              onPageChanged: (index, reason) {
                //adminDashboardScreenController.selectedDate = index;
              },
            ),
          ),
          //for month
          CarouselSlider(
            disableGesture: false,
            carouselController:
                adminDashboardScreenController.yearCarouselController.value,
            items: List.generate(12, (i) => months[i]).map(
              (item) {
                return Builder(builder: (BuildContext context) {
                  return GestureDetector(
                    onTap: () {
                      /*if (item <= (DateTime.now().year)) {
                        adminDashboardScreenController.selectedYear.value =
                            item;

                        adminDashboardScreenController.selectedDate.value =
                            DateTime(
                                adminDashboardScreenController
                                    .selectedYear.value,
                                adminDashboardScreenController
                                    .selectedDate.value.month,
                                adminDashboardScreenController
                                    .selectedDay.value);
                        print(
                            'selected Date=${adminDashboardScreenController.selectedDate}');
                      }*/
                    },
                    child: Container(
                      width: 50.w,
                      height: 25.h,
                      alignment: Alignment.center,
                      decoration: getContainerDecoration(
                          condition1:
                              months.indexOf(item) >= DateTime.now().month,
                          condition2: /* item ==
                            adminDashboardScreenController
                                .selectedDate.value.year,*/
                              item ==
                                  adminDashboardScreenController
                                      .selectedMonth.value
                                      .toString()),
                      child: Text(
                        item.toString(),
                        style: /*item ==
                                adminDashboardScreenController
                                    .selectedYear.value.year*/
                            item ==
                                    adminDashboardScreenController
                                        .selectedMonth.value
                                        .toString()
                                ? Get.textTheme.bodySmall
                                : Get.textTheme.displaySmall,
                      ),
                    ),
                  );
                });
              },
            ).toList(),
            options: CarouselOptions(
              initialPage: years
                  .indexOf(adminDashboardScreenController.selectedYear.value),
              height: 40.h,
              enableInfiniteScroll: false,
              viewportFraction: 0.2.w,
              onPageChanged: (index, reason) {
                //adminDashboardScreenController.selectedDate = index;
              },
            ),
          ),
          //for day
          CarouselSlider(
            disableGesture: false,
            carouselController:
                adminDashboardScreenController.yearCarouselController.value,
            options: CarouselOptions(
              initialPage:
                  adminDashboardScreenController.selectedDate.value.day - 1,
              height: 80.h,
              enableInfiniteScroll: false,
              viewportFraction: 0.25.w,
              onPageChanged: (index, reason) {
                //adminDashboardScreenController.selectedDate = index;
              },
            ),
            items: adminDashboardScreenController
                .getCurrentMonthDates(
              month: adminDashboardScreenController.selectedDate.value.month,
              year: adminDashboardScreenController.selectedDate.value.year,
            )
                .map(
              (item) {
                return Builder(builder: (BuildContext context) {
                  return GestureDetector(
                    onTap: () {
                      if (item <= (DateTime.now().day)) {
                        adminDashboardScreenController.selectedDay.value = item;
                        adminDashboardScreenController.selectedDate.value =
                            DateTime(
                                adminDashboardScreenController
                                    .selectedDate.value.year,
                                adminDashboardScreenController
                                    .selectedDate.value.month,
                                adminDashboardScreenController
                                    .selectedDay.value);
                        print(
                            'selected Date=${adminDashboardScreenController.selectedDate}');
                      }
                    },
                    child: Container(
                      width: 76.w,
                      height: 80.h,
                      alignment: Alignment.center,
                      decoration: getContainerDecoration(
                          condition1: item > (DateTime.now().day),
                          condition2: /* item ==
                            adminDashboardScreenController
                                .selectedDate.value.year,*/
                              item ==
                                  adminDashboardScreenController
                                      .selectedDay.value),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            item.toString(),
                            style: item ==
                                    adminDashboardScreenController
                                        .selectedDay.value
                                ? Get.textTheme.headlineLarge
                                : Get.textTheme.displayLarge,
                          ),
                          Text(
                            DateFormat.E().format(adminDashboardScreenController
                                .selectedDate.value),
                            style: item ==
                                    adminDashboardScreenController
                                        .selectedDate.value.day
                                ? Get.textTheme.bodyLarge
                                : Get.textTheme.displayMedium,
                          ),
                        ],
                      ),
                    ),
                  );
                });
              },
            ).toList(),
          ),
          //for day
          /*CarouselSlider(
              disableGesture: false,
              carouselController:
                  adminDashboardScreenController.dateCarouselController.value,
              options: CarouselOptions(
                initialPage:
                    adminDashboardScreenController.selectedDate.value.day - 1,
                height: 80.h,
                enableInfiniteScroll: false,
                viewportFraction: 0.25.w,
                onPageChanged: (index, reason) {
                  //adminDashboardScreenController.selectedDate = index;
                },
              ),
              items: adminDashboardScreenController
                  .getCurrentMonthDates(
                month: adminDashboardScreenController.selectedDate.value.month,
                year: adminDashboardScreenController.selectedDate.value.year,
              )
                  .map(
                (item) {
                  return Builder(builder: (BuildContext context) {
                    return GestureDetector(
                      onTap: () {
                        if (item.compareTo(DateTime.now()) <= 0) {
                          adminDashboardScreenController.selectedDate.value =
                              item;
                        }
                      },
                      child: Container(
                        width: 76.w,
                        height: 80.h,
                        decoration: item.compareTo(DateTime.now()) > 0
                            ? Constants.inactiveDateBoxDecoration
                            : item.day ==
                                    adminDashboardScreenController
                                        .selectedDate.value.day
                                ? Constants.selectedDateBoxDecoration
                                : Constants.unselectedDateBoxDecoration,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              DateFormat.d().format(item),
                              style: item.day ==
                                      adminDashboardScreenController
                                          .selectedDate.value.day
                                  ? Get.textTheme.headlineLarge
                                  : Get.textTheme.displayLarge,
                            ),
                            Text(
                              DateFormat.E().format(item),
                              style: item.day ==
                                      adminDashboardScreenController
                                          .selectedDate.value.day
                                  ? Get.textTheme.bodyLarge
                                  : Get.textTheme.displayMedium,
                            ),
                          ],
                        ),
                      ),
                    );
                  });
                },
              ).toList()),*/
        ],
      ),
    );
  }

  BoxDecoration getContainerDecoration(
      {required bool condition1, required condition2}) {
    return condition1
        ? Constants.inactiveYearBoxDecoration
        : condition2
            ? Constants.selectedYearBoxDecoration
            : Constants.unselectedYearBoxDecoration;
  }
}
