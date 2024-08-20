import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:stationeryhub_attendance/screens/screen_login_new.dart';

import '../screens/screen_admin_dashboard.dart';

class FirebaseAuthController extends GetxController {
  static FirebaseAuthController authControllerInstance = Get.find();
  late Rx<User?> firebaseUser;
  FirebaseAuth authInstance = FirebaseAuth.instance;

  String firebaseMessage = '';
  String verificationId = '111111';

  @override
  void onReady() {
    super.onReady();
    firebaseUser = Rx<User?>(authInstance.currentUser);
    firebaseUser.bindStream(authInstance.userChanges());
    ever(firebaseUser, _initialScreen);
  }

  _initialScreen(User? user) {
    if (user == null) {
      Get.offAll(() => ScreenLoginNew());
    } else {
      Get.offAll(() => AdminDashboardScreen());
    }
  }

  Future<String> signInPhone({
    /*required BuildContext context,*/
    required String phoneNum,
    required String otp,
    required Function onCodeSentAction,
  }) async {
    if (kDebugMode) {
      print('signing in');
    }
    try {
      await authInstance.verifyPhoneNumber(
        timeout: const Duration(seconds: 10),
        phoneNumber: '+91$phoneNum',
        verificationCompleted: (PhoneAuthCredential credential) async {
          //Android only - auto read sms
          if (GetPlatform.isAndroid) {
            await _signIn(credential: credential);
          }
        },
        verificationFailed: (FirebaseAuthException e) {
          firebaseMessage = e.toString();
        },
        codeSent: (String verId, int? resendToken) async {
          verificationId = verId;
          if (kDebugMode) {
            print('Verification code sent to $phoneNum');
          }
          onCodeSentAction();
          /* Navigator.of(context).pushReplacement(MaterialPageRoute(
              builder: (context) =>
                  OtpScreen(phoneNumber: phoneNum, onSubmit: () {})));*/
        },
        codeAutoRetrievalTimeout: (String verId) {},
      );
    } on FirebaseAuthException catch (e) {
      if (kDebugMode) {
        print('Error:${e.code}');
      }
      firebaseMessage = _getAuthErrorMsg(e);
    }

    return firebaseMessage;
  }

  Future _signIn({required AuthCredential credential}) async {
    UserCredential? userCredential;
    try {
      userCredential = await authInstance.signInWithCredential(credential);
      firebaseUser = Rx<User>(userCredential.user!);
      authInstance.currentUser!.reload();
    } on FirebaseAuthException {
      /* firebaseMessage = kErrorOtp;*/
      // print(e.code);
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

  String _getAuthErrorMsg(FirebaseAuthException e) {
    if (e.code == 'user-not-found') {
      return 'User not registered. Please sign up';
    } else if (e.code == 'internal-error') {
      return 'Something went wrong. Please try again after some time';
    } else if (e.code == 'invalid-argument') {
      return ('Invalid data');
    } else if (e.code == 'invalid-credential') {
      return 'Invalid credentials';
    } else if (e.code == 'unknown') {
      return 'Invalid credentials';
    } else if (e.code == 'wrong-password') {
      return ('Invalid email-password combination');
    } else if (e.code == 'email-already-in-use') {
      return ('User already exists. Please sign in');
    } else if (e.code == 'invalid-email') {
      return ('Invalid email');
    } else if (e.code == 'requires-recent-login') {
      return ('This operation is sensitive and requires recent authentication. Log in again before retrying this request.');
    } else {
      return 'Something went wrong. Please try again after some time';
    }
  }
}
