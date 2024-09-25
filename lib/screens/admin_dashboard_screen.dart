import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:stationeryhub_attendance/controllers/admin_dashboard_screen_controller.dart';
import 'package:stationeryhub_attendance/controllers/firebase_auth_controller.dart';
import 'package:stationeryhub_attendance/controllers/id_card_capture_controller.dart';
import 'package:stationeryhub_attendance/helpers/constants.dart';
import 'package:stationeryhub_attendance/scaffold/scaffold_dashboard.dart';
import 'package:stationeryhub_attendance/screens/user_onboarding_screen.dart';

import '../components/admin_dashboard_box.dart';
import '../components/date_carousel.dart';
import '../components/form_field_button.dart';
import '../components/gradient_progress_bar.dart';
import '../controllers/db_controller.dart';
import '../controllers/firebase_firestore_controller.dart';
import '../controllers/firebase_storage_controller.dart';
import '../helpers/db_service.dart';
import '../services/firebase_login_services.dart';
import 'new_organization_screen.dart';

class AdminDashboardScreen extends StatelessWidget {
  const AdminDashboardScreen({super.key});

  static FirebaseFirestoreController firestoreController = Get.find();
  static FirebaseAuthController authController = Get.find();

  @override
  Widget build(BuildContext context) {
    Get.put(AdminDashboardScreenController());
    Get.put(FirebaseStorageController());
    Get.put(IdCardCaptureController());
    //AdminDashboardScreenController adminDashboardScreenController = Get.find();
    //FirebaseStorageController firebaseStorageController = Get.find();
    /* if (firestoreController.registeredOrganization?.value.id == null) {
      Get.to(NewOrganizationScreen());
    }*/

    final AttendanceController attendanceController =
        Get.put(AttendanceController(ApiService()));

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
    final AttendanceController attendanceController =
        Get.put(AttendanceController(ApiService()));
    attendanceController.fetchAttendance(userId: 1);
    return ScaffoldDashboard(
      leadingWidget: Padding(
        padding: EdgeInsets.fromLTRB(12.w, 13.h, 0, 13.h),
        child: firestoreController.isLoading.value == true
            ? Container(
                width: 22.w,
                height: 22.h,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                ),
                child: GradientProgressBar(
                  size: Size(22.w, 22.h),
                  child: CircleAvatar(),
                ))

            /* ClipRRect(
                borderRadius: BorderRadius.all(Radius.circular(22.r)),
                child: GradientProgressBar(
                  size: Size(22.w, 22.h),
                ),
              )*/
            : CircleAvatar(
                maxRadius: 22.r,
                //backgroundColor: colourProfilePicIconBackground,
                child: const Icon(
                  Icons.person,
                  color: Colors.white,
                ),
              ),
      ),
      pageTitle:
          (firestoreController.registeredOrganization.value?.name ?? 'Guest'),
      pageSubtitle:
          ('\n${firestoreController.registeredUser.value?.name} - ${firestoreController.registeredUser.value?.userType?.name.capitalizeFirst}'
              .toString()),
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
            Expanded(
              child: Obx(() {
                if (attendanceController.isLoading.value) {
                  return Center(child: CircularProgressIndicator());
                }

                return ListView.builder(
                  itemCount: attendanceController.attendanceList.length,
                  itemBuilder: (context, index) {
                    final attendance =
                        attendanceController.attendanceList[index];
                    return ListTile(
                      title: Text(
                        '${attendance.date} - ${attendance.action}',
                        style: Get.textTheme.displayMedium
                            ?.copyWith(color: Constants.colourTextDark),
                      ),
                      // subtitle: Text(attendance.remarks),
                    );
                  },
                );
              }),
            ),

            TextButton(
                onPressed: () {
                  Get.to(() => UserOnboardingScreen());
                },
                child: Text('Create new user')),
            TextButton(
                onPressed: () {
                  authController.signOutUser();
                },
                child: Text('Sign out')),
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
