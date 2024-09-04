import 'package:carousel_slider/carousel_controller.dart';
import 'package:get/get.dart';

class AdminDashboardScreenController extends GetxController {
  int currentDate = 0;
  final Rx<CarouselSliderController> dateCarouselController =
      CarouselSliderController().obs;
}
