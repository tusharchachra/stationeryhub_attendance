import 'package:get/get.dart';
import 'package:stationeryhub_attendance/controllers/firebase_auth_controller.dart';
import 'package:stationeryhub_attendance/controllers/new_organization_screen_controller.dart';

import 'firebase_error_controller.dart';
import 'firebase_firestore_controller.dart';
import 'login_screen_controller.dart';
import 'otp_screen_controller.dart';

class UtilsController {
  UtilsController._privateConstructor();

  static final UtilsController instance = UtilsController._privateConstructor();

  Future<void> registerControllers() async {
    Get.put(FirebaseAuthController());
    Get.put(FirebaseFirestoreController());
    Get.put(LoginScreenController());
    Get.put(OtpScreenController());
    Get.put(FirebaseErrorController());
    //Get.put(SharedPrefsController());
    Get.put(NewOrganizationScreenController());
  }
}
