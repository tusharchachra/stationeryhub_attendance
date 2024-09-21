import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:stationeryhub_attendance/components/dotted_border_painter.dart';
import 'package:stationeryhub_attendance/components/form_error.dart';
import 'package:stationeryhub_attendance/components/form_field_button.dart';
import 'package:stationeryhub_attendance/components/form_field_phone_num.dart';
import 'package:stationeryhub_attendance/components/form_field_text.dart';
import 'package:stationeryhub_attendance/controllers/capture_image_screen_controller.dart';
import 'package:stationeryhub_attendance/controllers/firebase_firestore_controller.dart';
import 'package:stationeryhub_attendance/controllers/form_error_controller.dart';
import 'package:stationeryhub_attendance/controllers/user_onboarding_screen_controller.dart';
import 'package:stationeryhub_attendance/models/user_type_enum.dart';
import 'package:stationeryhub_attendance/models/users_model.dart';
import 'package:stationeryhub_attendance/scaffold/scaffold_dashboard.dart';
import 'package:stationeryhub_attendance/screens/display_captured_image_screen.dart';
import 'package:stationeryhub_attendance/screens/user_id_card_info_screen.dart';
import 'package:stationeryhub_attendance/screens/user_profile_pic_info_screen.dart';

import '../controllers/firebase_error_controller.dart';
import '../controllers/id_card_capture_controller.dart';
import '../helpers/constants.dart';

