import 'package:camera/camera.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:stationeryhub_attendance/controllers/capture_image_screen_controller.dart';
import 'package:stationeryhub_attendance/controllers/firebase_firestore_controller.dart';
import 'package:stationeryhub_attendance/controllers/firebase_storage_controller.dart';
import 'package:stationeryhub_attendance/models/pic_path_enum.dart';

import '../models/organizations_model.dart';
import '../models/users_model.dart';

class UpdateOrganizationScreenController extends GetxController {
  // RxBool isFormValid = false.obs;
  RxBool isLoading = false.obs;
  RxBool isChangesMade = false.obs;
  RxBool isPicChanged = false.obs;

  final formKey = GlobalKey<FormState>();

  Rx<TextEditingController> addressController = TextEditingController().obs;
  Rx<TextEditingController> creatorNameController = TextEditingController().obs;
  Rx<TextEditingController> orgNameController = TextEditingController().obs;
  RxString geoLatController = ''.obs;
  RxString geoLongController = ''.obs;

  static final FirebaseStorageController firebaseStorageController = Get.find();
  static final CaptureImageScreenController captureImageScreenController =
      Get.find();
  static final FirebaseFirestoreController firestoreController = Get.find();

  /* validateName(String? value) {
    String? temp;
    if (value == '') {
      isFormValid.value = false;
      temp = 'Enter a name';
    } else {
      isFormValid.value = true;
    }
    // return temp;
  }*/

  void resetAll() {
    creatorNameController.value.text = '';
    addressController.value.text = '';
    isLoading.value = false;
  }

  Future<void> uploadData() async {
    isLoading.value = true;
    String? picPath;
    print('isPiChanged=${isPicChanged}');

    if (isChangesMade.value == true || isPicChanged.value == true) {
      if (captureImageScreenController.imageFilePath.value != '' &&
          isPicChanged.value == true) {
        picPath = await firebaseStorageController.uploadPicture(
            XFile(captureImageScreenController.imageFilePath.value),
            PicPathEnum.organization);
      }
      print('profilePicPath=$picPath');

      OrganizationModel updatedOrganization = OrganizationModel(
        id: firestoreController.registeredOrganization.value?.id,
        name: orgNameController.value.text.trim(),
        address: addressController.value.text.trim(),
        profilePicPath: picPath,
        lastUpdatedOn: DateTime.now(),
      );
      await firestoreController.updateOrganization(
          organization: updatedOrganization);

      UsersModel updatedCreator = UsersModel(
          userId: firestoreController.registeredUser.value?.userId,
          name: creatorNameController.value.text.trim());
      await firestoreController.updateUser(user: updatedCreator);
      if (firestoreController.isLoading.value == false) isLoading.value = false;
    }
  }
}
