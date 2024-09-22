import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:stationeryhub_attendance/controllers/firebase_firestore_controller.dart';
import 'package:stationeryhub_attendance/models/organizations_model.dart';
import 'package:stationeryhub_attendance/models/users_model.dart';

class GetStorageController extends GetxController {
  final generalBox = GetStorage();
  static FirebaseFirestoreController firestoreController = Get.find();

  Future<void> writeUserDetails(UsersModel? user) async {
    print('Writing User to GetStorage');
    if (user != null) {
      generalBox.write(
          'user', firestoreController.registeredUser.value?.toJson());
    }
  }

  String? readUserDetails() {
    print('Reading User from GetStorage');
    return (generalBox.read('user').toString());
  }

  void writeOrgDetails(OrganizationModel? organization) {
    print('Writing User to GetStorage');
    if (organization != null) {
      generalBox.write('organization',
          firestoreController.registeredOrganization.value?.toJson());
    }
  }

  String? readOrgDetails() {
    print('Reading Organization from GetStorage');
    return (generalBox.read('organization').toString());
  }
}
