import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

class FirebaseErrorController extends GetxController {
  RxString errorMsg = ''.obs;

  void resetValues() {
    errorMsg.value = '';
    print('errorMsg reset = ${errorMsg.value}');
  }

  String getErrorMsg(FirebaseException e) {
    if (e.code == 'user-not-found') {
      errorMsg.value = 'User not registered. Please sign up';
    } else if (e.code == 'internal-error') {
      errorMsg.value = 'Something went wrong. Please try again after some time';
    } else if (e.code == 'invalid-argument') {
      errorMsg.value = ('Invalid data');
    } else if (e.code == 'invalid-credential') {
      errorMsg.value = 'Invalid credentials';
    } else if (e.code == 'unknown') {
      errorMsg.value = 'Invalid credentials';
    } else if (e.code == 'wrong-password') {
      errorMsg.value = ('Invalid email-password combination');
    } else if (e.code == 'email-already-in-use') {
      errorMsg.value = ('User already exists. Please sign in');
    } else if (e.code == 'invalid-email') {
      errorMsg.value = ('Invalid email');
    } else if (e.code == 'requires-recent-login') {
      errorMsg.value =
          ('This operation is sensitive and requires recent authentication. Log in again before retrying this request.');
    } else if (e.code == 'unavailable') {
      errorMsg.value =
          'Unable to reach the server. Please check your internet connectivity and retry after a while.';
    } else if (e.code == 'invalid-verification-code') {
      errorMsg.value = 'Invalid OTP';
    } else {
      errorMsg.value = 'Something went wrong. Please retry after a while.';
    }
    print(errorMsg.value);
    return errorMsg.value;
  }
}
