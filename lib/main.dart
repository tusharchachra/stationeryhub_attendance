import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:stationeryhub_attendance/helpers/size_config.dart';
import 'package:stationeryhub_attendance/helpers/theme.dart';
import 'package:stationeryhub_attendance/screens/screen_login.dart';

import 'firebase_options.dart';

void main() async {
  const reCaptchaSiteKey = '6LdiirYpAAAAAFZ1pyLKhZEcZpp2w6x_PullHH5r';
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await FirebaseAppCheck.instance.activate(
      androidProvider: AndroidProvider.debug,
      appleProvider: AppleProvider.debug,
      webProvider: ReCaptchaV3Provider(reCaptchaSiteKey));
  runApp(const StationeryHubAttendance());
}

class StationeryHubAttendance extends StatelessWidget {
  const StationeryHubAttendance({super.key});

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return MaterialApp(
      theme: ThemeCustom.lightTheme,
      home: StreamBuilder<User?>(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (context, snapshot) {
            return LayoutBuilder(builder: (context, constraints) {
              return ScreenLogin();
            });
          }),
    );
  }
}
