import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stationeryhub_attendance/controllers/capture_image_screen_controller.dart';
import 'package:stationeryhub_attendance/controllers/firebase_firestore_controller.dart';
import 'package:stationeryhub_attendance/controllers/firebase_storage_controller.dart';
import 'package:stationeryhub_attendance/controllers/id_card_capture_controller.dart';
import 'package:stationeryhub_attendance/models/pic_path_enum.dart';
import 'package:stationeryhub_attendance/models/user_type_enum.dart';

import '../models/users_model.dart';

class UserOnboardingScreenController extends GetxController {
  Rx<TextEditingController> nameController = TextEditingController().obs;
  Rx<TextEditingController> phoneNumController = TextEditingController().obs;
  RxString phoneNum = ('').obs;
  Rx<TextEditingController> userTypeController = TextEditingController().obs;
  RxBool showUserTypeOptions = false.obs;
  RxBool isPhoneNumValid = false.obs;
  FocusNode userTypeFocusNode = FocusNode();
  RxBool isLoading = false.obs;
  RxBool isFormValid = false.obs;

  var selectedUserType = UserType.employee.obs;

  final formKey = GlobalKey<FormState>();

  final FirebaseStorageController firebaseStorageController = Get.find();
  final CaptureImageScreenController captureImageScreenController = Get.find();
  final FirebaseFirestoreController firestoreController = Get.find();
  final IdCardCaptureController idCardCaptureController = Get.find();

  @override
  void onReady() {
    // TODO: implement onReady
    super.onReady();
    userTypeFocusNode.addListener(() {
      if (userTypeFocusNode.hasFocus) {
        showUserTypeOptions.value = true;
      } else {
        showUserTypeOptions.value = false;
      }
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    userTypeFocusNode.dispose();
  }

  void invertShowUserTypeValue() {
    showUserTypeOptions.value = !showUserTypeOptions.value;
  }

  validatePhoneNum(String? value) {
    /*if (value == '7808814341') {
      return null;    } else*/

    phoneNum = RxString(value!.trim());
    print('value=$value');
    String? temp;
    if (value == '') {
      isPhoneNumValid.value = false;
      temp = 'Invalid phone number';
    } else if (value.length == 10) {
      isPhoneNumValid.value = true;
      temp = null;
    } else if (value.length < 10) {
      isPhoneNumValid.value = false;
      temp = 'Invalid phone number';
    } else {
      isPhoneNumValid.value = false;
      temp = 'Unauthorised user';
    }

    return temp;
  }

  Future<void> uploadData() async {
    isLoading.value = true;
    String? profilePicPath = await firebaseStorageController.uploadPicture(
        file: XFile(captureImageScreenController.imageFilePath.value),
        storagePath: PicPathEnum.profile);
    String? frontPath = await firebaseStorageController.uploadPicture(
        file: XFile(idCardCaptureController.documentFront[0]),
        storagePath: PicPathEnum.idCard);
    String? backPath = await firebaseStorageController.uploadPicture(
        file: XFile(idCardCaptureController.documentBack[0]),
        storagePath: PicPathEnum.idCard);
    /*UsersModel? temp = await firebaseStorageController.uploadIdCard(
        fileFront: XFile(idCardCaptureController.documentFront[0]),
        fileBack: XFile(idCardCaptureController.documentBack[0]));*/
    UsersModel newUser = UsersModel(
      phoneNum: phoneNumController.value.text.trim(),
      organizationId: firestoreController.registeredOrganization.value?.id,
      name: nameController.value.text.trim(),
      userType:
          UserType.values.byName(userTypeController.value.text.toLowerCase()),
      profilePicPath: profilePicPath,
      idCardFrontPath: frontPath,
      idCardBackPath: backPath,
    );
    await firestoreController.addNewUser(user: newUser);

    if (firestoreController.isLoading.value == false) isLoading.value = false;
  }
}
