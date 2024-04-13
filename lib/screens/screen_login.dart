import 'package:flutter/material.dart';
import 'package:stationeryhub_attendance/helpers/size_config.dart';
import 'package:stationeryhub_attendance/scaffold/scaffold_home.dart';
import 'package:stationeryhub_attendance/services/firebase_firestore_services.dart';

import '../form_fields/form_field_button.dart';
import '../form_fields/form_field_phone_num.dart';

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
  final _formKey = GlobalKey<FormState>();
  String? errorMsg;
  @override
  Widget build(BuildContext context) {
    return ScaffoldHome(
      isLoading: false,
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
                      /* if (value == '7808814341') {
                        isPhoneNumValid = true;
                      } else {
                        isPhoneNumValid = false;
                      }*/
                    });
                  },
                ),
              ),
            ),
            SizedBox(height: SizeConfig.getSize(20)),
            FormFieldButton(
              isPhoneNumValid: isPhoneNumValid,
              buttonText: 'Submit',
              height: 10,
              width: 30,
              onTapAction: () async {
                ///TODO check if user exists in firebase. if yes, login. if not, ask to register as an organisation or employee
                FirebaseFirestoreServices firestoreServices =
                    FirebaseFirestoreServices();
                print(await firestoreServices.isUserExists(
                    phoneNum: '999999999'));

                /*if (isPhoneNumValid) {
                  Navigator.of(context)
                } else {}
*/
                /*try {
                  if (_formKey.currentState!.validate()) {
                    await FirebaseService.firebaseInstance.signInPhone(
                        context: context,
                        phoneNum: phoneNumController.text.trim(),
                        otp: '000000');
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => OtpScreen(
                            phoneNumber: '99999999999', onSubmit: () {})));
                  }
                } on Exception catch (e) {
                  print(e.toString());
                }*/

                ///Navigate to OTP screen
              },
            )
          ],
        ),
      ),
      pageTitle: '',
    );
  }
}
