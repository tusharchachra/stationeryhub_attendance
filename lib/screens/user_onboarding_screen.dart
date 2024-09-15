import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:stationeryhub_attendance/components/form_field_button.dart';
import 'package:stationeryhub_attendance/components/form_field_phone_num.dart';
import 'package:stationeryhub_attendance/components/form_field_text.dart';
import 'package:stationeryhub_attendance/controllers/firebase_firestore_controller.dart';
import 'package:stationeryhub_attendance/controllers/user_onboarding_screen_controller.dart';
import 'package:stationeryhub_attendance/models/user_type_enum.dart';
import 'package:stationeryhub_attendance/scaffold/scaffold_dashboard.dart';
import 'package:stationeryhub_attendance/screens/user_id_card_info_screen.dart';
import 'package:stationeryhub_attendance/screens/user_profile_pic_info_screen.dart';

import '../helpers/constants.dart';

class UserOnboardingScreen extends StatelessWidget {
  UserOnboardingScreen({super.key});

  static FirebaseFirestoreController firestoreController = Get.find();
  static UserOnboardingScreenController userOnboardingScreenController =
      Get.find();
  final FocusNode focusNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    Get.put(UserOnboardingScreenController());
    return ScaffoldDashboard(
      isLoading: false,
      pageTitle: 'New User',
      bodyWidget: Padding(
        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.h),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              CircleAvatar(
                radius: 80.r,
                child:
                    firestoreController.registeredUser?.value?.profilePicPath ==
                            ''
                        ? IconButton(
                            icon: Icon(Icons.camera_alt),
                            color: Colors.white,
                            onPressed: () {
                              Get.to(() => UserProfilePicInfoScreen());
                            },
                          )
                        : CachedNetworkImage(
                            placeholder: (context, url) => Icon(
                              Icons.camera,
                              color: Colors.white,
                            ),
                            errorWidget: (context, url, error) => Icon(
                              Icons.camera,
                              color: Colors.white,
                            ),
                            imageUrl: firestoreController
                                    .registeredUser?.value?.profilePicPath ??
                                '',
                          ),
              ),
              SizedBox(height: 14.h),
              FormFieldText(
                labelText: 'Name',
                textController:
                    userOnboardingScreenController.nameController.value,
              ),
              SizedBox(height: 14.h),
              FormFieldPhoneNum(
                focusNode: focusNode,
                labelText: 'Phone number',
                validatorPhoneNum: (val) {},
                onChangedAction: (val) {},
              ),
              SizedBox(height: 14.h),
              Obx(
                () => FormFieldText(
                  focusNode: userOnboardingScreenController.userTypeFocusNode,
                  labelText: 'User type',
                  textController:
                      userOnboardingScreenController.userTypeController.value,
                  readOnly: true,
                  trailingWidget: IconButton(
                      onPressed: () {
                        userOnboardingScreenController
                            .invertShowUserTypeValue();
                      },
                      icon: userOnboardingScreenController
                                  .showUserTypeOptions.value ==
                              true
                          ? Icon(Icons.keyboard_arrow_up_sharp)
                          : Icon(Icons.keyboard_arrow_down_sharp)),
                ),
              ),
              SizedBox(height: 5.h),
              Obx(
                () => userOnboardingScreenController
                            .showUserTypeOptions.value ==
                        true
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
                                      userOnboardingScreenController
                                          .userTypeController
                                          .value
                                          .text = e.getName().capitalizeFirst!;
                                      userOnboardingScreenController
                                          .selectedUserType.value = e;
                                      userOnboardingScreenController
                                          .invertShowUserTypeValue();
                                    },
                                    child: Padding(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 24.w, vertical: 10.h),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            e.getName().capitalizeFirst!,
                                            style: Get.textTheme.displaySmall
                                                ?.copyWith(
                                                    color: userOnboardingScreenController
                                                                .selectedUserType
                                                                .value ==
                                                            e
                                                        ? Constants
                                                            .colourPrimary
                                                        : Constants
                                                            .colourTextLight),
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
                          /* itemCount: UserType.values.length,
                                        itemBuilder: (context, index) =>
                          Text(UserType.values.length.toString(),*/
                        ),
                      )
                    : Container(),
              ),
              SizedBox(height: 14.h),
              TextButton(
                  onPressed: () {
                    Get.to(() => UserIdCardInfoScreen());
                  },
                  child: Text('Scan Id')),
              SizedBox(height: 14.h),
              FormFieldButton(
                width: 430.w,
                height: 56.h,
                buttonText: 'Add User',
                onTapAction: () {},
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/*Obx(
                  () => SizedBox(
                    height: 60.h,
                    child: DropdownMenu(
                      inputFormatters: [
                        FilteringTextInputFormatter.deny(RegExp("."))
                      ],
                      //requestFocusOnTap: true,
                      enableFilter: false,
                      controller: userOnboardingScreenController
                          .userTypeController.value,
                      textStyle: Get.textTheme.headlineMedium?.copyWith(
                        color: Constants.colourTextMedium,
                      ),
                      onSelected: (val) => userOnboardingScreenController
                          .selectedUserType.value = val!,
                      dropdownMenuEntries: UserType.values
                          .map<DropdownMenuEntry<UserType>>(
                            (e) => DropdownMenuEntry<UserType>(
                              value: e,
                              label: e.getName().capitalizeFirst!,
                              labelWidget: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
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
                          )
                          .toList(),
                      menuStyle: MenuStyle(
                          side: WidgetStatePropertyAll(
                              BorderSide(color: Constants.colourPrimary)),
                          backgroundColor: WidgetStatePropertyAll(Colors.white),
                          minimumSize:
                              WidgetStatePropertyAll(Size(500.w, 121.h)),
                          padding: WidgetStatePropertyAll(EdgeInsets.zero)),
                      expandedInsets: EdgeInsets.zero,
                      trailingIcon: Icon(Icons.keyboard_arrow_down_sharp),
                      selectedTrailingIcon: Icon(Icons.keyboard_arrow_up_sharp),
                    ),
                  ),
                ),*/
