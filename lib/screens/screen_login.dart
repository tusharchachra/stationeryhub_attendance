import 'package:flutter/material.dart';
import 'package:stationeryhub_attendance/helpers/size_config.dart';
import 'package:stationeryhub_attendance/scaffold/scaffold_home.dart';

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
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: SizeConfig.getSize(10),
              ),
            ),
            SizedBox(height: SizeConfig.getSize(5)),
            Text(
              'Attendance Marking System',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.normal,
                fontSize: SizeConfig.getSize(3),
              ),
            ),
            SizedBox(height: SizeConfig.getSize(20)),
            Text(
              'Login with your phone number',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.normal,
                fontSize: SizeConfig.getSize(3),
              ),
            ),
            SizedBox(height: SizeConfig.getSize(2)),
            Form(
              key: _formKey,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              child: SizedBox(
                width: SizeConfig.getSize(70),
                height: SizeConfig.getSize(20),
                child: TextFormField(
                  controller: phoneNumController,
                  style: const TextStyle(
                    color: Colors.white,
                    letterSpacing: 5,
                  ),
                  keyboardType: TextInputType.phone,
                  autofocus: false,
                  maxLength: 10,
                  cursorColor: Colors.white,
                  decoration: InputDecoration(
                      prefix: const Text(
                        '+91-',
                        style: TextStyle(color: Colors.white),
                      ),
                      prefixIcon: const Icon(Icons.phone),
                      prefixIconColor: Colors.white,
                      fillColor: Colors.black38,
                      counterText: '',
                      filled: true,
                      border: const OutlineInputBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(40.0),
                        ),
                      ),
                      focusedBorder: const OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.white),
                          borderRadius:
                              BorderRadius.all(Radius.circular(40.0))),
                      contentPadding:
                          const EdgeInsets.symmetric(horizontal: 20.0),
                      errorStyle: TextStyle(
                          height: 0.1,
                          color: Colors.red[900],
                          fontWeight: FontWeight.bold,
                          fontSize: SizeConfig.getSize(3))),
                  validator: (value) {
                    if (value == '7808814341') {
                      return null;
                    } else if (value!.length < 10) {
                      return null;
                    } else {
                      return 'Unauthorised user';
                    }
                  },
                  onChanged: (value) {
                    setState(() {
                      if (value == '7808814341') {
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
            GestureDetector(
              child: Container(
                width: SizeConfig.getSize(30),
                height: SizeConfig.getSize(10),
                decoration: BoxDecoration(
                    color: isPhoneNumValid ? Colors.white : Colors.black26,
                    borderRadius:
                        const BorderRadius.all(Radius.circular(40.0))),
                child: Center(
                  child: Text(
                    'Submit',
                    style: TextStyle(
                        color:
                            isPhoneNumValid ? Colors.black54 : Colors.black38,
                        fontSize: SizeConfig.getSize(5),
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              onTap: () {
                if (isPhoneNumValid) {
                } else {}

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
