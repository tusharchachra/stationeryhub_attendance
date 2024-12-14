import 'package:camera/camera.dart';
import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:stationeryhub_attendance/controllers/firebase_firestore_controller.dart';
import 'package:stationeryhub_attendance/controllers/login_screen_controller.dart';
import 'package:stationeryhub_attendance/controllers/utils.dart';
import 'package:stationeryhub_attendance/helpers/theme.dart';
import 'package:stationeryhub_attendance/screens/splash_screen.dart';
import 'package:stationeryhub_attendance/translations/languages.dart';

import 'controllers/firebase_auth_controller.dart';
import 'controllers/firebase_error_controller.dart';
import 'firebase_options.dart';

///TODO:perform setup steps for iOs for google_mlkit_face_detection using steps in pub.dev
late List<CameraDescription> cameras;
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
  await GetStorage.init();
  await FirebaseAppCheck.instance.activate(
    androidProvider: AndroidProvider.debug,
    appleProvider: AppleProvider.debug,
  );
  //SharedPrefsController sharedPrefsController = Get.find();
  //await sharedPrefsController.clearSharedPrefs();
  //await SharedPrefsServices.sharedPrefsInstance.clearSharedPrefs();
  cameras = await availableCameras();
  // await ScreenUtil.ensureScreenSize();
  initializeDateFormatting('en_US', null)
      .then((_) => runApp(const StationeryHubAttendance()));
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
    /* ScreenUtil.init(context,
        designSize: const Size(460, 932),
        minTextAdapt: true,
        splitScreenMode: true);*/
    /* return MaterialApp(
      title: 'Title',
      theme: ThemeCustom.lightTheme,
      home: HomePage(),
    );*/
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    return ScreenUtilInit(
      designSize: const Size(460, 932),
      minTextAdapt: true,
      splitScreenMode: true,
      // enableScaleText: () => true,
      // enableScaleWH: () => true,
      builder: (_, child) {
        Get.put(FirebaseFirestoreController());
        Get.put(FirebaseAuthController());
        Get.put(FirebaseErrorController());
        Get.put(LoginScreenController());

        return GetMaterialApp(
          debugShowCheckedModeBanner: false,
          translations: Languages(),
          supportedLocales: Languages().keys.keys.map((val) => Locale(val)),
          /*supportedLocales: const [
            Locale('en'),
            Locale('hi'),
          ],*/

          localizationsDelegates: const [
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
            // add other library integrated locals
          ],
          locale: Get.deviceLocale,
          fallbackLocale: Locale('en'),
          theme: ThemeCustom.lightTheme,
          home: SplashScreen(),
        );
      },
      //child: SplashScreen(),
    );
  }
}

/*class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    //Set the fit size (fill in the screen size of the device in the design)
    //If the design is based on the size of the 360*690(dp)
    ScreenUtil.init(
      context,
      designSize: Size(460, 932),
      splitScreenMode: true,
      minTextAdapt: true,
    );

    return SplashScreen();
  }
}*/
