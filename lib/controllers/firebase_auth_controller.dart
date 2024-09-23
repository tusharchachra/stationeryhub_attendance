import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:stationeryhub_attendance/models/organizations_model.dart';
import 'package:stationeryhub_attendance/models/users_model.dart';

import '../screens/admin_dashboard_screen.dart';
import '../screens/login_screen.dart';
import '../screens/new_organization_screen.dart';
import 'firebase_error_controller.dart';
import 'firebase_firestore_controller.dart';
import 'otp_screen_controller.dart';

class FirebaseAuthController extends GetxController {
  static FirebaseErrorController errorController = Get.find();
  static FirebaseFirestoreController firestoreController = Get.find();

  static OtpScreenController otpController = Get.find();
  //static SharedPrefsController sharedPrefsController = Get.find();

  late Rx<User?> firebaseUser;
  Rx<PhoneAuthCredential>? credential;
  FirebaseAuth authInstance = FirebaseAuth.instance;
  RxBool isInternetConnected = false.obs;
  RxBool isSigningOut = false.obs;

  RxString _verId = ''.obs;

  String firebaseMessage = '';
  //String enteredOtp = '111111';

/*
  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    signOutUser();
  }
*/

  @override
  void onReady() async {
    super.onReady();
    firebaseUser = Rx<User?>(authInstance.currentUser);
    print('firebaseuser=$firebaseUser');
    firebaseUser.bindStream(authInstance.userChanges());
    ever(firebaseUser, _initialScreen);
    // _checkInternet();
  }

  _checkInternet() async {
    Rx<List<InternetAddress>> result = Rx([]);
    try {
      result = Rx<List<InternetAddress>>(
          await InternetAddress.lookup('firestore.googleapis.com'));
      if (result.value.isNotEmpty && result.value[0].rawAddress.isNotEmpty) {
        isInternetConnected.value = true;
      } else {
        isInternetConnected.value = false;
      }
    } on SocketException catch (_) {
      isInternetConnected.value = false;
    }
    ever(
      result,
      (callback) => {errorController.errorMsg.value = 'No Internet'},
    );
  }

  _initialScreen(User? user) async {
    if (user == null) {
      Get.offAll(() => LoginScreen());
    } else {
      firestoreController
          .registeredOrganization(await firestoreController.getOrganization());

      if (firestoreController.registeredOrganization.value?.id == null) {
        Get.offAll(() => NewOrganizationScreen());
      } else {
        await firestoreController.attachOrganizationListener();
        await firestoreController.attachUserListener();
        /*  Get.bottomSheet(LocalAuthScreen(),
            backgroundColor: Colors.white, isDismissible: false);*/
        Get.offAll(() => AdminDashboardScreen());
      }
    }
  }

  Future<String> signInPhone({
    /*required BuildContext context,*/
    required String phoneNum,
    required String smsCode,
    Function? onCodeSentAction,
    int? forceResend,
  }) async {
    if (kDebugMode) {
      print('signing in');
    }
    try {
      await authInstance.verifyPhoneNumber(
        phoneNumber: '+91$phoneNum',
        forceResendingToken: forceResend ?? 0,
        verificationCompleted: (PhoneAuthCredential credential) async {},
        verificationFailed: (FirebaseException e) {
          errorController.getErrorMsg(e);
        },
        codeSent: (String verId, int? resendToken) async {
          if (kDebugMode) {
            print('Verification code sent to $phoneNum');
          }
          _verId.value = verId;
          // Create a PhoneAuthCredential with the code
          credential = Rx<PhoneAuthCredential>(PhoneAuthProvider.credential(
              verificationId: verId, smsCode: smsCode));
          //print(credential.value);
        },
        codeAutoRetrievalTimeout: (String verId) {},
      );
    } on FirebaseException catch (e) {
      if (kDebugMode) {
        print('Error:${e.code}');
      }
      errorController.getErrorMsg(e);
    }

    return firebaseMessage;
  }

  Future signIn({AuthCredential? authCredential}) async {
    if (kDebugMode) {
      debugPrint('Signing in...');
    }
    UserCredential? userCredential;
    // Create a PhoneAuthCredential with the code
    credential = Rx<PhoneAuthCredential>(PhoneAuthProvider.credential(
        verificationId: _verId.value, smsCode: otpController.otp.value));
    print(credential);
    try {
      userCredential =
          await authInstance.signInWithCredential(credential!.value);
      firebaseUser = Rx<User>(userCredential.user!);
      authInstance.currentUser?.reload();
      firestoreController.registeredUser(await firestoreController.getUser(
          firebaseId: authInstance.currentUser?.phoneNumber));
    } on FirebaseException catch (e) {
      /* firebaseMessage = kErrorOtp;*/
      print(e.code);
      print(e.message);
      errorController.getErrorMsg(e);
    }

    if (userCredential != null) {
      return 'success';
    } else {
      return firebaseMessage;
    }
  }

  Future signOutUser() async {
    if (kDebugMode) {
      debugPrint('Signing out...');
    }
    isSigningOut.value = true;

    try {
      await authInstance.signOut();
      firestoreController.registeredUser(UsersModel());
      firestoreController.registeredOrganization(OrganizationModel());
    } on Exception catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
    isSigningOut.value = false;
  }
}
