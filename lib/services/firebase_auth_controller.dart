import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:stationeryhub_attendance/screens/login_screen.dart';

import '../screens/screen_admin_dashboard.dart';
import 'firebase_error_controller.dart';
import 'otp_screen_controller.dart';

class FirebaseAuthController extends GetxController {
  static FirebaseAuthController authController = Get.find();
  static FirebaseErrorController errorController = Get.find();
  static OtpScreenController otpController = Get.find();

  late Rx<User?> firebaseUser;
  late Rx<PhoneAuthCredential> credential;
  FirebaseAuth authInstance = FirebaseAuth.instance;

  RxString _verId = ''.obs;

  String firebaseMessage = '';
  //String enteredOtp = '111111';

  @override
  void onReady() {
    super.onReady();
    firebaseUser = Rx<User?>(authInstance.currentUser);
    firebaseUser.bindStream(authInstance.userChanges());
    ever(firebaseUser, _initialScreen);
  }

  _initialScreen(User? user) {
    if (user == null) {
      Get.offAll(() => LoginScreen());
    } else {
      Get.offAll(() => AdminDashboardScreen());
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
    UserCredential? userCredential;
    // Create a PhoneAuthCredential with the code
    credential = Rx<PhoneAuthCredential>(PhoneAuthProvider.credential(
        verificationId: _verId.value, smsCode: otpController.otp.value));
    print(credential);
    try {
      userCredential =
          await authInstance.signInWithCredential(credential.value);
      firebaseUser = Rx<User>(userCredential.user!);
      authInstance.currentUser?.reload();
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
    try {
      await authInstance.signOut();
      // auth.currentUser!.reload();
    } on Exception catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
  }
}
