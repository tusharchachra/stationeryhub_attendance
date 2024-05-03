import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:stationeryhub_attendance/albums/album_users.dart';
import 'package:stationeryhub_attendance/albums/enum_user_type.dart';
import 'package:stationeryhub_attendance/form_fields/form_field_button.dart';
import 'package:stationeryhub_attendance/scaffold/scaffold_home.dart';
import 'package:stationeryhub_attendance/screens/screen_admin_dashboard.dart';
import 'package:stationeryhub_attendance/screens/screen_mark_attendance.dart';
import 'package:stationeryhub_attendance/services/firebase_login_services.dart';

import '../services/firebase_firestore_services.dart';

class OTPScreen extends StatefulWidget {
  const OTPScreen({
    super.key,
    required this.phoneNum,
    required this.isNewUser,
    /* required this.registeredUser,*/
  });
  final String phoneNum;
  final bool isNewUser;

  @override
  State<OTPScreen> createState() => _OTPScreenState();
}

class _OTPScreenState extends State<OTPScreen> {
  TextEditingController otpController = TextEditingController();
  //Map<String?, dynamic>? fetchedUser;
  AlbumUsers? registeredUser;

  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return ScaffoldHome(
        bodyWidget: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('enter otp'),
            TextFormField(
              controller: otpController,
            ),
            FormFieldButton(
              width: 30,
              height: 10,
              buttonText: 'Submit',
              onTapAction: () async {
                String funcMsg = '';
                //validateForm();
                setState(() {
                  isLoading = true;
                });
                //sign in user
                funcMsg = await FirebaseLoginServices.firebaseInstance.signIn(
                    credential: PhoneAuthProvider.credential(
                        verificationId: FirebaseLoginServices
                            .firebaseInstance.verificationId,
                        smsCode: otpController.text.trim()));

                if (funcMsg == 'success') {
                  if (kDebugMode) {
                    print('successfully signed in');
                  }

                  FirebaseFirestoreServices firestoreServices =
                      FirebaseFirestoreServices();
                  //add new user
                  if (widget.isNewUser) {
                    await firestoreServices.addNewUser(
                        phoneNum: widget.phoneNum, userType: UserType.admin);
                  }

                  registeredUser = await firestoreServices.isUserExists(
                      phoneNum: widget.phoneNum);
                  FirebaseLoginServices.firebaseInstance
                      .storeUserToSharedPrefs(user: registeredUser!);
                  if (kDebugMode) {
                    print(registeredUser);
                  }
                  if (registeredUser?.userType == UserType.admin) {
                    Navigator.of(context).pushAndRemoveUntil(
                        MaterialPageRoute(
                            builder: (context) => AdminDashboardScreen(
                                  user: registeredUser!,
                                )),
                        (route) => false);
                  } else {
                    if (registeredUser?.userType == UserType.employee) {
                      Navigator.of(context).pushAndRemoveUntil(
                          MaterialPageRoute(
                              builder: (context) =>
                                  const MarkAttendanceScreen()),
                          (route) => false);
                    }
                  }
                }
              },
              textStyle: Theme.of(context)
                  .textTheme
                  .bodyMedium!
                  .copyWith(color: Colors.indigo),
              buttonDecoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(Radius.circular(10.0)),
              ),
            ),
            FormFieldButton(
              width: 30,
              height: 10,
              buttonText: 'Back',
              onTapAction: () {
                Navigator.of(context).pop();
              },
              textStyle: Theme.of(context)
                  .textTheme
                  .bodyMedium!
                  .copyWith(color: Colors.indigo),
              buttonDecoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(Radius.circular(10.0)),
              ),
            )
          ],
        ),
        isLoading: isLoading,
        pageTitle: 'OTP');
  }
}
