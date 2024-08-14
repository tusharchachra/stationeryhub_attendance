import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:stationeryhub_attendance/albums/album_users.dart';
import 'package:stationeryhub_attendance/helpers/size_config.dart';
import 'package:stationeryhub_attendance/scaffold/scaffold_home.dart';
import 'package:stationeryhub_attendance/screens/screen_otp.dart';
import 'package:stationeryhub_attendance/services/firebase_login_services.dart';

import '../form_fields/form_field_button.dart';
import '../form_fields/form_field_phone_num.dart';
import '../services/firebase_firestore_services.dart';

class ScreenLogin extends StatefulWidget {
  const ScreenLogin({
    super.key,
  });

  @override
  State<ScreenLogin> createState() => _ScreenLoginState();
}

class _ScreenLoginState extends State<ScreenLogin> {
  TextEditingController phoneNumController = TextEditingController();
  bool isPhoneNumValid = false;
  //Map<String?, dynamic>? fetchedUser;
  AlbumUsers? registeredUser;
  final _formKey = GlobalKey<FormState>();
  String? errorMsg;
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return ScaffoldHome(
      isLoading: isLoading,
      scaffoldDecoration: const BoxDecoration(
          image: DecorationImage(
              image: AssetImage('assets/images/background.jpg'),
              fit: BoxFit.fill)),
      bodyWidget: SizedBox(
        width: SizeConfig.screenWidth,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              'Stationery Hub',
              style: Theme.of(context).textTheme.displayLarge,
            ),
            SizedBox(height: SizeConfig.getSize(5)),
            Text(
              'Attendance Marking System',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            SizedBox(height: SizeConfig.getSize(20)),
            Text(
              'Login with your phone number',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            SizedBox(height: SizeConfig.getSize(2)),
            Form(
              key: _formKey,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              child: SizedBox(
                width: SizeConfig.getSize(70),
                height: SizeConfig.getSize(20),
                child: FormFieldPhoneNum(
                  phoneNumController: phoneNumController,
                  validatorPhoneNum: (value) {
                    /* if (value == '7808814341') {
                      return null;
                    } else */
                    if (value!.length == 10) {
                      return null;
                    } else if (value.length < 10) {
                      return 'Invalid phone number';
                    } else {
                      return 'Unauthorised user';
                    }
                  },
                  onChangedAction: (value) {
                    setState(() {
                      if (_formKey.currentState!.validate()) {
                        isPhoneNumValid = true;
                      } else {
                        isPhoneNumValid = false;
                      }
                    });
                  },
                ),
              ),
            ),
            SizedBox(height: SizeConfig.getSize(20)),
            FormFieldButton(
              buttonText: 'Submit',
              height: 10,
              width: 30,
              textStyle: isPhoneNumValid
                  ? Theme.of(context)
                      .textTheme
                      .bodyMedium!
                      .copyWith(color: Colors.indigo)
                  : Theme.of(context).textTheme.bodyMedium,
              buttonDecoration: BoxDecoration(
                  color: isPhoneNumValid ? Colors.white : Colors.black26,
                  borderRadius: const BorderRadius.all(Radius.circular(40.0))),
              onTapAction: () async {
                if (isPhoneNumValid) {
                  setState(() {
                    isLoading = true;
                  });
                  //check if user exists
                  FirebaseFirestoreServices firestoreServices =
                      FirebaseFirestoreServices();
                  registeredUser = await firestoreServices.getUser(
                      phoneNum: phoneNumController.text.trim());
                  print('registered user= $registeredUser');
                  if (registeredUser != null) {
                    await loginUser();
                  } else {
                    if (kDebugMode) {
                      print('User not registered');
                    }
                    //show dialog to register the new user or cancel
                    buildShowAdaptiveDialog();
                  }
                }
              },
            )
          ],
        ),
      ),
      pageTitle: '',
    );
  }

  Future<void> loginUser() async {
    await FirebaseLoginServices.firebaseInstance.signInPhone(
      phoneNum: phoneNumController.text.trim(),
      otp: '',
      onCodeSentAction: () async {
        setState(() {
          isLoading = true;
        });
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => OTPScreen(
              phoneNum: phoneNumController.text.trim(),
              isNewUser: registeredUser == null ? true : false,
              /*registeredUser: registeredUser!,*/
            ),
          ),
        );
      },
    );
    setState(() {
      isLoading = false;
    });
  }

  Future<dynamic> buildShowAdaptiveDialog() {
    return showAdaptiveDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            actions: [
              FormFieldButton(
                width: 30,
                height: 10,
                buttonText: 'Yes',
                onTapAction: () {
                  loginUser();
                },
                textStyle: Theme.of(context)
                    .textTheme
                    .bodyMedium!
                    .copyWith(color: Colors.indigo),
                buttonDecoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(Radius.circular(10.0))),
              ),
              FormFieldButton(
                width: 30,
                height: 10,
                buttonText: 'Cancel',
                onTapAction: () {
                  Navigator.pop(context);
                },
                textStyle: Theme.of(context)
                    .textTheme
                    .bodyMedium!
                    .copyWith(color: Colors.indigo),
                buttonDecoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(Radius.circular(10.0))),
              )
            ],
            title: const Text(
                'User not found.\n\nIf you are an employee, request your organization to grant access.\nIf you wish to register a new organization, tap Yes '),
          );
        });
  }
}
