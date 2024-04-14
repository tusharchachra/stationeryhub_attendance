import 'package:flutter/material.dart';
import 'package:stationeryhub_attendance/albums/album_organization.dart';
import 'package:stationeryhub_attendance/albums/album_users.dart';
import 'package:stationeryhub_attendance/form_fields/form_field_button.dart';
import 'package:stationeryhub_attendance/scaffold/scaffold_home.dart';
import 'package:stationeryhub_attendance/screens/screen_new_organization.dart';

import '../services/firebase_firestore_services.dart';

class AdminDashboardScreen extends StatefulWidget {
  const AdminDashboardScreen({super.key, required this.user});

  final AlbumUsers user;

  @override
  State<AdminDashboardScreen> createState() => _AdminDashboardScreenState();
}

class _AdminDashboardScreenState extends State<AdminDashboardScreen> {
  AlbumOrganization? organization;
  bool isLoading = false;
  FirebaseFirestoreServices firestoreServices = FirebaseFirestoreServices();

  @override
  void initState() {
    super.initState();
    loadOrganizationDetails();
  }

  Future loadOrganizationDetails() async {
    setState(() {
      isLoading = true;
    });
    organization =
        await firestoreServices.getOrganization(phoneNum: widget.user.phoneNum);
    setState(() {
      isLoading = false;
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

  Column buildDashboard() => const Column();

  Column buildNewOrganizationMessage() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text('Set up new organization'),
        FormFieldButton(
            width: 30,
            height: 10,
            buttonText: 'Set up',
            onTapAction: () {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => NewOrganizationScreen()));
            },
            buttonDecoration: BoxDecoration(),
            textStyle: TextStyle())
      ],
    );
  }
}
