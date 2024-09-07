import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../components/form_field_button.dart';
import '../components/form_field_button_old.dart';
import '../models/organizations_model.dart';
import '../models/users_model.dart';
import '../scaffold/scaffold_home.dart';
import '../services/firebase_login_services.dart';
import '../services/shared_prefs_services.dart';
import 'screen_mark_attendance.dart';
import 'screen_new_organization_old.dart';
import 'screen_new_user_for_organization_old.dart';

class AdminDashboardScreenOld extends StatefulWidget {
  const AdminDashboardScreenOld({super.key});

  @override
  State<AdminDashboardScreenOld> createState() =>
      _AdminDashboardScreenOldState();
}

class _AdminDashboardScreenOldState extends State<AdminDashboardScreenOld> {
  bool isLoading = false;
  //FirebaseFirestoreServices firestoreServices = FirebaseFirestoreServices();
  UsersModel? user;
  OrganizationModel? organization;

  @override
  void initState() {
    super.initState();
    loadData();
  }

  Future loadData() async {
    setState(() {
      isLoading = true;
    });
    user =
        await SharedPrefsServices.sharedPrefsInstance.getUserFromSharedPrefs();
    bool isOrganizationInSharedPrefs = await SharedPrefsServices
        .sharedPrefsInstance
        .isKeyExists(key: 'organization');
    if (isOrganizationInSharedPrefs) {
      organization = await SharedPrefsServices.sharedPrefsInstance
          .getOrganizationFromSharedPrefs();
    } else {
      /* organization =
          await firestoreServices.getOrganization(orgId: user!.organizationId);*/
    }
    if (kDebugMode) {
      print(
          'Fetched organization from ${isOrganizationInSharedPrefs ? 'Shared Prefs' : 'Server'} : $organization');
    }
    setState(() {
      isLoading = false;
      user;
      organization;
    });
  }

  @override
  Widget build(BuildContext context) {
    return ScaffoldHome(
        bodyWidget: organization == null
            ? buildNewOrganizationMessage()
            : buildDashboard(),
        isLoading: false,
        pageTitle: 'admin dashboard');
  }

  Column buildDashboard() => Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          FormFieldButton(
            width: 30,
            height: 10,
            buttonText: 'Create new user',
            onTapAction: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                    builder: (context) =>
                        const NewUserForOrganizationScreenOld()),
              );
            },
          ),
          FormFieldButton(
            width: 30,
            height: 10,
            buttonText: 'Mark Attendance',
            onTapAction: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => MarkAttendanceScreen()),
              );
            },
          ),
          FormFieldButton(
            width: 30,
            height: 10,
            buttonText: 'Logout',
            onTapAction: () {
              //FirebaseLoginServices.firebaseInstance.signOutUser();
            },
          )
        ],
      );

  Column buildNewOrganizationMessage() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text('Set up new organization'),
        FormFieldButtonOld(
            width: 30,
            height: 10,
            buttonText: 'Set up',
            onTapAction: () {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => const NewOrganizationScreenOld()));
            },
            buttonDecoration: const BoxDecoration(),
            textStyle: const TextStyle()),
        FormFieldButton(
          width: 100.w,
          height: 20.h,
          buttonText: 'Logout',
          onTapAction: () {
            FirebaseLoginServices.firebaseInstance.signOutUser();
          },
        )
      ],
    );
  }
}
