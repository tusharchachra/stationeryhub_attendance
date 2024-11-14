import 'package:camera/camera.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stationeryhub_attendance/controllers/admin_dashboard_screen_controller.dart';
import 'package:stationeryhub_attendance/controllers/capture_image_screen_controller.dart';
import 'package:stationeryhub_attendance/controllers/firebase_firestore_controller.dart';
import 'package:stationeryhub_attendance/controllers/firebase_storage_controller.dart';
import 'package:stationeryhub_attendance/controllers/id_card_capture_controller.dart';
import 'package:stationeryhub_attendance/models/pic_path_enum.dart';
import 'package:stationeryhub_attendance/models/user_type_enum.dart';

import '../models/users_model.dart';

class UserOnboardingScreenController extends GetxController {
  Rx<TextEditingController> nameController = TextEditingController().obs;
  Rx<TextEditingController> salaryController = TextEditingController().obs;

  Rx<TextEditingController> phoneNumController = TextEditingController().obs;
  RxString phoneNum = ('').obs;
  Rx<TextEditingController> userTypeController = TextEditingController().obs;
  RxBool showUserTypeOptions = false.obs;
  RxBool isActive = true.obs;
  RxBool isPhoneNumValid = false.obs;
  FocusNode userTypeFocusNode = FocusNode();
  RxBool isLoading = false.obs;
  RxBool isFormValid = false.obs;
  RxBool isEditing = false.obs;
  RxBool isProfilePicChanged = false.obs;
  RxBool isIdFrontChanged = false.obs;
  RxBool isIdBackChanged = false.obs;

  var selectedUserType = UserType.employee.obs;

  final formKey = GlobalKey<FormState>();

  final FirebaseStorageController firebaseStorageController = Get.find();
  final CaptureImageScreenController captureImageScreenController = Get.find();
  final FirebaseFirestoreController firestoreController = Get.find();
  final IdCardCaptureController idCardCaptureController = Get.find();
  //final EmployeeListScreenController employeeListScreenController = Get.find();
  final AdminDashboardScreenController adminDashboardScreenController =
      Get.find();

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
    userTypeFocusNode.dispose();
    isEditing.value = false;
    isProfilePicChanged.value = false;
    isIdFrontChanged.value = false;
    isIdBackChanged.value = false;
    super.dispose();
  }

  void invertShowUserTypeValue() {
    showUserTypeOptions.value = !showUserTypeOptions.value;
  }

  validatePhoneNum(String? value) {
    /*if (value == '7808814341') {
      return null;    } else*/

    phoneNum = RxString(value!.trim());
    //print('value=$value');
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
      isActive: isActive.value,
      salary: int.parse(salaryController.value.text),
      profilePicPath: profilePicPath,
      idCardFrontPath: frontPath,
      idCardBackPath: backPath,
    );
    await firestoreController.addNewUser(user: newUser);

    if (firestoreController.isLoading.value == false) isLoading.value = false;
  }

  void loadStoredData(UsersModel employee) {
    isEditing.value = true;
    phoneNumController.value.text = employee.phoneNum!.trim();
    nameController.value.text = employee.name!.trim();
    selectedUserType.value = employee.userType!;

    userTypeController.value.text = employee.userType!.name.capitalizeFirst!;
    isActive.value = employee.isActive!;
    salaryController.value.text = employee.salary!.toString();
    /*userOnboardingScreenController.captureImageScreenController.*/
    captureImageScreenController.imageFilePath.value = employee.profilePicPath!;
    idCardCaptureController.documentFront.clear();
    idCardCaptureController.documentFront.add(employee.idCardFrontPath!);
    idCardCaptureController.documentBack.clear();
    idCardCaptureController.documentBack.add(employee.idCardBackPath!);
  }

  Future<void> uploadEditedData({required String uid}) async {
    isLoading.value = true;
    String? profilePicPath;
    String? frontPath;
    String? backPath;
    if (isEditing.value == true) {
      if (isProfilePicChanged.value == true) {
        profilePicPath = await firebaseStorageController.uploadPicture(
            file: XFile(captureImageScreenController.imageFilePath.value),
            storagePath: PicPathEnum.profile);
        //delete previous file
        print('deleting previous file');
        final httpsReferenceToDel = FirebaseStorage.instance.refFromURL(
            adminDashboardScreenController.employeeList
                .firstWhere((user) => user.userId == uid)
                .profilePicPath!);
        httpsReferenceToDel.delete();
      }
      if (isIdFrontChanged.value == true) {
        frontPath = await firebaseStorageController.uploadPicture(
            file: XFile(idCardCaptureController.documentFront[0]),
            storagePath: PicPathEnum.idCard);
        //delete previous file
        print('deleting previous file');
        final httpsReferenceToDel = FirebaseStorage.instance.refFromURL(
            adminDashboardScreenController.employeeList
                .firstWhere((user) => user.userId == uid)
                .idCardFrontPath!);
        httpsReferenceToDel.delete();
      }
      if (isIdBackChanged.value == true) {
        backPath = await firebaseStorageController.uploadPicture(
            file: XFile(idCardCaptureController.documentBack[0]),
            storagePath: PicPathEnum.idCard);
        //delete previous file
        print('deleting previous file');
        final httpsReferenceToDel = FirebaseStorage.instance.refFromURL(
            adminDashboardScreenController.employeeList
                .firstWhere((user) => user.userId == uid)
                .idCardBackPath!);
        httpsReferenceToDel.delete();
      }
      /*UsersModel? temp = await firebaseStorageController.uploadIdCard(
        fileFront: XFile(idCardCaptureController.documentFront[0]),
        fileBack: XFile(idCardCaptureController.documentBack[0]));*/

      UsersModel updatedUser = UsersModel(
        userId: uid,
        phoneNum: phoneNumController.value.text.trim(),
        name: nameController.value.text.trim(),
        userType:
            UserType.values.byName(userTypeController.value.text.toLowerCase()),
        isActive: isActive.value,
        salary: int.parse(salaryController.value.text),
        profilePicPath:
            isProfilePicChanged.value == true ? profilePicPath : null,
        idCardFrontPath: isIdFrontChanged.value == true ? frontPath : null,
        idCardBackPath: isIdBackChanged.value == true ? backPath : null,
      );
      await firestoreController.updateUser(user: updatedUser);
      adminDashboardScreenController.employeeList[adminDashboardScreenController
              .employeeList
              .indexWhere((user) => user.userId == uid)] =
          (await firestoreController.getUser(uid: uid))!;

      if (firestoreController.isLoading.value == false) isLoading.value = false;
    }
  }
}
