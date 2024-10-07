import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:stationeryhub_attendance/controllers/firebase_auth_controller.dart';
import 'package:stationeryhub_attendance/controllers/local_auth_screen_controller.dart';
import 'package:stationeryhub_attendance/helpers/constants.dart';

class LocalAuthScreen extends StatelessWidget {
  const LocalAuthScreen({super.key});
  static final LocalAuthScreenController localAuthController = Get.find();

  @override
  Widget build(BuildContext context) {
    //final LocalAuthScreenController localAuthController = Get.find();
    final FirebaseAuthController firebaseAuthController = Get.find();
    return SizedBox(
      height: 0.5.sh,
      width: 1.sw,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Wrap(
            children: [
              Padding(
                padding: EdgeInsets.fromLTRB(37.w, 62.h, 37.w, 4),
                child: Text(
                  'Authentication required',
                  style: Get.textTheme.displayMedium?.copyWith(
                    color: Constants.colourTextDark,
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(37.w, 4.h, 37.w, 0),
                child: Text(
                  'Confirm your identity to continue',
                  style: Get.textTheme.headlineMedium?.copyWith(
                    color: Constants.colourTextDark,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(width: 30.w),
          Icon(
            Icons.keyboard_arrow_down_sharp,
            color: Constants.colourPrimary,
          ),
          localAuthController.isAuthenticating.value == true
              ? SizedBox(
                  width: 25.w,
                  height: 25.w,
                  child: const CircularProgressIndicator(),
                )
              : GestureDetector(
                  onTap: () async {
                    print('tapped');
                    await localAuthController.authenticate();

                    ///TODO set navigation
                    if (localAuthController.isAuthenticated == true) {
                      Get.back();
                    }
                  },
                  child: Image.asset(
                    'assets/images/localAuthIcon.png',
                    width: 70.w,
                    height: 70.h,
                  ),
                ),
          Align(
            alignment: Alignment.centerLeft,
            child: TextButton(
              onPressed: () async {
                await localAuthController.cancelAuthentication();
                Get.back();
                //firebaseAuthController.signOutUser();
              },
              child: Text(
                'Cancel',
                style: Get.textTheme.titleMedium?.copyWith(
                  color: Constants.colourPrimary,
                ),
              ),
            ),
          ),
        ],
      ),
    );
    return MaterialApp(
      home: Scaffold(
        body: ListView(
          padding: const EdgeInsets.only(top: 30),
          children: <Widget>[
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                /* if (localAuthController.supportState.value ==
                    _SupportState.unknown)
                  const CircularProgressIndicator()
                else if (_supportState == _SupportState.supported)
                  const Text('This device is supported')
                else
                  const Text('This device is not supported'),
                const Divider(height: 100),*/
                /* Text('Can check biometrics: $_canCheckBiometrics\n'),
                ElevatedButton(
                  onPressed: _checkBiometrics,
                  child: const Text('Check biometrics'),
                ),
                const Divider(height: 100),
                Text('Available biometrics: $_availableBiometrics\n'),
                ElevatedButton(
                  onPressed: _getAvailableBiometrics,
                  child: const Text('Get available biometrics'),
                ),
                const Divider(height: 100),*/
                /*Text('Current State: $_authorized\n'),*/
                if (localAuthController.isAuthenticating.value == true)
                  ElevatedButton(
                    onPressed: localAuthController.cancelAuthentication,
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Text('Cancel Authentication'),
                        Icon(Icons.cancel),
                      ],
                    ),
                  )
                else
                  Column(
                    children: <Widget>[
                      ElevatedButton(
                        onPressed: localAuthController.authenticate,
                        child: const Row(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            Text('Authenticate'),
                            Icon(Icons.perm_device_information),
                          ],
                        ),
                      ),
                      /* ElevatedButton(
                        onPressed: _authenticateWithBiometrics,
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            Text(_isAuthenticating
                                ? 'Cancel'
                                : 'Authenticate: biometrics only'),
                            const Icon(Icons.fingerprint),
                          ],
                        ),
                      ),*/
                    ],
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
