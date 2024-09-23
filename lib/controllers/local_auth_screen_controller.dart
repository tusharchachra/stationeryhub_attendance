import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:local_auth/local_auth.dart';
import 'package:local_auth_android/local_auth_android.dart';
import 'package:local_auth_darwin/local_auth_darwin.dart';

class LocalAuthScreenController extends GetxController {
  final LocalAuthentication localAuth = LocalAuthentication();
  bool isDeviceSupported = false;
  bool _canCheckBiometrics = false;
  List<BiometricType> _availableBiometrics = [];
  //String _authorized = 'Not Authorized';
  RxBool isAuthenticating = false.obs;
  bool isAuthenticated = false;
  RxString error = ''.obs;

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
  }

  @override
  void onReady() {
    // TODO: implement onReady
    super.onReady();
    localAuth.isDeviceSupported().then((bool isSupported) {
      isDeviceSupported = isSupported;
      loadData();
    });
  }

  loadData() async {
    if (isDeviceSupported) {
      await _checkBiometrics;
      await _getAvailableBiometrics();
    }
  }

  Future<void> _checkBiometrics() async {
    isAuthenticating.value = true;

    bool canCheckBiometrics = false;
    try {
      canCheckBiometrics = await localAuth.canCheckBiometrics;
    } on PlatformException catch (e) {
      canCheckBiometrics = false;
      print(e);
    }
    _canCheckBiometrics = canCheckBiometrics;
    isAuthenticating.value = false;
  }

  Future<void> _getAvailableBiometrics() async {
    isAuthenticating.value = true;

    late List<BiometricType> availableBiometrics;
    try {
      availableBiometrics = await localAuth.getAvailableBiometrics();
    } on PlatformException catch (e) {
      availableBiometrics = <BiometricType>[];
      print(e);
    }
    _availableBiometrics = availableBiometrics;
    isAuthenticating.value = false;
  }

  Future<bool> authenticate() async {
    isAuthenticating.value = true;
    try {
      //_authorized = 'Authenticating';
      if ((_canCheckBiometrics && _availableBiometrics.isNotEmpty) ||
          isDeviceSupported) {
        isAuthenticated = await localAuth.authenticate(
          localizedReason: ' ',
          authMessages: <AuthMessages>[
            AndroidAuthMessages(
              signInTitle: ' ',
              cancelButton: 'Cancel',
            ),
            IOSAuthMessages(
              cancelButton: 'Cancel',
            ),
          ],
          options: const AuthenticationOptions(
            stickyAuth: true,
            useErrorDialogs: false,
          ),
        );
      } else {
        print(
            '_canCheck=$_canCheckBiometrics\nbiometrics=$_availableBiometrics\nisSupported=$isDeviceSupported');
      }
    } on PlatformException catch (e) {
      print(e);
      error.value = 'Error - ${e.message}';
      //_authorized = 'Error - ${e.message}';
      return false;
    }
    isAuthenticating.value = false;
    // _authorized = authenticated ? 'Authorized' : 'Not Authorized';

    return isAuthenticated;
  }

  /* Future<void> _authenticateWithBiometrics() async {
      bool authenticated = false;
      try {
        isAuthenticating.value = true;
        _authorized = 'Authenticating';
        authenticated = await localAuth.authenticate(
          localizedReason:
              'Scan your fingerprint (or face or whatever) to authenticate',
          options: const AuthenticationOptions(
            stickyAuth: true,
            biometricOnly: true,
          ),
        );
        isAuthenticating.value = false;
        _authorized = 'Authenticating';
      } on PlatformException catch (e) {
        print(e);
        _authorized = 'Error - ${e.message}';
        return;
      }

      isAuthenticating.value = false;

      final String message = authenticated ? 'Authorized' : 'Not Authorized';

      _authorized = message;
    }*/
  Future<void> cancelAuthentication() async {
    await localAuth.stopAuthentication();
    isAuthenticating.value = false;
    isAuthenticated = false;
  }
}
