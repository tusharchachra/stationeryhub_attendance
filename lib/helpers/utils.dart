import 'package:get/get.dart';
import 'package:stationeryhub_attendance/services/firebase_auth_controller.dart';
import 'package:stationeryhub_attendance/services/firebase_firestore_controller.dart';
import 'package:stationeryhub_attendance/services/login_screen_controller.dart';

Future<void> registerFirebaseAuthController() async {
  Get.put(FirebaseAuthController());
  Get.put(FirebaseFirestoreController());
  Get.put(LoginScreenController());
}
