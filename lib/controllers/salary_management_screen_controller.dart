import 'package:get/get.dart';
import 'package:stationeryhub_attendance/controllers/admin_dashboard_screen_controller.dart';
import 'package:stationeryhub_attendance/models/users_model.dart';

class SalaryManagementScreenController extends GetxController {
  final AdminDashboardScreenController adminDashboardScreenController =
      Get.find();
  RxList<UsersModel> tempEmpList = <UsersModel>[].obs;
  RxBool showTotal = false.obs;

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    loadEmpList();
  }

  void loadEmpList() {
    tempEmpList.value = adminDashboardScreenController.employeeList;
    tempEmpList.refresh();
  }

  @override
  void onReady() {
    // TODO: implement onReady
    super.onReady();
  }

  void invertShowTotal() {
    if (showTotal.value == false) {
      showTotal.value = true;
      //change to false after 5 seconds
      Future.delayed(Duration(seconds: 5))
          .then((val) => showTotal.value = false);
    } else {
      showTotal.value = false;
    }
  }

  void filterList(String val) {
    if (val == '') {
      loadEmpList();
    }
    tempEmpList.value = adminDashboardScreenController.employeeList
        .where((element) =>
            element.name!.toLowerCase().contains(val.toLowerCase()))
        .toList();
    tempEmpList.refresh();
  }
}
