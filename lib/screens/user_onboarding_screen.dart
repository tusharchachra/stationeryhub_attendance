import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:stationeryhub_attendance/components/form_error.dart';
import 'package:stationeryhub_attendance/components/form_field_button.dart';
import 'package:stationeryhub_attendance/components/form_field_phone_num.dart';
import 'package:stationeryhub_attendance/components/form_field_text.dart';
import 'package:stationeryhub_attendance/controllers/capture_image_screen_controller.dart';
import 'package:stationeryhub_attendance/controllers/firebase_firestore_controller.dart';
import 'package:stationeryhub_attendance/controllers/firebase_storage_controller.dart';
import 'package:stationeryhub_attendance/controllers/form_error_controller.dart';
import 'package:stationeryhub_attendance/controllers/user_onboarding_screen_controller.dart';
import 'package:stationeryhub_attendance/models/user_type_enum.dart';
import 'package:stationeryhub_attendance/models/users_model.dart';
import 'package:stationeryhub_attendance/scaffold/scaffold_dashboard.dart';
import 'package:stationeryhub_attendance/screens/user_id_card_info_screen.dart';
import 'package:stationeryhub_attendance/screens/user_profile_pic_info_screen.dart';

import '../controllers/id_card_capture_controller.dart';
import '../helpers/constants.dart';

class UserOnboardingScreen extends StatelessWidget {
  UserOnboardingScreen({super.key});

  static FirebaseFirestoreController firestoreController = Get.find();
  /*static UserOnboardingScreenController userOnboardingScreenController =
      Get.find();
  static final CaptureImageScreenController captureImageScreenController =
      Get.find();*/

  final FocusNode focusNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    final captureImageScreenController =
        Get.put(CaptureImageScreenController());
    final userOnboardingScreenController =
        Get.put(UserOnboardingScreenController());
    final idCardCaptureController = Get.put(IdCardCaptureController());
    final formErrorController = Get.put(FormErrorController());
    final FirebaseStorageController firebaseStorageController = Get.find();

