import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:stationeryhub_attendance/albums/album_organizations.dart';
import 'package:stationeryhub_attendance/albums/album_users.dart';
import 'package:stationeryhub_attendance/form_fields/form_field_button.dart';
import 'package:stationeryhub_attendance/scaffold/scaffold_home.dart';
import 'package:stationeryhub_attendance/screens/screen_new_organization.dart';
import 'package:stationeryhub_attendance/screens/screen_new_user_for_organization.dart';
import 'package:stationeryhub_attendance/services/shared_prefs_services.dart';

import '../services/firebase_firestore_services.dart';

class AdminDashboardScreen extends StatefulWidget {
  const AdminDashboardScreen({super.key});

  @override
  State<AdminDashboardScreen> createState() => _AdminDashboardScreenState();
}

class _AdminDashboardScreenState extends State<AdminDashboardScreen> {
  bool isLoading = false;
  FirebaseFirestoreServices firestoreServices = FirebaseFirestoreServices();
  AlbumUsers? user;
  AlbumOrganization? organization;

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
      organization =
          await firestoreServices.getOrganization(orgId: user!.organizationId);
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
          TextButton(
              onPressed: () {},
              child: FormFieldButton(
                  width: 30,
                  height: 10,
                  buttonText: 'Create new user',
                  onTapAction: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) =>
                            const NewUserForOrganizationScreen()));
                  },
                  buttonDecoration: const BoxDecoration(),
                  textStyle: const TextStyle()))
        ],
      );

  Column buildNewOrganizationMessage() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text('Set up new organization'),
        FormFieldButton(
            width: 30,
            height: 10,
            buttonText: 'Set up',
            onTapAction: () {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => const NewOrganizationScreen()));
            },
            buttonDecoration: const BoxDecoration(),
            textStyle: const TextStyle())
      ],
    );
  }
}
