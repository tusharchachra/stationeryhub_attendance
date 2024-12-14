import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:stationeryhub_attendance/controllers/attendance_list_day_controller.dart';

import '../controllers/admin_dashboard_screen_controller.dart';
import '../helpers/constants.dart';

class DateCarousel extends StatelessWidget {
  const DateCarousel({
    super.key,
  });

  static AdminDashboardScreenController adminDashboardScreenController =
      Get.find();
  static AttendanceListDayController attendanceListDayController = Get.find();

  @override
  Widget build(BuildContext context) {
    ///TODO: change 2020 to 2023, uncomment DateTime.now().year, remove 2027

    /*List<int> years = List<int>.generate(2027 - 2020, (i) => (i + 1) + 2020);*/
    List<int> years =
        List<int>.generate(DateTime.now().year - 2023, (i) => (i + 1) + 2023);
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
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          //for year
          /* Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Expanded(
                  child: Container(
                      padding: EdgeInsets.symmetric(vertical: 10.h),
                      color: Constants.colourDashboardBox4,
                      child: buildYearCarousel(years))),
              //for month
              Expanded(
                  child: Container(
                      padding: EdgeInsets.symmetric(vertical: 10.h),
                      color: Constants.colourDashboardBox5,
                      child: buildMonthCarousel(months))),
            ],
          ),*/

          //for day
          buildDayCarousel(),
        ],
      ),
    );
  }

  CarouselSlider buildYearCarousel(List<int> years) {
    return CarouselSlider(
      disableGesture: false,
      carouselController:
          adminDashboardScreenController.yearCarouselController.value,
      options: CarouselOptions(
        initialPage:
            years.indexOf(adminDashboardScreenController.selectedYear.value),
        height: 30.h,
        enableInfiniteScroll: false,
        viewportFraction: 0.3.w,
        scrollPhysics: BouncingScrollPhysics(),
        onPageChanged: (index, reason) {
          //adminDashboardScreenController.selectedDate = index;
        },
      ),
      items: years.map(
        (item) {
          return Builder(builder: (BuildContext context) {
            return GestureDetector(
              onTap: () {
                adminDashboardScreenController.selectedYear.value = item;
                adminDashboardScreenController.setDate();
              },
              child: Container(
                width: 50.w,
                height: 525.h,
                alignment: Alignment.center,
                decoration: getYearDecoration(item),
                child: Text(
                  item.toString(),
                  style:
                      item == adminDashboardScreenController.selectedYear.value
                          ? Get.textTheme.bodySmall
                          : Get.textTheme.displaySmall,
                ),
              ),
            );
          });
        },
      ).toList(),
    );
  }

  BoxDecoration getYearDecoration(int item) {
    if (item > (DateTime.now().year)) {
      return Constants.inactiveYearBoxDecoration;
    } else {
      if (item == adminDashboardScreenController.selectedYear.value) {
        return Constants.selectedYearBoxDecoration;
      } else {
        return Constants.unselectedYearBoxDecoration;
      }
    }

    /*return getContainerDecoration(
        inactiveDecorationCondition: item > (DateTime.now().year),
        selectedDecorationCondition:
            item == adminDashboardScreenController.selectedYear.value);*/
  }

  CarouselSlider buildMonthCarousel(List<String> months) {
    return CarouselSlider(
      disableGesture: false,
      carouselController:
          adminDashboardScreenController.yearCarouselController.value,
      options: CarouselOptions(
        initialPage: /*months.indexOf*/
            (adminDashboardScreenController.selectedDate.value.month) - 1,
        height: 30.h,
        enableInfiniteScroll: false,
        viewportFraction: 0.3.w,
        scrollPhysics: BouncingScrollPhysics(),
        onPageChanged: (index, reason) {
          //adminDashboardScreenController.selectedDate = index;
        },
      ),
      items: List.generate(12, (i) => months[i]).map(
        (item) {
          return Builder(builder: (BuildContext context) {
            return GestureDetector(
              onTap: () {
                adminDashboardScreenController.selectedMonth.value =
                    months.indexOf(item) + 1;
                adminDashboardScreenController.setDate();
              },
              child: Container(
                width: 50.w,
                height: 25.h,
                alignment: Alignment.center,
                decoration: getMonthDecoration(months, item),
                child: Text(
                  item.toString(),
                  style: months.indexOf(item) ==
                          adminDashboardScreenController.selectedMonth.value - 1
                      ? Get.textTheme.bodySmall
                      : Get.textTheme.displaySmall,
                ),
              ),
            );
          });
        },
      ).toList(),
    );
  }

  BoxDecoration getMonthDecoration(List<String> months, String item) {
    if (adminDashboardScreenController.selectedDate.value.year >
        DateTime.now().year) {
      return Constants.inactiveYearBoxDecoration;
    } else if (adminDashboardScreenController.selectedDate.value.year ==
            DateTime.now().year &&
        months.indexOf(item) >= DateTime.now().month) {
      return Constants.inactiveYearBoxDecoration;
    } else if (months.indexOf(item) ==
        adminDashboardScreenController.selectedMonth.value - 1) {
      return Constants.selectedYearBoxDecoration;
    } else {
      return Constants.unselectedYearBoxDecoration;
    }

    /*return getContainerDecoration(
                inactiveDecorationCondition: ((adminDashboardScreenController
                            .selectedDate.value.year >
                        DateTime.now().year) ||
                    (adminDashboardScreenController.selectedDate.value.year ==
                            DateTime.now().year &&
                        months.indexOf(item) >= DateTime.now().month)),
                selectedDecorationCondition: months.indexOf(item) ==
                    adminDashboardScreenController.selectedMonth.value - 1,
              );*/
  }

  CarouselSlider buildDayCarousel() {
    return CarouselSlider(
      disableGesture: false,
      carouselController:
          adminDashboardScreenController.yearCarouselController.value,
      options: CarouselOptions(
        initialPage: adminDashboardScreenController.selectedDate.value.day - 1,
        height: 80.h,
        enableInfiniteScroll: false,
        viewportFraction: 0.25.w,
        scrollPhysics: BouncingScrollPhysics(),
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
                adminDashboardScreenController.selectedDay.value = item;
                adminDashboardScreenController.setDate();
                attendanceListDayController.loadAttendance();
              },
              child: Container(
                width: 76.w,
                height: 80.h,
                alignment: Alignment.center,
                decoration: getDayDecoration(item),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      item.toString(),
                      style: item ==
                              adminDashboardScreenController.selectedDay.value
                          ? Get.textTheme.bodyLarge
                              ?.copyWith(color: Colors.white)
                          : Get.textTheme.bodyLarge
                              ?.copyWith(color: Constants.colourTextDark),
                    ),
                    Text(
                      DateFormat.E().format(DateTime(
                          adminDashboardScreenController.selectedYear.value,
                          adminDashboardScreenController.selectedMonth.value,
                          item)),
                      style: item ==
                              adminDashboardScreenController
                                  .selectedDate.value.day
                          ? Get.textTheme.titleMedium
                              ?.copyWith(color: Colors.white)
                          : Get.textTheme.titleMedium
                              ?.copyWith(color: Constants.colourTextDark),
                    ),
                  ],
                ),
              ),
            );
          });
        },
      ).toList(),
    );
  }

  BoxDecoration getDayDecoration(int item) {
    if (adminDashboardScreenController.selectedDate.value.year >
            DateTime.now().year &&
        adminDashboardScreenController.selectedDate.value.month >
            DateTime.now().month &&
        item > DateTime.now().day) {
      return Constants.inactiveYearBoxDecoration;
    } else if (adminDashboardScreenController.selectedDate.value.year ==
            DateTime.now().year &&
        adminDashboardScreenController.selectedDate.value.month ==
            DateTime.now().month &&
        (item) > DateTime.now().day) {
      return Constants.inactiveDateBoxDecoration;
    } else if (item == adminDashboardScreenController.selectedDay.value) {
      return Constants.selectedYearBoxDecoration;
    } else {
      return Constants.unselectedYearBoxDecoration;
    }

    /* return getContainerDecoration(
                  inactiveDecorationCondition: (adminDashboardScreenController
                                  .selectedDate.value.year >
                              DateTime.now().year &&
                          adminDashboardScreenController
                                  .selectedDate.value.month >
                              DateTime.now().month &&
                          item > DateTime.now().day) ||
                      (adminDashboardScreenController
                                  .selectedDate.value.year ==
                              DateTime.now().year &&
                          adminDashboardScreenController
                                  .selectedDate.value.month ==
                              DateTime.now().month &&
                          (item) > DateTime.now().day),
                  selectedDecorationCondition: item ==
                      adminDashboardScreenController.selectedDay.value);*/
  }

  BoxDecoration getContainerDecoration(
      {required bool inactiveDecorationCondition,
      required selectedDecorationCondition}) {
    return inactiveDecorationCondition
        ? Constants.inactiveYearBoxDecoration
        : selectedDecorationCondition
            ? Constants.selectedYearBoxDecoration
            : Constants.unselectedYearBoxDecoration;
  }
}