    return ScaffoldDashboard(
      isLoading: false,
      pageTitle: 'New User',
      bodyWidget: Form(
        key: userOnboardingScreenController.formKey,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.h),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                GestureDetector(
                  onTap: () {
                    Get.to(() => UserProfilePicInfoScreen());
                  },
                  child: buildProfilePicCircle(captureImageScreenController),
                ),
                SizedBox(height: 14.h),
                FormFieldText(
                  labelText: 'Name',
                  textController:
                      userOnboardingScreenController.nameController.value,
                  validator: (val) {
                    if (val?.trim() == '') {
                      return 'Name is mandatory';
                    } else
                      return null;
                  },
                ),
                SizedBox(height: 14.h),
                FormFieldPhoneNum(
                  focusNode: focusNode,
                  labelText: 'Phone number',
                  validatorPhoneNum: (val) {
                    return userOnboardingScreenController.validatePhoneNum(val);
                  },
                  onChangedAction: (val) {},
                ),
                SizedBox(height: 14.h),
                buildUserTypeField(userOnboardingScreenController),
                SizedBox(height: 5.h),
                buildUserTypeSelectionBox(userOnboardingScreenController),
                SizedBox(height: 14.h),
                Row(
                  children: [
                    if (idCardCaptureController.documentFront.isNotEmpty &&
                        idCardCaptureController.documentBack.isNotEmpty)
                      Icon(
                        Icons.check,
                        color: Colors.green,
                      ),
                    TextButton(
                        onPressed: () {
                          Get.to(() => UserIdCardInfoScreen());
                        },
                        child: Text('Scan Id')),
                  ],
                ),
                SizedBox(height: 14.h),
                Obx(() => (formErrorController.errors.isNotEmpty)
                    ? FormError()
                    : Container()),
                FormFieldButton(
                  width: 430.w,
                  height: 56.h,
                  buttonText: 'Add User',
                  onTapAction: () {
                    validateForm(
                        captureImageScreenController,
                        formErrorController,
                        idCardCaptureController,
                        userOnboardingScreenController
                            .phoneNumController.value.text
                            .trim());
                    if (userOnboardingScreenController.formKey.currentState!
                        .validate()) {
                      ///TODO upload data
                      //uploadData();
                      //firestoreController.addNewUser(phoneNum: phoneNum, userType: userType)
                    } else {
                      print(formErrorController.errors);
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Obx buildProfilePicCircle(
      CaptureImageScreenController captureImageScreenController) {
    return Obx(
      () => Container(
        width: 111.w,
        height: 111.h,
        clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Constants.colourTextLight,
        ),
        child: captureImageScreenController.imageFilePath.value == ''
            ? Icon(
                Icons.camera_alt,
                color: Colors.white,
              )
            : Image.file(
                File(captureImageScreenController.imageFilePath.value),
                fit: BoxFit.fitWidth,
              ),
      ),
    );
  }

  Obx buildUserTypeField(
      UserOnboardingScreenController userOnboardingScreenController) {
    return Obx(
      () => FormFieldText(
        focusNode: userOnboardingScreenController.userTypeFocusNode,
        labelText: 'User type',
        textController: userOnboardingScreenController.userTypeController.value,
        readOnly: true,
        validator: (val) {
          if (userOnboardingScreenController.userTypeController.value.text
                  .trim() ==
              '') {
            return 'Select user type';
          }
          return null;
        },
        trailingWidget: IconButton(
            onPressed: () {
              userOnboardingScreenController.invertShowUserTypeValue();
            },
            icon:
                userOnboardingScreenController.showUserTypeOptions.value == true
                    ? Icon(Icons.keyboard_arrow_up_sharp)
                    : Icon(Icons.keyboard_arrow_down_sharp)),
      ),
    );
  }

  Obx buildUserTypeSelectionBox(
      UserOnboardingScreenController userOnboardingScreenController) {
    return Obx(
      () => userOnboardingScreenController.showUserTypeOptions.value == true
          ? Container(
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(color: Constants.colourPrimary),
                borderRadius: BorderRadius.circular(10.r),
              ),
              child: ListView(
                shrinkWrap: true,
                children: UserType.values
                    .map((e) => GestureDetector(
                          onTap: () {
                            userOnboardingScreenController.userTypeController
                                .value.text = e.getName().capitalizeFirst!;
                            userOnboardingScreenController
                                .selectedUserType.value = e;
                            userOnboardingScreenController
                                .invertShowUserTypeValue();
                          },
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: 24.w, vertical: 10.h),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  e.getName().capitalizeFirst!,
                                  style: Get.textTheme.displaySmall?.copyWith(
                                      color: userOnboardingScreenController
                                                  .selectedUserType.value ==
                                              e
                                          ? Constants.colourPrimary
                                          : Constants.colourTextLight),
                                ),
                                userOnboardingScreenController
                                            .selectedUserType.value ==
                                        e
                                    ? Image.asset(
                                        'assets/images/activeCircle.png')
                                    : Image.asset(
                                        'assets/images/inactiveCircle.png')
                              ],
                            ),
                          ),
                        ))
                    .toList(),
              ),
            )
          : Container(),
    );
  }

  validateForm(
      CaptureImageScreenController captureImageScreenController,
      FormErrorController formErrorController,
      IdCardCaptureController idCardCaptureController,
      String phoneNum) async {
    FormErrorController formErrorController = Get.find();
    formErrorController.resetErrors();

    UsersModel? tempUser =
        await firestoreController.getUser(phoneNum: phoneNum);
    if (tempUser != null) {
      return 'User already exists';
    }

    if (captureImageScreenController.imageFilePath.isEmpty) {
      formErrorController.errors.add('Click a profile picture');
    }

    if (idCardCaptureController.documentFront.isEmpty ||
        idCardCaptureController.documentBack.isEmpty) {
      formErrorController.errors.add('Scan ID card');
    }
  }
}
