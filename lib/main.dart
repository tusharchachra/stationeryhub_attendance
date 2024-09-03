import 'package:camera/camera.dart';
import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:stationeryhub_attendance/controllers/utils.dart';
import 'package:stationeryhub_attendance/helpers/theme.dart';
import 'package:stationeryhub_attendance/screens/screen_splash.dart';

import 'firebase_options.dart';

///TODO:perform setup steps for iOs for google_mlkit_face_detection using steps in pub.dev
//late List<CameraDescription> cameras;

void main() async {
  LicenseRegistry.addLicense(() async* {
    final license = await rootBundle.loadString('google_fonts/OFL.txt');
    yield LicenseEntryWithLineBreaks(['google_fonts'], license);
  });
  const reCaptchaSiteKey = '6LdiirYpAAAAAFZ1pyLKhZEcZpp2w6x_PullHH5r';
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  /* .then((value) {
    return Get.put(FirebaseAuthController());
  });*/
  UtilsController utilsController = UtilsController.instance;
  await utilsController.registerControllers();
  await FirebaseAppCheck.instance.activate(
    androidProvider: AndroidProvider.debug,
    appleProvider: AppleProvider.debug,
  );
  //SharedPrefsController sharedPrefsController = Get.find();
  //await sharedPrefsController.clearSharedPrefs();
  //await SharedPrefsServices.sharedPrefsInstance.clearSharedPrefs();
  final cameras = await availableCameras();
  // await ScreenUtil.ensureScreenSize();
  runApp(const StationeryHubAttendance());
}

class StationeryHubAttendance extends StatelessWidget {
  const StationeryHubAttendance({super.key});

  /* @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return MaterialApp(
      theme: ThemeCustom.lightTheme,
      home: StreamBuilder<User?>(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (context, snapshot) {
            return ScreenSplash();
          }),
    );*/
  @override
  Widget build(BuildContext context) {
    // SizeConfig().init(context);
    /* ScreenUtil.init(context,
        designSize: const Size(460, 932),
        minTextAdapt: true,
        splitScreenMode: true);*/

    return ScreenUtilInit(
      designSize: const Size(460, 932),
      minTextAdapt: true,
      splitScreenMode: true,
      enableScaleText: () => true,
      enableScaleWH: () => true,
      builder: (_, child) {
        return GetMaterialApp(
          debugShowCheckedModeBanner: false,
          theme: ThemeCustom.lightTheme,
          home: child,
        );
      },
      child: SplashScreen(),
    );
  }
}

/*
class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    //Set the fit size (fill in the screen size of the device in the design)
    //If the design is based on the size of the 360*690(dp)

    return ScreenSplash();
  }
}
*/
