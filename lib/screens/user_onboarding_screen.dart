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

class UserOnboardingScreen extends StatelessWidget {
  const UserOnboardingScreen({super.key});

  static FirebaseFirestoreController firestoreController = Get.find();
  static UserOnboardingScreenController userOnboardingScreenController =
      Get.find();

  @override
  Widget build(BuildContext context) {
    Get.put(UserOnboardingScreenController());
    return ScaffoldDashboard(
      isLoading: false,
      pageTitle: 'New User',
      bodyWidget: Padding(
        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.h),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            CircleAvatar(
              radius: 80.r,
              child:
                  firestoreController.registeredUser?.value?.profilePicPath ==
                          ''
                      ? const Icon(
                          Icons.camera_alt,
                          color: Colors.white,
                        )
                      : CachedNetworkImage(
                          placeholder: (context, url) => Icon(
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
              textController:
                  userOnboardingScreenController.nameController.value,
              labelText: 'Name',
            ),
            SizedBox(height: 14.h),
            FormFieldPhoneNum(
                labelText: 'Phone number',
                validatorPhoneNum: (val) {},
                onChangedAction: (val) {}),
            SizedBox(height: 14.h),
            DropdownMenu(
              dropdownMenuEntries: UserType.values
                  .map<DropdownMenuEntry<UserType>>(
                    (e) => DropdownMenuEntry<UserType>(
                      value: e,
                      label: e.getName(),
                    ),
                  )
                  .toList(),
              width: 406.w,
              menuStyle: MenuStyle(
                backgroundColor: WidgetStatePropertyAll(Colors.white),
                minimumSize: WidgetStatePropertyAll(
                  Size(406.w, 121.h),
                ),
              ),
              expandedInsets: EdgeInsets.zero,
              trailingIcon: Icon(Icons.keyboard_arrow_down_sharp),
              selectedTrailingIcon: Icon(Icons.keyboard_arrow_up_sharp),

              /*menuWidth: 406.w,
                borderRadius: BorderRadius.circular(10.r),
                dropdownColor: Colors.white,
                isExpanded: true,
                alignment: Alignment.center,
                onChanged: (val) {}*/
            ),
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
    );
  }
}
