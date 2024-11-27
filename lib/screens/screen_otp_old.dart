import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:stationeryhub_attendance/scaffold/scaffold_home.dart';
import 'package:stationeryhub_attendance/screens/screen_admin_dashboard_old.dart';
import 'package:stationeryhub_attendance/screens/screen_mark_attendance_old.dart';

import '../components/form_field_button_old.dart';
import '../models/user_type_enum.dart';
import '../models/users_model.dart';
import '../services/firebase_firestore_services.dart';
import '../services/shared_prefs_services.dart';

class OTPScreenOld extends StatefulWidget {
  const OTPScreenOld({
    super.key,
    required this.phoneNum,
    required this.isNewUser,
    /* required this.registeredUser,*/
  });
  final String phoneNum;
  final bool isNewUser;

  @override
  State<OTPScreenOld> createState() => _OTPScreenOldState();
}

class _OTPScreenOldState extends State<OTPScreenOld> {
  TextEditingController otpController = TextEditingController();
  //Map<String?, dynamic>? fetchedUser;
  UsersModel? registeredUser;

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
            FormFieldButtonOld(
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
                /*funcMsg = await FirebaseLoginServices.firebaseInstance.signIn(
                    credential: PhoneAuthProvider.credential(
                        verificationId: FirebaseLoginServices
                            .firebaseInstance.verificationId,
                        smsCode: otpController.text.trim()));*/

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
                    registeredUser = await firestoreServices.getUser(
                        phoneNum: widget.phoneNum);
                  } else {
                    registeredUser = await firestoreServices.getUser(
                        phoneNum: widget.phoneNum,
                        getOptions: const GetOptions(source: Source.cache));
                  }
                  /* registeredUser = await firestoreServices.isUserExists(
                      phoneNum: widget.phoneNum);*/
                  await SharedPrefsServices.sharedPrefsInstance
                      .storeUserToSharedPrefs(user: registeredUser!);
                  setState(() {
                    isLoading = false;
                  });
                  if (kDebugMode) {
                    print('Registered user = $registeredUser');
                  }
                  if (registeredUser!.userType == UserType.admin) {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                          builder: (context) => AdminDashboardScreenOld()),
                    );
                  } else {
                    if (registeredUser!.userType == UserType.employee) {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                            builder: (context) => const MarkAttendanceScreen()),
                      );
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
            FormFieldButtonOld(
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
