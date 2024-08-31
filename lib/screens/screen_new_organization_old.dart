import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:stationeryhub_attendance/albums/album_organizations.dart';
import 'package:stationeryhub_attendance/albums/enum_subscription_type.dart';
import 'package:stationeryhub_attendance/form_fields/form_field_button_old.dart';
import 'package:stationeryhub_attendance/scaffold/scaffold_home.dart';
import 'package:stationeryhub_attendance/screens/screen_admin_dashboard_old.dart';
import 'package:stationeryhub_attendance/services/location_handler.dart';
import 'package:stationeryhub_attendance/services/shared_prefs_services.dart';

import '../albums/album_users.dart';
import '../services/firebase_firestore_services.dart';

class NewOrganizationScreenOld extends StatefulWidget {
  const NewOrganizationScreenOld({super.key});

  @override
  State<NewOrganizationScreenOld> createState() =>
      _NewOrganizationScreenOldState();
}

class _NewOrganizationScreenOldState extends State<NewOrganizationScreenOld> {
  final _formKey = GlobalKey<FormState>();
  bool isLoading = false;
  TextEditingController nameController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController geoLocationController = TextEditingController();
  Position? currentPosition;
  AlbumUsers? currentUser;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loadData();
  }

  void loadData() async {
    setState(() {
      isLoading = true;
    });
    currentUser =
        await SharedPrefsServices.sharedPrefsInstance.getUserFromSharedPrefs();
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return ScaffoldHome(
      isLoading: isLoading,
      pageTitle: 'New',
      bodyWidget: Form(
        key: _formKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextFormField(
              controller: nameController,
              decoration: InputDecoration(
                label: Text('Organization Name'),
              ),
            ),
            TextFormField(
              controller: addressController,
              decoration: InputDecoration(
                label: Text('Address'),
              ),
            ),
            TextFormField(
              controller: geoLocationController,
              decoration: InputDecoration(
                label: Text('Geo location'),
              ),
            ),
            FormFieldButtonOld(
                width: 30,
                height: 10,
                buttonText: 'Fetch location',
                onTapAction: () async {
                  setState(() {
                    isLoading = true;
                  });
                  currentPosition = await LocationHandler
                      .locationHandlerInstance
                      .getCurrentPosition();
                  setState(() {
                    currentPosition;
                    isLoading = false;
                  });
                  if (currentPosition == null && context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                        content: Text(
                            'Please check location permission and retry')));
                  } else {
                    geoLocationController.text = currentPosition.toString();
                  }
                },
                buttonDecoration: BoxDecoration(),
                textStyle: TextStyle()),
            FormFieldButtonOld(
                width: 30,
                height: 10,
                buttonText: 'Submit',
                onTapAction: () async {
                  if (_formKey.currentState!.validate()) {
                    setState(() {
                      isLoading = true;
                    });
                    FirebaseFirestoreServices firestoreServices =
                        FirebaseFirestoreServices();
                    AlbumOrganization newOrganization = AlbumOrganization(
                      name: nameController.text.trim(),
                      address: addressController.text.trim(),
                      geoLocationLat: currentPosition?.latitude,
                      geoLocationLong: currentPosition?.longitude,
                      createdOn: DateTime.now(),
                      createdBy: currentUser!.firebaseId!,
                      subscription: SubscriptionType.gold,
                    );

                    String? insertedOrganizationId = await firestoreServices
                        .createOrganization(newOrganization: newOrganization);
                    //inserting the newOrganizationId to the user's profile
                    await firestoreServices.updateOrganizationIdInCreator(
                        currentUserId: currentUser!.firebaseId!,
                        organizationId: insertedOrganizationId!);

                    /*AlbumOrganization? insertedOrganization =
                        await firestoreServices.getOrganization(
                            orgId: insertedOrganizationId);
                    print(insertedOrganization);
                    await SharedPrefsServices.sharedPrefsInstance
                        .storeOrganizationToSharedPrefs(
                            organization: insertedOrganization!);*/

                    setState(() {
                      isLoading = false;
                    });
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => AdminDashboardScreenOld()));
                  }
                },
                buttonDecoration: BoxDecoration(color: Colors.green),
                textStyle: TextStyle()),
            FormFieldButtonOld(
                width: 30,
                height: 10,
                buttonText: 'back',
                onTapAction: () {
                  Navigator.of(context).pop();
                },
                buttonDecoration: BoxDecoration(color: Colors.green),
                textStyle: TextStyle()),
          ],
        ),
      ),
    );
  }
}
