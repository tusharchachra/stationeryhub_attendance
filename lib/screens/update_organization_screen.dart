import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:stationeryhub_attendance/controllers/firebase_auth_controller.dart';
import 'package:stationeryhub_attendance/controllers/firebase_firestore_controller.dart';
import 'package:stationeryhub_attendance/controllers/firebase_storage_controller.dart';
import 'package:stationeryhub_attendance/controllers/update_organization_screen_controller.dart';
import 'package:stationeryhub_attendance/scaffold/scaffold_dashboard.dart';
import 'package:stationeryhub_attendance/screens/pic_info_screen.dart';

import '../components/form_error.dart';
import '../components/form_field_button.dart';
import '../components/form_field_text.dart';
import '../components/picture_circle.dart';
import '../controllers/capture_image_screen_controller.dart';
import '../controllers/firebase_error_controller.dart';
import '../controllers/form_error_controller.dart';
import '../helpers/constants.dart';

class UpdateOrganizationScreen extends StatelessWidget {
  const UpdateOrganizationScreen({super.key});
  // static final _formKey = GlobalKey<FormState>();

  static UpdateOrganizationScreenController updateOrganizationScreenController =
      Get.put(UpdateOrganizationScreenController());
  static FirebaseFirestoreController firestoreController = Get.find();
  static FirebaseStorageController firebaseStorageController = Get.find();
  //static SharedPrefsController sharedPrefsController = Get.find();
  static FirebaseErrorController errorController = Get.find();
  static FirebaseAuthController authController = Get.find();

