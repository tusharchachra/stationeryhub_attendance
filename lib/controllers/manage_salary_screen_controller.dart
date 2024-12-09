import 'package:get/get.dart';
import 'package:stationeryhub_attendance/controllers/firebase_firestore_controller.dart';
import 'package:stationeryhub_attendance/models/users_model.dart';

class ManageSalaryScreenController extends GetxController {
  /* final AdminDashboardScreenController adminDashboardScreenController =
      Get.find();*/
  final FirebaseFirestoreController firestoreController = Get.find();
  RxList<UsersModel> tempEmpList = <UsersModel>[].obs;
  RxBool showTotal = true.obs;

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    loadEmpList();
  }

  void loadEmpList() {
    tempEmpList.value = firestoreController.userList;
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
      /*var a=*/ Future.delayed(const Duration(seconds: 5))
          .then((val) => showTotal.value = false);
    } else {
      showTotal.value = false;
    }
  }

  void filterList(String val) {
    if (val == '') {
      loadEmpList();
    }
    tempEmpList.value = firestoreController.userList
        .where((element) =>
            element.name!.toLowerCase().contains(val.toLowerCase()))
        .toList();
    tempEmpList.refresh();
  }
}
