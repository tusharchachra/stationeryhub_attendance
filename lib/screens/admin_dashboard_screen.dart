import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:stationeryhub_attendance/components/picture_circle.dart';
import 'package:stationeryhub_attendance/controllers/admin_dashboard_screen_controller.dart';
import 'package:stationeryhub_attendance/controllers/firebase_auth_controller.dart';
import 'package:stationeryhub_attendance/controllers/id_card_capture_controller.dart';
import 'package:stationeryhub_attendance/controllers/local_auth_screen_controller.dart';
import 'package:stationeryhub_attendance/helpers/constants.dart';
import 'package:stationeryhub_attendance/models/attendance_view_model.dart';
import 'package:stationeryhub_attendance/scaffold/scaffold_dashboard.dart';
import 'package:stationeryhub_attendance/screens/local_auth_screen.dart';
import 'package:stationeryhub_attendance/screens/update_organization_screen.dart';

import '../components/admin_dashboard_box.dart';
import '../components/attendance_card.dart';
import '../components/date_carousel.dart';
import '../components/form_field_button.dart';
import '../components/gradient_progress_bar.dart';
import '../controllers/attendance_card_controller.dart';
import '../controllers/firebase_firestore_controller.dart';
import '../controllers/firebase_storage_controller.dart';
import '../services/firebase_login_services.dart';
import 'employee_options_screen.dart';
import 'new_organization_screen.dart';

class AdminDashboardScreen extends StatelessWidget {
  const AdminDashboardScreen({super.key});

  static FirebaseFirestoreController firestoreController = Get.find();
  static FirebaseAuthController authController = Get.find();
  static final AttendanceCardController attendanceCardController = Get.find();

  @override
  Widget build(BuildContext context) {
    Get.put(FirebaseStorageController());
    //Get.put(IdCardCaptureController());
    Get.put(AdminDashboardScreenController(), permanent: true);
    //FirebaseStorageController firebaseStorageController = Get.find();
    /* if (firestoreController.registeredOrganization?.value.id == null) {
      Get.to(NewOrganizationScreen());
    }*/

    {
      return /*firestoreController.isLoading.value == true
            ? const SplashScreen()
            : firestoreController.registeredOrganization?.value?.id == null
                ? buildNewOrganizationMessage()
                */ /* : firestoreController.isLoading.value == true
                  ? buildDashboardLoading()*/ /*
                : buildDashboard1(),*/
          buildDashboard1();
    }
  }

  Widget buildDashboardLoading() {
    return Container();
  }

  void setTitles() {
    AdminDashboardScreenController adminDashboardScreenController = Get.find();

    if (firestoreController.registeredOrganization.value?.name == 'null') {
      adminDashboardScreenController.pageTitle.value = '';
    } else {
      adminDashboardScreenController.pageTitle.value =
          (firestoreController.registeredOrganization.value!.name!);
    }

    if (firestoreController.registeredUser.value?.name == 'null') {
      adminDashboardScreenController.pageSubTitle1.value = '';
    } else {
      adminDashboardScreenController.pageSubTitle1.value =
          (firestoreController.registeredUser.value!.name!);
    }

    if (firestoreController.registeredUser.value?.userType?.name == 'null') {
      adminDashboardScreenController.pageSubTitle2.value = '';
    } else {
      adminDashboardScreenController.pageSubTitle2.value =
          (' - ${firestoreController.registeredUser.value?.userType?.name.capitalizeFirst}');
    }

    /*if()


        ? ''
        : firestoreController.registeredUser.value?.name;
    pageSubTitle2 = ''.obs;
    firestoreController.registeredUser.value?.userType?.name == 'null'
        ? ''
        : firestoreController
            .registeredUser.value?.userType?.name.capitalizeFirst;*/
  }

