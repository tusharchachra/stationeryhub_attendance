import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

class UpdateOrganizationScreenController extends GetxController {
  RxBool isFormValid = false.obs;
  RxBool isLoading = false.obs;

  final formKey = GlobalKey<FormState>();

  Rx<TextEditingController> addressController = TextEditingController().obs;
  Rx<TextEditingController> nameController = TextEditingController().obs;
  RxString geoLatController = ''.obs;
  RxString geoLongController = ''.obs;

  validateName(String? value) {
    String? temp;
    if (value == '') {
      isFormValid.value = false;
      temp = 'Enter a name';
    } else {
      isFormValid.value = true;
    }
    // return temp;
  }

  void resetAll() {
    nameController.value.text = '';
    addressController.value.text = '';
    isLoading.value = false;
  }

  /* Future<void> uploadData() async {
    isLoading.value = true;
    String? profilePicPath = await firebaseStorageController
        .uploadPicture(XFile(captureImageScreenController.imageFilePath.value));
    UsersModel? temp = await firebaseStorageController.uploadIdCard(
        fileFront: XFile(idCardCaptureController.documentFront[0]),
        fileBack: XFile(idCardCaptureController.documentBack[0]));
    UsersModel newUser = UsersModel(
      phoneNum: phoneNumController.value.text.trim(),
      organizationId: firestoreController.registeredOrganization.value?.id,
      name: nameController.value.text.trim(),
      userType:
          UserType.values.byName(userTypeController.value.text.toLowerCase()),
      profilePicPath: profilePicPath,
      idCardFrontPath: temp?.idCardFrontPath,
      idCardBackPath: temp?.idCardBackPath,
    );
    await firestoreController.addNewUser(user: newUser);

    if (firestoreController.isLoading.value == false) isLoading.value = false;
  }*/
}
