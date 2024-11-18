import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:stationeryhub_attendance/components/filter_button.dart';
import 'package:stationeryhub_attendance/components/form_field_button.dart';
import 'package:stationeryhub_attendance/controllers/date_filter_dialog_controller.dart';

import '../helpers/constants.dart';

enum FilterOptions { calendar, recent }

enum FilterRecent { today, yesterday, thisWeek, thisMonth, lastWeek, lastMonth }

class DateFilterDialog extends StatelessWidget {
  const DateFilterDialog({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    //FilterOptions filter = FilterOptions.calendar;
    /*final dateFilterDialogController = Get.put(DateFilterDialogController());*/
    final DateFilterDialogController dateFilterDialogController = Get.find();

    return BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 1.0, sigmaY: 1.0),
      child: SizedBox(
        height: 100.h,
        /*decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(40.r),
        ),*/
        child: Dialog(
          backgroundColor: Colors.white,
          child: Padding(
            padding: EdgeInsets.fromLTRB(32.w, 24.h, 32.w, 46.h),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    FilterButton(),
                    GestureDetector(
                      onTap: () {
                        Get.back();
                      },
                      child: Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Constants.colourBorderLight,
                          ),
                          child: Padding(
                            padding: EdgeInsets.all(5.w),
                            child: Icon(
                              Icons.close,
                              color: Constants.colourTextDark,
                              size: 22.w,
                            ),
                          )),
                    ),
                  ],
                ),
                Obx(
                  () => SegmentedButton<FilterOptions>(
                    style: SegmentedButton.styleFrom(
                      side: BorderSide(color: Constants.colourBorderMedium),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(50.0),
                      ),
                      padding: EdgeInsets.symmetric(
                          horizontal: 27.w, vertical: 12.h),
                      //backgroundColor: Colors.transparent,
                      selectedBackgroundColor: Constants.colourPrimary,
                      selectedForegroundColor: Colors.white,
                      disabledForegroundColor: Constants.colourBorderMedium,
                      disabledBackgroundColor: Colors.transparent,
                    ),
                    showSelectedIcon: false,
                    segments: <ButtonSegment<FilterOptions>>[
                      ButtonSegment<FilterOptions>(
                        value: FilterOptions.calendar,
                        label: Text(
                          'Calendar',
                          style: TextStyle(
                              fontSize: Get.textTheme.titleMedium!.fontSize),
                        ),
                      ),
                      ButtonSegment<FilterOptions>(
                        value: FilterOptions.recent,
                        label: Text(
                          'Recent',
                          style: TextStyle(
                              fontSize: Get.textTheme.titleMedium!.fontSize),
                        ),
                      ),
                    ],
                    selected: <FilterOptions>{
                      dateFilterDialogController.filter.value
                    },
                    onSelectionChanged: (Set<FilterOptions> newSelection) {
                      dateFilterDialogController.filter.value =
                          newSelection.first;
                      print(dateFilterDialogController.filter.value);
                    },
                  ),
                ),
                Obx(
                  () => SizedBox(
                      width: 378.w,
                      child: dateFilterDialogController.filter.value ==
                              FilterOptions.calendar
                          ? CalendarDatePicker(
                              currentDate: DateTime.now(),
                              initialDate:
                                  dateFilterDialogController.selectedDate.value,
                              firstDate: DateTime(DateTime.now().year - 10,
                                  DateTime.january, DateTime.sunday),
                              lastDate: DateTime.now(),
                              onDateChanged: (newDate) {
                                dateFilterDialogController.selectedDate.value =
                                    newDate;
                              },
                            )
                          : ListView(
                              shrinkWrap: true,
                              children: FilterRecent.values
                                  .map(
                                    //split the enum values based on the input. This splits after a lower-case letter and before an upper case letter and adds a space between them
                                    (element) => buildRecentOptions(
                                        dateFilterDialogController:
                                            dateFilterDialogController,
                                        element: element),
                                  )
                                  .toList(),
                            )),
                ),
                FormFieldButton(
                  width: 314.w,
                  height: 50.h,
                  buttonText: 'Apply',
                  onTapAction: () {
                    Get.back();
                  },
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  GestureDetector buildRecentOptions(
      {required DateFilterDialogController dateFilterDialogController,
      required FilterRecent element}) {
    String elementString = element.name
        .splitMapJoin(RegExp(r"(?<=[a-z])(?=[A-Z])"), onMatch: (m) => ' ')
        .capitalize!;
    return GestureDetector(
      onTap: () {
        dateFilterDialogController.filterRecent.value =
            FilterRecent.values.firstWhere((val) => val.name == element.name);
      },
      behavior: HitTestBehavior.translucent,
      child: Container(
        padding: EdgeInsets.fromLTRB(16.w, 18.h, 8.w, 18.h),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              elementString,
              style: Get.textTheme.displaySmall!.copyWith(
                  color:
                      dateFilterDialogController.filterRecent.value == element
                          ? Constants.colourPrimary
                          : Constants.colourTextLight),
            ),
            dateFilterDialogController.filterRecent.value == element
                ? Image.asset('assets/images/activeCircle.png')
                : Image.asset('assets/images/inactiveCircle.png')
          ],
        ),
      ),
    );
  }
}
