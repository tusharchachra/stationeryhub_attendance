import 'package:get/get.dart';
import 'package:stationeryhub_attendance/services/firebase_auth_controller.dart';

Future<void> registerFirebaseAuthController() async {
  Get.put(FirebaseAuthController());
}