  @override
  Widget build(BuildContext context) {
    final captureImageScreenController =
        Get.put(CaptureImageScreenController());
    final updateOrganizationScreenController =
        Get.put(UpdateOrganizationScreenController());
    // final idCardCaptureController = Get.put(IdCardCaptureController());
    final formErrorController = Get.put(FormErrorController());
    //final FirebaseStorageController firebaseStorageController = Get.find();
    //final IdCardCaptureController cardCaptureController = Get.find();
    final FirebaseErrorController errorController = Get.find();

    updateOrganizationScreenController.creatorNameController.value.text =
        firestoreController.registeredOrganization.value!.name!;
    updateOrganizationScreenController.orgNameController.value.text =
        firestoreController.registeredOrganization.value!.name!;
    updateOrganizationScreenController.addressController.value.text =
        firestoreController.registeredOrganization.value!.address ?? '';
    captureImageScreenController.imageFilePath.value =
        firestoreController.registeredOrganization.value?.profilePicPath ?? '';

    print('isPiChanged=${updateOrganizationScreenController.isPicChanged}');

    print(
        'captureImageScreenController.imageFilePath.value=${captureImageScreenController.imageFilePath.value}');

    var outlineInputBorder = OutlineInputBorder(
      borderSide: BorderSide.none,
      borderRadius: BorderRadius.all(
        Radius.circular(10.r),
      ),
    );
    return ScaffoldDashboard(
      isLoading: false,
      pageTitle: Text(
        'Update Organization',
        style: Get.textTheme.headlineLarge?.copyWith(color: Colors.white),
      ),
      bodyWidget: Form(
        key: updateOrganizationScreenController.formKey,
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
                  buildOrgPicCircle(captureImageScreenController),
                  SizedBox(height: 48.h),
                  /*buildSubHeading(
                    text: 'Profile',
                    assetPath: 'assets/images/iconEmpDetails.png',
                  ),*/
                  SizedBox(height: 23.h),
                  FormFieldText(
                    labelText: 'Organization Name',
                    textController: updateOrganizationScreenController
                        .orgNameController.value,
                    hintText: 'Enter name',
                    border: outlineInputBorder,
                    fillColor: Constants.colourBorderLight,
                    onChangedAction: (val) {
                      updateOrganizationScreenController.isChangesMade.value =
                          true;
                    },
                    validator: (val) {
                      if (val?.trim() == '') {
                        return 'Name is mandatory';
                      } else
                        return null;
                    },
                  ),
                  SizedBox(height: 20.h),
                  FormFieldText(
                    labelText: 'Address',
                    textController: updateOrganizationScreenController
                        .addressController.value,
                    hintText: 'Enter address',
                    border: outlineInputBorder,
                    fillColor: Constants.colourBorderLight,
                    onChangedAction: (val) {
                      updateOrganizationScreenController.isChangesMade.value =
                          true;
                    },
                    validator: (val) {
                      if (val?.trim() == '') {
                        return 'Address is mandatory';
                      } else
                        return null;
                    },
                  ),
                  SizedBox(height: 20.h),
                  /*FormFieldText(
                    labelText: 'Your name',
                    textController: updateOrganizationScreenController
                        .creatorNameController.value,
                    hintText: 'Enter name',
                    border: outlineInputBorder,
                    fillColor: Constants.colourBorderLight,
                    onChangedAction: (val) {
                      updateOrganizationScreenController.isChangesMade.value =
                          true;
                    },
                    validator: (val) {
                      if (val?.trim() == '') {
                        return 'Your name is mandatory';
                      } else
                        return null;
                    },
                  ),*/
                  SizedBox(height: 14.h),
                  (formErrorController.errors.isNotEmpty)
                      ? FormError()
                      : Container(),
                  SizedBox(height: 10.h),
                  if (firestoreController
                          .registeredOrganization.value?.lastUpdatedOn !=
                      null)
                    Text(
                      'Last update: ${DateFormat('d/M/y hh:mm a').format(firestoreController.registeredOrganization.value!.lastUpdatedOn!)}',
                      //'Previous update: ${firestoreController.registeredOrganization.value!.lastUpdatedOn!}',

                      style: Get.textTheme.labelSmall
                          ?.copyWith(color: Constants.colourTextLight),
                    ),
                  SizedBox(height: 20.h),
                  Obx(
                    () => updateOrganizationScreenController.isLoading.value ==
                            true
                        ? SizedBox(
                            width: 25.w,
                            height: 25.h,
                            child: const CircularProgressIndicator(),
                          )
                        : FormFieldButton(
                            width: 430.w,
                            height: 56.h,
                            buttonText: 'Update',
                            onTapAction: () async {
                              /* var uploadPath =
                                  PicPathEnum.organization.getPath();*/
                              if (updateOrganizationScreenController
                                  .formKey.currentState!
                                  .validate()) {
                                await updateOrganizationScreenController
                                    .uploadData();

                                Get.back();
                                Get.showSnackbar(
                                  GetSnackBar(
                                    messageText: Text(
                                      errorController.errorMsg.isNotEmpty
                                          ? errorController.errorMsg.toString()
                                          : updateOrganizationScreenController
                                                      .isChangesMade.value ==
                                                  true
                                              ? 'Update successful'
                                              : 'No changes made',
                                      textAlign: TextAlign.center,
                                      style: Get.textTheme.bodyMedium?.copyWith(
                                          color: Constants.colourTextDark),
                                    ),
                                    duration: Duration(
                                        seconds: Constants.snackbarDuration),
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
                              } else {
                                /*  updateOrganizationScreenController
                                    .isFormValid.value = false;*/
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

  Widget buildOrgPicCircle(
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
              child: PictureCircle(
                width: 90.w,
                height: 90.w,
                icon: Icon(
                  Icons.business_outlined,
                  color: Colors.white,
                ),
                imgPath: captureImageScreenController.imageFilePath.value,
                /*isNetworkPath: captureImageScreenController
                                .imageFilePath.value !=
                            firestoreController
                                .registeredOrganization.value?.profilePicPath &&
                        updateOrganizationScreenController.isPicChanged.value ==
                            true
                    ? false
                    : true,*/
                onTap: () {
                  /*Get.off(() => DisplayCapturedImageScreen(
                        displayForeground: false,
                      ));*/
                },
              ),
            ),
          ),
        ),
        Positioned(
          top: 80.h,
          left: 80.w,
          child: GestureDetector(
            onTap: () {
              updateOrganizationScreenController.isPicChanged.value = true;
              print(
                  'isPiChanged=${updateOrganizationScreenController.isPicChanged}');
              Get.to(
                () => PicInfoScreen(
                  title: 'Organization picture',
                  infoTile: 'Add a picture of your organization',
                  infoBody:
                      'Click a picture using the camera or upload from gallery',
                  icon: Icon(Icons.business_outlined),
                  backgroundImagePath: 'assets/images/addOrgPicBackground.png',
                  buttonTitle: 'Continue',
                  displayForegroundWhileCapture: false,
                ),
              );
            },
            child: Image.asset('assets/images/cameraBlue.png'),
          ),
        )
      ],
    );
  }
}
