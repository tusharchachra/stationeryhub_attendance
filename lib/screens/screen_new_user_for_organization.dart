import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:stationeryhub_attendance/albums/album_users.dart';
import 'package:stationeryhub_attendance/albums/enum_user_type.dart';
import 'package:stationeryhub_attendance/services/firebase_firestore_services.dart';
import 'package:stationeryhub_attendance/services/shared_prefs_services.dart';

import '../form_fields/form_field_button.dart';
import '../scaffold/scaffold_home.dart';

class NewUserForOrganizationScreen extends StatefulWidget {
  const NewUserForOrganizationScreen({super.key});

  @override
  State<NewUserForOrganizationScreen> createState() =>
      _NewUserForOrganizationScreenState();
}

class _NewUserForOrganizationScreenState
    extends State<NewUserForOrganizationScreen> {
  final _formKey = GlobalKey<FormState>();
  FirebaseFirestoreServices firestoreServices = FirebaseFirestoreServices();
  bool isLoading = false;
  List<String> userTypeList = [];
  AlbumUsers? currentUser;
  String selUserType = '';
  TextEditingController nameController = TextEditingController();
  TextEditingController phoneNumController = TextEditingController();
  TextEditingController roleController = TextEditingController();

  @override
  void initState() {
    super.initState();
    loadData();
  }

  void loadData() async {
    userTypeList = UserType.values.map((e) => e.name).toList();
    currentUser =
        await SharedPrefsServices.sharedPrefsInstance.getUserFromSharedPrefs();
    print(currentUser);
  }

  @override
  Widget build(BuildContext context) {
    return ScaffoldHome(
      isLoading: isLoading,
      pageTitle: 'New User for organization',
      bodyWidget: Form(
        key: _formKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextFormField(
              controller: nameController,
              decoration: InputDecoration(
                label: Text('Name'),
              ),
            ),
            TextFormField(
              controller: phoneNumController,
              decoration: InputDecoration(
                label: Text('Phone Number'),
              ),
            ),
            DropdownMenu(
                enableSearch: true,
                onSelected: (String? value) {
                  // This is called when the user selects an item.
                  setState(() {
                    selUserType = value!;
                  });
                },
                dropdownMenuEntries:
                    userTypeList.map<DropdownMenuEntry<String>>((String value) {
                  return DropdownMenuEntry<String>(value: value, label: value);
                }).toList()),
            FormFieldButton(
                width: 30,
                height: 10,
                buttonText: 'Submit',
                onTapAction: () async {
                  if (_formKey.currentState!.validate()) {
                    setState(() {
                      isLoading = true;
                    });
                    AlbumUsers? registeredUser = await firestoreServices
                        .isUserExists(phoneNum: phoneNumController.text.trim());
                    if (registeredUser != null) {
                      if (kDebugMode) {
                        print('User already exists');
                      }
                    } else {
                      try {
                        await firestoreServices.addNewUser(
                            phoneNum: phoneNumController.text.trim(),
                            userType: UserType.values.byName(selUserType),
                            orgId: currentUser!.organizationId);
                        registeredUser = await firestoreServices.isUserExists(
                            phoneNum: phoneNumController.text.trim());
                        if (registeredUser != null) {
                          if (kDebugMode) {
                            print('New user created:$registeredUser');
                          }
                        }
                      } on Exception catch (e) {
                        print(e);
                      }
                    }
                    setState(() {
                      isLoading = false;
                    });
                  }
                },
                buttonDecoration: BoxDecoration(color: Colors.green),
                textStyle: TextStyle()),
            FormFieldButton(
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