  Widget buildDashboard1() {
    return ScaffoldDashboard(
      leadingWidget: Padding(
          padding: EdgeInsets.fromLTRB(12.w, 13.h, 0, 13.h),
          child: Obx(
            () => firestoreController.isLoading.value == true
                ? Container(
                    width: 22.w,
                    height: 22.h,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                    ),
                    child: GradientProgressBar(
                      size: Size(22.w, 22.h),
                      child: CircleAvatar(),
                    ),
                  )
                : GestureDetector(
                    onTap: () {
                      Get.to(() => UpdateOrganizationScreen());
                    },
                    child: Obx(
                      () => PictureCircle(
                        height: 22.h,
                        width: 22.w,
                        imgPath: (firestoreController
                                .registeredOrganization.value?.profilePicPath ??
                            ''),
                        backgroundColor:
                            Constants.colourProfilePicIconBackground,
                        /*isNetworkPath: firestoreController
                                    .registeredOrganization
                                    .value
                                    ?.profilePicPath ==
                                ''
                            ? false
                            : true,*/
                        onTap: () {
                          Get.to(() => UpdateOrganizationScreen());
                        },
                      ),
                    ),
                  ),
          ) /* CircleAvatar(
                  maxRadius: 22.r,
                  //backgroundColor: colourProfilePicIconBackground,
                  child: const Icon(
                    Icons.person,
                    color: Colors.white,
                  ),
                ),*/
          ),
      pageTitle: Obx(
        () => firestoreController.isLoading.value == true
            ? const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  GradientProgressBar(size: Size(60, 12)),
                  SizedBox(height: 6.0),
                  GradientProgressBar(size: Size(50, 10)),
                ],
              )
            : Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${firestoreController.registeredOrganization.value?.name}',
                    style: Get.textTheme.headlineLarge
                        ?.copyWith(color: Colors.white),
                  ),
                  Text(
                    '${firestoreController.registeredUser.value?.name} - ${firestoreController.registeredUser.value?.userType?.name.capitalizeFirst}',
                    style: Get.textTheme.titleMedium
                        ?.copyWith(color: Colors.white),
                  ),
                ],
              ),
      ),
      isLoading: false,
      bodyWidget: Padding(
        padding: EdgeInsets.fromLTRB(10.w, 5.h, 10.w, 0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Obx(
              () => Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  AdminDashboardBox(
                    colour: Constants.colourStatusBar,
                    title: 'Total employees',
                    subTitle:
                        firestoreController.userCountForOrganization.toString(),
                    showPlaceholder: firestoreController.showPlaceholder.value,
                  ),
                  AdminDashboardBox(
                    colour: Constants.colourDashboardBox1,
                    title: 'Total working hours',
                    subTitle: '45',
                    showPlaceholder: firestoreController.showPlaceholder.value,
                  ),
                ],
              ),
            ),
            const Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                AdminDashboardBox(
                  colour: Constants.colourDashboardBox2,
                  title: 'Present',
                  subTitle: '45',
                  supportingText: '12%',
                ),
                AdminDashboardBox(
                  colour: Constants.colourDashboardBox3,
                  title: 'Absent',
                  subTitle: '45',
                  supportingText: '12%',
                ),
              ],
            ),
            SizedBox(height: 10.h),
            DateCarousel(),
            SizedBox(height: 10.h),
            Text(
              'Employee List',
              style: Get.textTheme.headlineMedium
                  ?.copyWith(color: Constants.colourTextMedium),
            ),
            //EmployeeAttendanceCard(),
            Obx(
              () => (attendanceCardController.attendanceViewList.isEmpty &&
                      attendanceCardController.isLoading.value == false)
                  ? Expanded(
                      child: Center(
                        child: Text(
                          'No data available',
                          style: Get.textTheme.displaySmall
                              ?.copyWith(color: Constants.colourTextLight),
                        ),
                      ),
                    )
                  : Expanded(
                      child: ListView.builder(
                        itemCount: attendanceCardController.isLoading.value
                            ? 3
                            : attendanceCardController
                                .attendanceViewList.length,
                        itemBuilder: (context, index) {
                          AttendanceViewModel? attendanceView;
                          if (attendanceCardController
                                  .attendanceViewList.isNotEmpty &&
                              attendanceCardController.isLoading.value ==
                                  false) {
                            attendanceView = attendanceCardController
                                .attendanceViewList[index];
                          }

                          return AttendanceCard(
                            attendanceView: attendanceView,
                            showPlaceholder:
                                attendanceCardController.isLoading.value,
                          );
                        },
                      ),
                    ),
            ),

            /* TextButton(
                onPressed: () {
                  Get.to(() => UserOnboardingScreen());
                },
                child: Text('Create new user')),*/
            TextButton(
                onPressed: () {
                  authController.signOutUser();
                },
                child: Text('Sign out')),
            TextButton(
                onPressed: () {
                  LocalAuthScreenController localAuthController =
                      Get.put(LocalAuthScreenController());
                  Get.bottomSheet(
                    LocalAuthScreen(),
                    backgroundColor: Colors.white,
                    isDismissible: false,
                  ).then(
                    (value) {
                      if (localAuthController.isAuthenticated) {
                        Get.to(() => EmployeeOptionsScreen());
                        // localAuthController.dispose();
                      }
                    },
                  );
                },
                child: Text('Emp list')),
          ],
        ),
      ),
    );
  }

  Column buildDashboard() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          firestoreController.registeredOrganization.value?.name ?? '',
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
            'Hello ${firestoreController.registeredUser.value?.name}',
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
