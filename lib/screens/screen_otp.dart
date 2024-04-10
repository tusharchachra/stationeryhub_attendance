import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:stationeryhub_attendance/form_fields/form_field_button.dart';

import '../form_fields/form_error.dart';
import '../form_fields/otpbox.dart';
import '../services/firebase_services.dart';

class OtpScreen extends StatefulWidget {
  final String phoneNumber;
  final Function onSubmit;

  const OtpScreen(
      {super.key, required this.phoneNumber, required this.onSubmit});

  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  final FocusNode _focusDigit1 = FocusNode();
  final FocusNode _focusDigit2 = FocusNode();
  final FocusNode _focusDigit3 = FocusNode();
  final FocusNode _focusDigit4 = FocusNode();
  final FocusNode _focusDigit5 = FocusNode();
  final FocusNode _focusDigit6 = FocusNode();
  List<String> errors = [];
  TextEditingController otpDigitController1 = TextEditingController();
  TextEditingController otpDigitController2 = TextEditingController();
  TextEditingController otpDigitController3 = TextEditingController();
  TextEditingController otpDigitController4 = TextEditingController();
  TextEditingController otpDigitController5 = TextEditingController();
  TextEditingController otpDigitController6 = TextEditingController();
  bool isFormValid = false;
  String otp = '';
  bool isLoading = false;
  String firebaseMessage = '';

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _focusDigit1.dispose();
    _focusDigit2.dispose();
    _focusDigit3.dispose();
    _focusDigit4.dispose();
  }

  @override
  void initState() {
    super.initState();
    login();
  }

  Future<void> login() async {
    otp = otpDigitController1.text.trim() +
        otpDigitController2.text.trim() +
        otpDigitController3.text.trim() +
        otpDigitController4.text.trim() +
        otpDigitController5.text.trim() +
        otpDigitController6.text.trim();
    firebaseMessage = await FirebaseService.firebaseInstance
        .signInPhone(phoneNum: widget.phoneNumber, otp: otp, context: context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // isLoading: isLoading,
      body: LayoutBuilder(
          builder: (BuildContext context, BoxConstraints viewportConstraints) {
        return SingleChildScrollView(
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minHeight: viewportConstraints.maxHeight,
            ),
            child: Padding(
              padding: const EdgeInsets.all(30.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text(
                    'Verify phone number',
                    /* style: kTextStyleTitle.copyWith(
                        fontSize: kTextStyleTitle.fontSize! * 2),*/
                  ),
                  Text(
                    'Check SMS messages. We\'ve sent you the pin',
                    /*  style: kTextStyleTitle.copyWith(
                        fontSize: kTextStyleTitle.fontSize! * kSizeFactor09),*/
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      OtpBox(
                        textController: otpDigitController1,
                        focusNodePrevious: null,
                        focusNodeCurrent: _focusDigit1,
                        focusNodeNext: _focusDigit2,
                        onTextChanged: () {
                          validateForm();
                        },
                      ),
                      OtpBox(
                        textController: otpDigitController2,
                        focusNodePrevious: _focusDigit1,
                        focusNodeCurrent: _focusDigit2,
                        focusNodeNext: _focusDigit3,
                        onTextChanged: () {
                          validateForm();
                        },
                      ),
                      OtpBox(
                        textController: otpDigitController3,
                        focusNodePrevious: _focusDigit2,
                        focusNodeCurrent: _focusDigit3,
                        focusNodeNext: _focusDigit4,
                        onTextChanged: () {
                          validateForm();
                        },
                      ),
                      OtpBox(
                        textController: otpDigitController4,
                        focusNodePrevious: _focusDigit3,
                        focusNodeCurrent: _focusDigit4,
                        focusNodeNext: _focusDigit5,
                        onTextChanged: () {
                          validateForm();
                        },
                      ),
                      OtpBox(
                        textController: otpDigitController5,
                        focusNodePrevious: _focusDigit4,
                        focusNodeCurrent: _focusDigit5,
                        focusNodeNext: _focusDigit6,
                        onTextChanged: () {
                          validateForm();
                        },
                      ),
                      OtpBox(
                        textController: otpDigitController6,
                        focusNodePrevious: _focusDigit5,
                        focusNodeCurrent: _focusDigit6,
                        focusNodeNext: null,
                        onTextChanged: () {
                          setState(() {
                            errors.clear();
                          });
                          validateForm();
                        },
                      ),
                    ],
                  ),
                  FormError(errors: errors),
                  Text(
                    'Didn\'t you receive the OTP? Resend OTP',
                    /*style: kTextStyleBody.copyWith(
                      fontSize: kTextStyleBody.fontSize! * kSizeFactor02
                    ),*/
                  ),
                  FormFieldButton(
                    /* buttonDecoration: isFormValid
                          ? null
                          : kDecorationButton.copyWith(color: kColourTextBody),*/
                    onTapAction: isFormValid
                        ? () async {
                            /*String funcMsg = '';
                              validateForm();
                              setState(() {
                                isLoading = true;
                              });
                              funcMsg = await FirebaseService.firebaseInstance
                                  .signIn(
                                      credential: PhoneAuthProvider.credential(
                                          verificationId: FirebaseService
                                              .firebaseInstance.verificationId,
                                          smsCode: otp));

                              if (funcMsg == 'success') {
                                var refDatabase = FirebaseDatabase.instance.ref(
                                    'retailer/${FirebaseAuth.instance.currentUser!.uid}');
                                DataSnapshot snapshot =
                                    await refDatabase.child('phoneNum').get();
                                if (!snapshot.exists) {
                                  if (!mounted) return;
                                  Navigator.of(context).pushAndRemoveUntil(
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              const StoreDetailsScreen()),
                                      (route) => false);
                                } else {
                                  if (!mounted) return;
                                  Navigator.of(context).pushAndRemoveUntil(
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              const HomeScreen()),
                                      (route) => false);
                                }
                              } else {
                                addError(error: funcMsg);
                              }

                              setState(() {
                                isLoading = false;
                              });*/
                          }
                        : () {},
                    buttonText: 'Verify',
                    isPhoneNumValid: true,
                    width: 30,
                    height: 10,
                  ),
                ],
              ),
            ),
          ),
        );
      }),
    );
  }

  void validateForm() {
    if (kDebugMode) {
      print('validating');
    }
    otp = otpDigitController1.text.trim() +
        otpDigitController2.text.trim() +
        otpDigitController3.text.trim() +
        otpDigitController4.text.trim() +
        otpDigitController5.text.trim() +
        otpDigitController6.text.trim();
    setState(() {
      if (otp.length < 6) {
        //  addError(error: kErrorOtp);
        isFormValid = false;
      } else {
        // removeError(error: kErrorOtp);
        otp;
        isFormValid = true;
      }
    });
  }

  void addError({required String error}) {
    if (!errors.contains(error)) {
      setState(() {
        errors.add(error);
      });
    }
  }

  void removeError({required String error}) {
    if (errors.contains(error)) {
      setState(() {
        errors.remove(error);
      });
    }
  }
}
