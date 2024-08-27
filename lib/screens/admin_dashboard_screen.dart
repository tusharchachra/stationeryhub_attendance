import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../controllers/firebase_firestore_controller.dart';
import '../form_fields/form_field_button.dart';
import '../scaffold/scaffold_home.dart';
import '../services/firebase_login_services.dart';
import 'new_organization_screen.dart';

class AdminDashboardScreen extends StatelessWidget {
  const AdminDashboardScreen({super.key});

  static FirebaseFirestoreController firestoreController = Get.find();

  @override
  Widget build(BuildContext context) {
    print('Organization=${firestoreController.registeredOrganization}');
    /* if (firestoreController.registeredOrganization?.value.id == null) {
      Get.to(NewOrganizationScreen());
    }*/
    {
      return ScaffoldHome(
          bodyWidget:
              firestoreController.registeredOrganization?.value.id == null
                  ? buildNewOrganizationMessage()
                  : buildDashboard(),
          isLoading: false,
          pageTitle: 'admin dashboard');
    }
  }

  Column buildDashboard() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
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
        FormFieldButton(
          width: 100.w,
          height: 30.h,
          buttonText: 'Logout',
          onTapAction: () {
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
        FormFieldButton(
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
