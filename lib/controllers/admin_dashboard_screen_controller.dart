import 'package:carousel_slider/carousel_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AdminDashboardScreenController extends GetxController {
  Rx<DateTime> selectedDate = DateTime.now().obs;
  final Rx<CarouselSliderController> dateCarouselController =
      CarouselSliderController().obs;

  List<DateTime> getCurrentMonthDates({required int month, required int year}) {
    final daysCount = DateUtils.getDaysInMonth(year, month);
    List<DateTime> days = [];
    for (int i = 1; i < daysCount + 1; i++) {
      /*var temp= DateFormat.yMMMd().format(DateTime(DateTime.now().year, DateTime.now().month, i));*/
      days.add(DateTime(year, month, i));
    }
    return days;
  }
}
