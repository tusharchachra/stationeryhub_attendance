import 'package:get/get.dart';
import 'package:stationeryhub_attendance/controllers/firebase_firestore_controller.dart';
import 'package:stationeryhub_attendance/models/users_model.dart';

class EmployeeAttendanceCardController extends GetxController {
  final FirebaseFirestoreController firestoreController = Get.find();
  Rx<UsersModel> user = UsersModel().obs;

  void setUser(String empId) async {
    user(await firestoreController.getUser(uid: empId));
  }
}
