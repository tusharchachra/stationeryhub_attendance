import 'package:get/get.dart';

import '../screens/date_filter_dialog.dart';

class DateFilterDialogController extends GetxController {
  Rx<FilterOptions> filter = FilterOptions.recent.obs;
  Rx<DateTime> selectedDate = DateTime.now().obs;
  Rx<FilterRecent> filterRecent = FilterRecent.today.obs;
}
