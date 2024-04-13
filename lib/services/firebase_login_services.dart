import 'dart:async';
import 'dart:io' show File, Platform;

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class FirebaseLoginServices {
  FirebaseLoginServices._privateConstructor();

  static final FirebaseLoginServices firebaseInstance =
      FirebaseLoginServices._privateConstructor();
  FirebaseAuth auth = FirebaseAuth.instance;

  String firebaseMessage = '';
  late User user;
  String verificationId = '111111';

  Future checkUser(String phoneNum) async {
    try {
      //await FirebaseAuth.instance.signInWithCredential();
    } on Exception catch (e) {
      print('Error:${e.toString()}');
    }
  }

  Future<String> signInPhone({
    required BuildContext context,
    required String phoneNum,
    required String otp,
  }) async {
    if (kDebugMode) {
      print('signing in');
    }
    try {
      await FirebaseAuth.instance.verifyPhoneNumber(
        timeout: const Duration(seconds: 10),
        phoneNumber: '+91$phoneNum',
        verificationCompleted: (PhoneAuthCredential credential) async {
          //Android only - auto read sms
          if (Platform.isAndroid) {
            await signIn(credential: credential);
          }
        },
        verificationFailed: (FirebaseAuthException e) {
          firebaseMessage = e.toString();
        },
        codeSent: (String verId, int? resendToken) async {
          verificationId = verId;
        },
        codeAutoRetrievalTimeout: (String verId) {},
      );
    } on FirebaseAuthException catch (e) {
      if (kDebugMode) {
        print('Error:${e.code}');
      }
      firebaseMessage = getAuthErrorMsg(e);
    }

    return firebaseMessage;
  }

  Future signIn({required AuthCredential credential}) async {
    UserCredential? userCredential;
    try {
      userCredential = await auth.signInWithCredential(credential);
      user = userCredential.user!;
      FirebaseAuth.instance.currentUser!.reload();
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
      await FirebaseAuth.instance.signOut();
      // FirebaseAuth.instance.currentUser!.reload();
    } on Exception catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
  }

  String getAuthErrorMsg(FirebaseAuthException e) {
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
