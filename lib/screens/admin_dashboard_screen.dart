import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:stationeryhub_attendance/controllers/admin_dashboard_screen_controller.dart';
import 'package:stationeryhub_attendance/controllers/firebase_auth_controller.dart';
import 'package:stationeryhub_attendance/helpers/constants.dart';
import 'package:stationeryhub_attendance/scaffold/scaffold_dashboard.dart';

import '../controllers/firebase_firestore_controller.dart';
import '../form_fields/form_field_button.dart';
import '../services/firebase_login_services.dart';
import 'new_organization_screen.dart';

class AdminDashboardScreen extends StatelessWidget {
  const AdminDashboardScreen({super.key});

  static FirebaseFirestoreController firestoreController = Get.find();
  static FirebaseAuthController authController = Get.find();
  static AdminDashboardScreenController adminDashboardScreenController =
      Get.find();

  @override
  Widget build(BuildContext context) {
    /* if (firestoreController.registeredOrganization?.value.id == null) {
      Get.to(NewOrganizationScreen());
    }*/
    {
      return Obx(() => firestoreController.isLoading.value == true
          ? Center(child: CircularProgressIndicator())
          : firestoreController.registeredOrganization?.value?.id == null
              ? buildNewOrganizationMessage()
              : buildDashboard1());
    }
  }

  Widget buildDashboard1() {
    return ScaffoldDashboard(
      leadingWidget: Padding(
        padding: EdgeInsets.fromLTRB(12.w, 13.h, 0, 13.h),
        child: CircleAvatar(
          maxRadius: 22.r,
          backgroundColor: colourProfilePicIconBackground,
          child: const Icon(
            Icons.person,
            color: Colors.white,
          ),
        ),
      ),
      pageTitle: firestoreController.registeredUser?.value?.name ?? 'Guest',
      pageSubtitle:
          '\n${firestoreController.registeredUser?.value?.userType?.name.capitalizeFirst}'
              .toString(),
      bodyWidget: Container(),
      isLoading: false,
      appBarActions: [
        IconButton(
          onPressed: () {},
          icon: const Icon(Icons.more_vert),
          color: Colors.white,
        )
      ],
    );
  }

  Column buildDashboard() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          firestoreController.registeredOrganization?.value?.name ?? '',
          style: Get.textTheme.displayLarge,
        ),
        FormFieldButton(
          width: 100.w,
          height: 30.h,
          buttonText: 'Create new user',
          onTapAction: () {
            /* Navigator.of(context).push(
                MaterialPageRoute(
                    builder: (context) => const NewUserForOrganizationScreen()),
              );*/
          },
        ),
        FormFieldButton(
          width: 100.w,
          height: 30.h,
          buttonText: 'Mark Attendance',
          onTapAction: () {
            /* Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => MarkAttendanceScreen()),
              );*/
          },
        ),
        authController.isSigningOut.isTrue
            ? CircularProgressIndicator()
            : FormFieldButton(
                width: 100.w,
                height: 30.h,
                buttonText: 'Logout',
                onTapAction: () {
                  authController.signOutUser();
                  //FirebaseLoginServices.firebaseInstance.signOutUser();
                },
              )
      ],
    );
  }

  Column buildNewOrganizationMessage() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Obx(
          () => Text(
            'Hello ${firestoreController.registeredUser?.value?.name}',
            style: Get.textTheme.displayLarge,
          ),
        ),
        Text(
          'Set up new organization',
          style: Get.textTheme.displayMedium,
        ),
        FormFieldButton(
          width: 384.w,
          height: 56.h,
          buttonText: 'Set up',
          onTapAction: () {
            Get.to(NewOrganizationScreen());
            /* Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => const NewOrganizationScreen()));*/
          },
        ),
        authController.isSigningOut.isTrue
            ? SizedBox(
                width: 25.w,
                height: 25.h,
                child: const CircularProgressIndicator(),
              )
            : FormFieldButton(
                width: 384.w,
                height: 56.h,
                buttonText: 'Logout',
                onTapAction: () {
                  FirebaseLoginServices.firebaseInstance.signOutUser();
                },
              )
      ],
    );
  }
}
