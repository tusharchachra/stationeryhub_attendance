import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:stationeryhub_attendance/controllers/admin_dashboard_screen_controller.dart';
import 'package:stationeryhub_attendance/controllers/firebase_auth_controller.dart';
import 'package:stationeryhub_attendance/form_fields/admin_dashboard_box.dart';
import 'package:stationeryhub_attendance/form_fields/gradient_progress_bar.dart';
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
      return Obx(
          () => /*firestoreController.isLoading.value == true
            ? const SplashScreen()
            : firestoreController.registeredOrganization?.value?.id == null
                ? buildNewOrganizationMessage()
                */ /* : firestoreController.isLoading.value == true
                  ? buildDashboardLoading()*/ /*
                : buildDashboard1(),*/
              buildDashboard1());
    }
  }

  Widget buildDashboardLoading() {
    return Container();
  }

  Widget buildDashboard1() {
    return ScaffoldDashboard(
      leadingWidget: Padding(
        padding: EdgeInsets.fromLTRB(12.w, 13.h, 0, 13.h),
        child: CircleAvatar(
          maxRadius: 22.r,
          //backgroundColor: colourProfilePicIconBackground,
          child: firestoreController.isLoading.value == false
              ? ClipRRect(
                  borderRadius: BorderRadius.all(Radius.circular(22.r)),
                  child: GradientProgressBar(
                    size: Size(200, 100),
                    cycle: Duration(seconds: 2),
                    colors: <Color>[
                      Colors.transparent,
                      Colors.grey,

                      /* Colors.pink,
                      Colors.red,
                      Colors.yellow,
                      Colors.green,
                      Colors.cyan,*/
                    ],
                  ),
                )
              : const Icon(
                  Icons.person,
                  color: Colors.white,
                ),
        ),
      ),
      pageTitle: firestoreController.registeredUser?.value?.name ?? 'Guest',
      pageSubtitle:
          '\n${firestoreController.registeredUser?.value?.userType?.name.capitalizeFirst}'
              .toString(),
      isLoading: false,
      appBarActions: [
        IconButton(
          onPressed: () {},
          icon: const Icon(Icons.more_vert),
          color: Colors.white,
        )
      ],
      bodyWidget: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              AdminDashboardBox(
                colour: colourStatusBar,
                title: 'Total employees',
                subTitle: '45',
              ),
              AdminDashboardBox(
                colour: colourDashboardBox1,
                title: 'Total working hours',
                subTitle: '45',
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              AdminDashboardBox(
                colour: colourDashboardBox2,
                title: 'Present',
                subTitle: '45',
                supportingText: '12%',
              ),
              AdminDashboardBox(
                colour: colourDashboardBox3,
                title: 'Absent',
                subTitle: '45',
                supportingText: '12%',
              ),
            ],
          ),
          SizedBox(height: 10.h),
          CarouselSlider(
              disableGesture: false,
              carouselController:
                  adminDashboardScreenController.dateCarouselController.value,
              options: CarouselOptions(
                height: 80.h,
                viewportFraction: 0.25.w,
                onPageChanged: (index, reason) {
                  adminDashboardScreenController.currentDate = index;
                },
              ),
              items: [1, 2, 3, 4, 5]
                  .map((item) => Container(
                        width: 76.w,
                        height: 80.h,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              item.toString(),
                              style: Get.textTheme.displayLarge,
                            ),
                            Text(
                              'Day',
                              style: Get.textTheme.displayMedium,
                            ),
                          ],
                        ),
                        decoration: BoxDecoration(
                            color: Colors.white,
                            border: Border.all(color: colourDateBoxBorder),
                            borderRadius:
                                BorderRadius.all(Radius.circular(14.r))),
                      ))
                  .toList())
        ],
      ),
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
