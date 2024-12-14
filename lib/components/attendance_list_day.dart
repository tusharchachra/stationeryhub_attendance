import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:stationeryhub_attendance/components/gradient_progress_bar.dart';
import 'package:stationeryhub_attendance/components/picture_circle.dart';
import 'package:stationeryhub_attendance/controllers/attendance_list_day_controller.dart';
import 'package:stationeryhub_attendance/helpers/constants.dart';

class AttendanceListDay extends StatelessWidget {
  const AttendanceListDay({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final attendanceListDayController = Get.put(AttendanceListDayController());
    attendanceListDayController.loadAttendance();
    return Obx(
      () => attendanceListDayController.isLoading.isTrue
          ? CircularProgressIndicator()
          : Expanded(
              child: ListView.builder(
                  itemCount:
                      attendanceListDayController.attendanceViewList.length,
                  shrinkWrap: true,
                  itemBuilder: (context, index) => attendanceListDayController
                          .attendanceViewList[index].attendance.isEmpty
                      ? Container()
                      : buildView(index)),
            ),
    );
  }

  Padding buildView(int index) {
    final AttendanceListDayController attendanceCardDayController = Get.find();
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 14.h),
      child: Container(
        // width: 405.w,
        height: 132.h,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(5.r),
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 12.h),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            mainAxisSize: MainAxisSize.min,
            //crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Wrap(
                    alignment: WrapAlignment.start,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: [
                      PictureCircle(
                        height: 34.h,
                        width: 34.w,
                        imgPath: attendanceCardDayController
                            .attendanceViewList[index].user.profilePicPath!,
                        backgroundColor: Constants.colourTextLight,
                      ),
                      SizedBox(width: 12.w),
                      Text(
                        attendanceCardDayController
                                .attendanceViewList[index].user.name ??
                            '',
                        style: Get.textTheme.titleLarge
                            ?.copyWith(color: Constants.colourTextDark),
                      ),
                    ],
                  ),
                  if (attendanceCardDayController
                          .attendanceViewList[index].attendance.length ==
                      1)
                    Container(
                      padding: EdgeInsets.symmetric(
                          horizontal: 17.w, vertical: 10.h),
                      decoration: BoxDecoration(
                          color: Constants.colourError.withOpacity(0.3),
                          borderRadius:
                              BorderRadius.all(Radius.circular(2.5.r))),
                      child: Text(
                        'Absent',
                        style: Get.textTheme.titleMedium
                            ?.copyWith(color: Constants.colourError),
                      ),
                    )
                ],
              ),
              if (attendanceCardDayController
                      .attendanceViewList[index].attendance.length >
                  2)
                Expanded(
                  child: buildDuration((attendanceCardDayController
                          .attendanceViewList[index].attendance[2].dateTime!)
                      .difference(attendanceCardDayController
                          .attendanceViewList[index].attendance[1].dateTime!)),
                ),
              Expanded(
                child: ListView.separated(
                  separatorBuilder: (context, index) => Container(
                    height: 25.h,
                    width: 0.8.w,
                    color: Constants.colourBorderMedium,
                  ),
                  itemCount: attendanceCardDayController
                      .attendanceViewList[index].attendance.length,
                  scrollDirection: Axis.horizontal,
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        buildTime(
                          // imagePath: 'assets/images/arrowThinDown.png',
                          index: index,
                          time: attendanceCardDayController
                              .attendanceViewList[index]
                              .attendance[index]
                              .dateTime!,
                        ),
                      ],
                    );
                  },
                ),
              ),
              if (attendanceCardDayController
                      .attendanceViewList[index].attendance.length >
                  1)
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    buildTime(
                        index: index,
                        //imagePath: 'assets/images/arrowThinDown.png',
                        time: attendanceCardDayController
                            .attendanceViewList[index].attendance[0].dateTime!),
                    SizedBox(width: 10.w),
                    Container(
                      height: 25.h,
                      width: 0.8.w,
                      color: Constants.colourBorderMedium,
                    ),
                    SizedBox(width: 10.w),
                    buildTime(
                        index: index,
                        //imagePath: 'assets/images/arrowThinUp.png',
                        time: attendanceCardDayController
                            .attendanceViewList[index].attendance[1].dateTime!),
                  ],
                ),
              if (attendanceCardDayController
                      .attendanceViewList[index].attendance.length >
                  2)
                Wrap(
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    Icon(
                      Icons.fastfood,
                      size: 11.w,
                      color: Constants.colourLunchBreak,
                    ),
                    SizedBox(width: 5.w),
                    buildDuration((attendanceCardDayController
                            .attendanceViewList[index].attendance[2].dateTime!)
                        .difference(attendanceCardDayController
                            .attendanceViewList[index]
                            .attendance[1]
                            .dateTime!)),
                  ],
                ),
              if (attendanceCardDayController
                      .attendanceViewList[index].attendance.length >
                  2)
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    buildTime(
                        index: index,
                        //imagePath: 'assets/images/arrowThinDown.png',
                        time: attendanceCardDayController
                            .attendanceViewList[index].attendance[2].dateTime!),
                    SizedBox(width: 10.w),
                    Container(
                      height: 25.h,
                      width: 0.8.w,
                      color: Constants.colourBorderMedium,
                    ),
                    SizedBox(width: 10.w),
                    buildTime(
                        index: index,
                        // imagePath: 'assets/images/arrowThinUp.png',
                        time: attendanceCardDayController
                            .attendanceViewList[index].attendance[2].dateTime!),
                  ],
                ),
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    SizedBox(
                      height: 20,
                      child: ListView.separated(
                        separatorBuilder: (context, index) => Container(
                          height: 25.h,
                          width: 0.8.w,
                          color: Constants.colourBorderMedium,
                        ),
                        shrinkWrap: true,
                        itemCount: //2,
                            attendanceCardDayController
                                        .attendanceViewList[index]
                                        .attendance
                                        .length >
                                    4
                                ? 2
                                : attendanceCardDayController
                                    .attendanceViewList[index]
                                    .attendance
                                    .length,
                        scrollDirection: Axis.horizontal,
                        itemBuilder: (context, index) => Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          //crossAxisAlignment: WrapCrossAlignment.center,
                          children: [
                            Image.asset(
                              index.isEven
                                  ? 'assets/images/arrowThinUp.png'
                                  : 'assets/images/arrowThinDown.png',
                              height: 11.h,
                            ),
                            SizedBox(width: 5.w),
                            Text(
                              DateFormat('h:m a').format(
                                  attendanceCardDayController
                                      .attendanceViewList[index]
                                      .attendance[index]
                                      .dateTime!),
                              style: Get.textTheme.titleMedium
                                  ?.copyWith(color: Constants.colourTextDark),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              if (attendanceCardDayController
                      .attendanceViewList[index].attendance.length >
                  2)
                Expanded(
                  child: Wrap(
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: [
                      Icon(
                        Icons.fastfood,
                        size: 11.w,
                        color: Constants.colourLunchBreak,
                      ),
                      SizedBox(width: 5.w),
                      buildDuration((attendanceCardDayController
                              .attendanceViewList[index]
                              .attendance[2]
                              .dateTime!)
                          .difference(attendanceCardDayController
                              .attendanceViewList[index]
                              .attendance[1]
                              .dateTime!)),
                    ],
                  ),
                ),
              Expanded(
                child: ListView.separated(
                  separatorBuilder: (context, index) => Container(
                    height: 25.h,
                    width: 0.8.w,
                    color: Constants.colourBorderMedium,
                  ),
                  shrinkWrap: true,
                  itemCount: attendanceCardDayController
                              .attendanceViewList[index].attendance.length >
                          4
                      ? 2
                      : attendanceCardDayController
                              .attendanceViewList[index].attendance.length -
                          2,
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (context, index) => Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Wrap(
                        crossAxisAlignment: WrapCrossAlignment.center,
                        children: [
                          Image.asset(
                            index.isEven
                                ? 'assets/images/arrowThinUp.png'
                                : 'assets/images/arrowThinDown.png',
                            height: 11.h,
                          ),
                          SizedBox(width: 5.w),
                          Text(
                            DateFormat('h:m a').format(
                                attendanceCardDayController
                                    .attendanceViewList[index]
                                    .attendance[index + 2]
                                    .dateTime!),
                            style: Get.textTheme.titleMedium
                                ?.copyWith(color: Constants.colourTextDark),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),

              /*   Text(
                  attendanceCardDayController.attendanceViewList[index].attendance..toString(),
                style: Get.textTheme.displaySmall
                    ?.copyWith(color: Constants.colourTextDark),
              ),*/
              Text(
                attendanceCardDayController
                    .attendanceViewList[index].user.userId
                    .toString(),
                style: Get.textTheme.displaySmall
                    ?.copyWith(color: Constants.colourTextDark),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /*Padding buildView() {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 14.h),
      child: Container(
        // width: 405.w,
        height: 132.h,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(5.r),
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 12.h),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            mainAxisSize: MainAxisSize.min,
            //crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Wrap(
                    alignment: WrapAlignment.start,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: [
                      PictureCircle(
                        height: 34.h,
                        width: 34.w,
                        imgPath: attendanceView!.user.profilePicPath!,
                        */ /* isNetworkPath: true,*/ /*
                        backgroundColor: Constants.colourTextLight,
                      ),
                      SizedBox(width: 12.w),
                      Text(
                        attendanceView?.user.name ?? '',
                        style: Get.textTheme.titleLarge
                            ?.copyWith(color: Constants.colourTextDark),
                      ),
                    ],
                  ),
                  if (attendanceView!.attendance.length == 1)
                    Container(
                      padding: EdgeInsets.symmetric(
                          horizontal: 17.w, vertical: 10.h),
                      decoration: BoxDecoration(
                          color: Constants.colourError.withOpacity(0.3),
                          borderRadius:
                              BorderRadius.all(Radius.circular(2.5.r))),
                      child: Text(
                        'Absent',
                        style: Get.textTheme.titleMedium
                            ?.copyWith(color: Constants.colourError),
                      ),
                    )
                ],
              ),
              if (attendanceView!.attendance.length > 2)
                Expanded(
                  child: buildDuration((attendanceView!.attendance[2].dateTime!)
                      .difference(attendanceView!.attendance[1].dateTime!)),
                ),
              Expanded(
                child: ListView.separated(
                  separatorBuilder: (context, index) => Container(
                    height: 25.h,
                    width: 0.8.w,
                    color: Constants.colourBorderMedium,
                  ),
                  itemCount: attendanceView!.attendance.length,
                  scrollDirection: Axis.horizontal,
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        buildTime(
                          // imagePath: 'assets/images/arrowThinDown.png',
                          index: index,
                          time: attendanceView!.attendance[index].dateTime!,
                        ),
                      ],
                    );
                  },
                ),
              ),
              */ /* if (attendanceView!.attendance.length > 1)
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    buildTime(
                        imagePath: 'assets/images/arrowThinDown.png',
                        time: attendanceView!.attendance[0].date!),
                    SizedBox(width: 10.w),
                    Container(
                      height: 25.h,
                      width: 0.8.w,
                      color: Constants.colourBorderMedium,
                    ),
                    SizedBox(width: 10.w),
                    buildTime(
                        imagePath: 'assets/images/arrowThinUp.png',
                        time: attendanceView!.attendance[1].date!),
                  ],
                ),
              if (attendanceView!.attendance.length > 2)
                Wrap(
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    Icon(
                      Icons.fastfood,
                      size: 11.w,
                      color: Constants.colourLunchBreak,
                    ),
                    SizedBox(width: 5.w),
                    buildDuration((attendanceView!.attendance[2].date!)
                        .difference(attendanceView!.attendance[1].date!)),
                  ],
                ),
              if (attendanceView!.attendance.length > 2)
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    buildTime(
                        imagePath: 'assets/images/arrowThinDown.png',
                        time: attendanceView!.attendance[2].date!),
                    SizedBox(width: 10.w),
                    Container(
                      height: 25.h,
                      width: 0.8.w,
                      color: Constants.colourBorderMedium,
                    ),
                    SizedBox(width: 10.w),
                    buildTime(
                        imagePath: 'assets/images/arrowThinUp.png',
                        time: attendanceView!.attendance[2].date!),
                  ],
                ),*/ /*

              */ /*Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    SizedBox(
                      height: 20,
                      child: ListView.separated(
                        separatorBuilder: (context, index) => Container(
                          height: 25.h,
                          width: 0.8.w,
                          color: Constants.colourBorderMedium,
                        ),
                        shrinkWrap: true,
                        itemCount: 2,
                        */ /* */ /*attendanceView!.attendance.length > 4
                            ? 2
                            : attendanceView!.attendance.length,*/ /* */ /*

                        scrollDirection: Axis.horizontal,
                        itemBuilder: (context, index) => Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          //crossAxisAlignment: WrapCrossAlignment.center,
                          children: [
                            Image.asset(
                              index.isEven
                                  ? 'assets/images/arrowThinUp.png'
                                  : 'assets/images/arrowThinDown.png',
                              height: 11.h,
                            ),
                            SizedBox(width: 5.w),
                            Text(
                              DateFormat('h:m a').format(
                                  attendanceView!.attendance[index].date!),
                              style: Get.textTheme.titleMedium
                                  ?.copyWith(color: Constants.colourTextDark),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              if (attendanceView!.attendance.length > 2)
                Expanded(
                  child: Wrap(
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: [
                      Icon(
                        Icons.fastfood,
                        size: 11.w,
                        color: Constants.colourLunchBreak,
                      ),
                      SizedBox(width: 5.w),
                      buildDuration((attendanceView!.attendance[2].date!)
                          .difference(attendanceView!.attendance[1].date!)),
                    ],
                  ),
                ),
              Expanded(
                child: ListView.separated(
                  separatorBuilder: (context, index) => Container(
                    height: 25.h,
                    width: 0.8.w,
                    color: Constants.colourBorderMedium,
                  ),
                  shrinkWrap: true,
                  itemCount: attendanceView!.attendance.length > 4
                      ? 2
                      : attendanceView!.attendance.length - 2,
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (context, index) => Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Wrap(
                        crossAxisAlignment: WrapCrossAlignment.center,
                        children: [
                          Image.asset(
                            index.isEven
                                ? 'assets/images/arrowThinUp.png'
                                : 'assets/images/arrowThinDown.png',
                            height: 11.h,
                          ),
                          SizedBox(width: 5.w),
                          Text(
                            DateFormat('h:m a').format(
                                attendanceView!.attendance[index + 2].date!),
                            style: Get.textTheme.titleMedium
                                ?.copyWith(color: Constants.colourTextDark),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),*/ /*

              */ /* Text(
                attendanceView!.attendance.date.toString(),
                style: Get.textTheme.displaySmall
                    ?.copyWith(color: Constants.colourTextDark),
              ),
              Text(
                attendanceView!.attendance.empId.toString(),
                style: Get.textTheme.displaySmall
                    ?.copyWith(color: Constants.colourTextDark),
              ),*/ /*
            ],
          ),
        ),
      ),
    );
  }*/

  Widget buildTime({
    /*required String imagePath,*/
    required int index,
    required DateTime time,
  }) {
    return Row(
      //crossAxisAlignment: WrapCrossAlignment.center,
      /*mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      mainAxisSize: MainAxisSize.min,*/
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Image.asset(
          index!.isEven
              ? 'assets/images/arrowThinUp.png'
              : 'assets/images/arrowThinDown.png',
          height: 11.h,
        ),
        SizedBox(width: 5.w),
        Text(
          DateFormat('hh:mm a').format(time),
          style: Get.textTheme.titleMedium
              ?.copyWith(color: Constants.colourTextDark),
        ),
      ],
    );
  }

  Widget buildDuration(Duration duration) {
    // Calculate total hours and remaining minutes
    int hours = duration.inHours;
    int minutes = duration.inMinutes.remainder(60);
    // Note: Seconds are considered for total duration but not displayed.
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    return Row(
      //crossAxisAlignment: WrapCrossAlignment.center,
      /*mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      mainAxisSize: MainAxisSize.min,*/
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          //height: 25.h,
          width: 0.8.w,
          color: Constants.colourBorderMedium,
        ),
        Icon(
          Icons.fastfood,
          size: 11.w,
          color: Constants.colourLunchBreak,
        ),
        SizedBox(width: 5.w),
        Text(
          '${twoDigits(hours)}:${twoDigits(minutes)}',
          style: Get.textTheme.titleMedium
              ?.copyWith(color: Constants.colourTextDark),
        ),
      ],
    );
    return Text(
      '${twoDigits(hours)}:${twoDigits(minutes)}',
      style:
          Get.textTheme.titleMedium?.copyWith(color: Constants.colourTextDark),
    );
    /* String twoDigits(int n) => n.toString().padLeft(2, '0');
    String twoDigitHours = twoDigits(duration.inHours.remainder(24));
    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    return Text(
      '$twoDigitHours:$twoDigitMinutes',
      style:
          Get.textTheme.titleMedium?.copyWith(color: Constants.colourTextDark),
    );*/
  }

  Padding buildPlaceholder() {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 14.h),
      child: Container(
        // width: 405.w,
        height: 132.h,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(5.r),
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 12.h),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                /*  width: 34.w,
                              height:  34.h,*/
                decoration: BoxDecoration(shape: BoxShape.circle),
                child: GradientProgressBar(size: Size(34, 34)),
              ),
              SizedBox(width: 20.w),
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  GradientProgressBar(size: Size(200.w, 20.h)),
                  SizedBox(height: 20.w),
                  GradientProgressBar(size: Size(180.w, 15.h)),

                  /*  PictureCircle(
                  height: 34.h,
                  width: 34.w,
                  imgPath: '',
                  backgroundColor: Constants.colourTextLight,
                ),*/
                  /* Obx(
                  () => Text(
                    attendanceCardController.user.value.name ?? '',
                    style: Get.textTheme.displayMedium
                        ?.copyWith(color: Constants.colourTextDark),
                  ),
                ),*/
                  /* Text(
                  attendance!.date.toString(),
                  style: Get.textTheme.displayMedium
                      ?.copyWith(color: Constants.colourTextDark),
                ),*/
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
