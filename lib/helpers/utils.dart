import 'package:get/get.dart';
import 'package:stationeryhub_attendance/services/firebase_auth_controller.dart';
import 'package:stationeryhub_attendance/services/firebase_firestore_controller.dart';
import 'package:stationeryhub_attendance/services/login_screen_controller.dart';
import 'package:stationeryhub_attendance/services/shared_prefs_controller.dart';

import '../services/firebase_error_controller.dart';
import '../services/otp_screen_controller.dart';

class UtilsController {
  UtilsController._privateConstructor();

  static final UtilsController instance = UtilsController._privateConstructor();

  Future<void> registerControllers() async {
    Get.put(FirebaseAuthController());
    Get.put(FirebaseFirestoreController());
    Get.put(LoginScreenController());
    Get.put(OtpScreenController());
    Get.put(FirebaseErrorController());
    Get.put(SharedPrefsController());
  }
}
