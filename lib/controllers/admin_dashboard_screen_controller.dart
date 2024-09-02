import 'package:get/get.dart';
import 'package:stationeryhub_attendance/controllers/firebase_auth_controller.dart';
import 'package:stationeryhub_attendance/controllers/firebase_firestore_controller.dart';

class AdminDashboardScreenController extends GetxController {
  static AdminDashboardScreenController adminDashboardScreenController =
      Get.find();
  static FirebaseFirestoreController firestoreController = Get.find();
  static FirebaseAuthController authController = Get.find();
}