enum ScanDirection { front, back }

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
    //final FirebaseStorageController firebaseStorageController = Get.find();
    final IdCardCaptureController cardCaptureController = Get.find();
    final FirebaseErrorController errorController = Get.find();

    var outlineInputBorder = OutlineInputBorder(
      borderSide: BorderSide.none,
      borderRadius: BorderRadius.all(
        Radius.circular(10.r),
      ),
    );
    return ScaffoldDashboard(
      isLoading: false,
      pageTitle: 'New User',
      bodyWidget: Form(
        key: userOnboardingScreenController.formKey,
        autovalidateMode: AutovalidateMode.disabled,
        child: Obx(
          () => Padding(
            padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.h),
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  buildProfilePicCircle(captureImageScreenController),
                  SizedBox(height: 48.h),
                  buildSubHeading(
                    text: 'Profile',
                    assetPath: 'assets/images/iconEmpDetails.png',
                  ),
                  SizedBox(height: 23.h),
                  FormFieldText(
                    labelText: 'Name',
                    textController:
                        userOnboardingScreenController.nameController.value,
                    hintText: 'Enter name',
                    border: outlineInputBorder,
                    fillColor: Constants.colourBorderLight,
                    validator: (val) {
                      if (val?.trim() == '') {
                        return 'Name is mandatory';
                      } else
                        return null;
                    },
                  ),
                  SizedBox(height: 20.h),
                  FormFieldPhoneNum(
                    focusNode: focusNode,
                    labelText: 'Phone number',
                    phoneNumController:
                        userOnboardingScreenController.phoneNumController.value,
                    hintText: 'Enter phone number',
                    border: outlineInputBorder,
                    fillColor: Constants.colourBorderLight,
                    prefixIcon: Icon(Icons.phone),
                    validatorPhoneNum: (val) {
                      return userOnboardingScreenController
                          .validatePhoneNum(val);
                    },
                    onChangedAction: (val) {},
                  ),
                  SizedBox(height: 35.h),
                  buildSubHeading(
                    text: 'Job',
                    assetPath: 'assets/images/iconEmpWorkDet.png',
                  ),
                  SizedBox(height: 20.h),
                  buildUserTypeField(userOnboardingScreenController),
                  SizedBox(height: 5.h),
                  buildUserTypeSelectionBox(userOnboardingScreenController),
                  SizedBox(height: 35.h),
                  buildSubHeading(
                    text: 'ID',
                    assetPath: 'assets/images/empDocs.png',
                  ),
                  SizedBox(height: 20.h),
                  buildDocBox(idCardCaptureController: idCardCaptureController),
                  if (idCardCaptureController.documentFront.isNotEmpty)
                    buildCapturedCard(
                        cardCaptureController: cardCaptureController,
                        direction: ScanDirection.front),
                  SizedBox(height: 10.h),
                  if (idCardCaptureController.documentBack.isNotEmpty)
                    buildCapturedCard(
                        cardCaptureController: cardCaptureController,
                        direction: ScanDirection.back),
                  /*  Row(
                    children: [
                      if (idCardCaptureController.documentFront.isNotEmpty &&
                          idCardCaptureController.documentBack.isNotEmpty)
                        const Icon(
                          Icons.check,
                          color: Colors.green,
                        ),
                    ],
                  ),*/
                  SizedBox(height: 14.h),
                  (formErrorController.errors.isNotEmpty)
                      ? FormError()
                      : Container(),
                  SizedBox(height: 10.h),
                  Obx(
                    () => userOnboardingScreenController.isLoading.value == true
                        ? Center(child: CircularProgressIndicator())
                        : FormFieldButton(
                            width: 430.w,
                            height: 56.h,
                            buttonText: 'Add User',
                            onTapAction: () async {
                              validateForm(
                                  captureImageScreenController:
                                      captureImageScreenController,
                                  formErrorController: formErrorController,
                                  idCardCaptureController:
                                      idCardCaptureController,
                                  userOnboardingScreenController:
                                      userOnboardingScreenController,
                                  phoneNum: userOnboardingScreenController
                                      .phoneNumController.value.text
                                      .trim());
                              if (userOnboardingScreenController
                                  .formKey.currentState!
                                  .validate()) {
                                if (userOnboardingScreenController
                                        .isFormValid.value ==
                                    true) {
                                  ///TODO upload data
                                  await userOnboardingScreenController
                                      .uploadData();

                                  Get.showSnackbar(
                                    GetSnackBar(
                                      messageText: Text(
                                        errorController.errorMsg.isNotEmpty
                                            ? errorController.errorMsg
                                                .toString()
                                            : 'New User created',
                                        textAlign: TextAlign.center,
                                        style: Get.textTheme.bodyMedium
                                            ?.copyWith(
                                                color:
                                                    Constants.colourTextDark),
                                      ),
                                      duration: const Duration(seconds: 2),
                                      snackPosition: SnackPosition.BOTTOM,
                                      backgroundColor: Colors.white,
                                      boxShadows: [
                                        BoxShadow(
                                            color: Colors.grey,
                                            blurRadius: 62.0.r),
                                      ],
                                      snackStyle: SnackStyle.FLOATING,
                                      borderRadius: 50.r,
                                      margin: EdgeInsets.all(10.w),
                                    ),
                                  );

                                  //firestoreController.addNewUser(phoneNum: phoneNum, userType: userType)
                                }
                              } else {
                                userOnboardingScreenController
                                    .isFormValid.value = false;
                                print(formErrorController.errors);
                              }
                            },
                          ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget buildCapturedCard(
      {required IdCardCaptureController cardCaptureController,
      required ScanDirection direction}) {
    return Container(
      decoration: BoxDecoration(
        color: Constants.colourBorderLight,
        borderRadius: BorderRadius.circular(10.r),
      ),
      child: Padding(
        padding: EdgeInsets.fromLTRB(12.w, 8.h, 16.w, 8.h),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SizedBox(
              width: 83.w,
              height: 51.h,
              child: Image.file(
                File(direction == ScanDirection.front
                    ? cardCaptureController.documentFront[0]
                    : cardCaptureController.documentBack[0]),
                fit: BoxFit.fill,
              ),
            ),
            Text(
              direction == ScanDirection.front ? 'Front' : 'Back',
              style: Get.textTheme.titleMedium
                  ?.copyWith(color: Constants.colourTextMedium),
            ),
            GestureDetector(
              onTap: () {
                if (direction == ScanDirection.front) {
                  cardCaptureController.documentFront.clear();
                } else {
                  cardCaptureController.documentBack.clear();
                }
              },
              child: SizedBox(
                  width: 17.w,
                  height: 19.h,
                  child: Image.asset('assets/images/binRed.png')),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildDocBox(
      {required IdCardCaptureController idCardCaptureController}) {
    return Column(
      children: [
        /*Align(
          alignment: Alignment.centerLeft,
          child: Text(
            'Upload',
            style: Get.textTheme.headlineMedium
                ?.copyWith(color: Constants.colourTextDark),
          ),
        ),*/
        SizedBox(height: 10.h),
        if (idCardCaptureController.documentFront.isEmpty ||
            idCardCaptureController.documentBack.isEmpty)
          CustomPaint(
            painter: DottedBorderPainter(
              color: Constants.colourBorderDark,
              strokeWidth: 1.0,
              borderRadius: 10.r,
              dashWidth: 3,
              dashSpace: 2,
            ),
            child: Container(
              width: 406.w,
              height: 159.h,
              clipBehavior: Clip.antiAlias,
              decoration: BoxDecoration(
                color: Constants.colourBorderLight,
                borderRadius: BorderRadius.all(
                  Radius.circular(13.r),
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  GestureDetector(
                    onTap: () {
                      Get.to(() => const UserIdCardInfoScreen());
                    },
                    child: Image.asset(
                      'assets/images/iconUpload.png',
                      width: 30.w,
                      height: 30.h,
                    ),
                  ),
                  Text(
                    'Use your phone camera or upload from gallery to scan documents (front and back)',
                    style: Get.textTheme.titleSmall,
                  ),

                  /* FormFieldButton(
                width: 98.w,
                height: 29.h,
                buttonText: 'Add file',
                textStyle:
                    Get.textTheme.displayLarge?.copyWith(color: Colors.white),
                onTapAction: () {},
              )*/
                ],
              ),
            ),
          ),
        SizedBox(height: 10.h),
      ],
    );
  }

  Align buildSubHeading({required String text, required String assetPath}) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Wrap(
        spacing: 10.w,
        crossAxisAlignment: WrapCrossAlignment.center,
        children: [
          Text(
            text,
            style: Get.textTheme.titleMedium
                ?.copyWith(color: Constants.colourPrimary),
          ),
          Image.asset(
            assetPath,
            width: 16.w,
            height: 16.h,
          ),
        ],
      ),
    );
  }

  Widget buildProfilePicCircle(
      CaptureImageScreenController captureImageScreenController) {
    return Stack(
      children: [
        Container(
          width: 122.w,
          height: 122.h,
          clipBehavior: Clip.antiAlias,
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            color: Constants.colourTextLight,
          ),
          child: Padding(
            padding: EdgeInsets.all(2.w),
            child: Container(
              width: 100.w,
              height: 100.h,
              clipBehavior: Clip.antiAlias,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.transparent,
                border: Border.all(color: Colors.white, width: 2.0.w),
              ),
              child: Container(
                width: 90.w,
                height: 90.h,
                clipBehavior: Clip.antiAlias,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.transparent,
                ),
                child: captureImageScreenController.imageFilePath.value == ''
                    ? Icon(
                        Icons.person,
                        color: Colors.white,
                        size: 50.w,
                      )
                    : GestureDetector(
                        onTap: () {
                          Get.off(() => DisplayCapturedImageScreen());
                        },
                        child: Image.file(
                          File(
                              captureImageScreenController.imageFilePath.value),
                          fit: BoxFit.fitWidth,
                        ),
                      ),
              ),
            ),
          ),
        ),
        Positioned(
            top: 80.h,
            left: 80.w,
            child: GestureDetector(
                onTap: () {
                  Get.to(() => UserProfilePicInfoScreen());
                },
                child: Image.asset('assets/images/cameraBlue.png')))
      ],
    );
  }

  Widget buildUserTypeField(
      UserOnboardingScreenController userOnboardingScreenController) {
    return FormFieldText(
      focusNode: userOnboardingScreenController.userTypeFocusNode,
      labelText: 'Category',
      textController: userOnboardingScreenController.userTypeController.value,
      readOnly: true,
      border: OutlineInputBorder(
        borderSide: BorderSide.none,
        borderRadius: BorderRadius.all(
          Radius.circular(10.r),
        ),
      ),
      fillColor: Constants.colourBorderLight,
      validator: (val) {
        if (userOnboardingScreenController.userTypeController.value.text
                .trim() ==
            '') {
          return 'Select category';
        }
        return null;
      },
      trailingWidget: IconButton(
          onPressed: () {
            userOnboardingScreenController.invertShowUserTypeValue();
          },
          icon: userOnboardingScreenController.showUserTypeOptions.value == true
              ? Icon(Icons.keyboard_arrow_left_sharp)
              : Icon(Icons.keyboard_arrow_right_sharp)),
    );
  }

  Widget buildUserTypeSelectionBox(
      UserOnboardingScreenController userOnboardingScreenController) {
    return userOnboardingScreenController.showUserTypeOptions.value == true
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
        : Container();
  }

  validateForm(
      {required CaptureImageScreenController captureImageScreenController,
      required FormErrorController formErrorController,
      required IdCardCaptureController idCardCaptureController,
      required UserOnboardingScreenController userOnboardingScreenController,
      required String phoneNum}) async {
    userOnboardingScreenController.isLoading.value = true;
    FormErrorController formErrorController = Get.find();
    formErrorController.resetErrors();

    UsersModel? tempUser =
        await firestoreController.getUser(phoneNum: phoneNum);
    if (tempUser != null) {
      formErrorController.errors.add('User already exists');
    }
    userOnboardingScreenController.isLoading.value = false;

    if (captureImageScreenController.imageFilePath.isEmpty) {
      formErrorController.errors.add('Click a profile picture');
    }

    if (idCardCaptureController.documentFront.isEmpty ||
        idCardCaptureController.documentBack.isEmpty) {
      formErrorController.errors.add('Scan ID card (front and back');
    }
    if (formErrorController.errors.isEmpty) {
      userOnboardingScreenController.isFormValid.value = true;
    }
  }
}
