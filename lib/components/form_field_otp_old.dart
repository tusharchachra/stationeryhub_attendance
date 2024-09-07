/*
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stationeryhub_attendance/form_fields/otp_box.dart';
import 'package:stationeryhub_attendance/services/otp_screen_controller.dart';

class FormFieldOtpOld extends StatelessWidget {
  const FormFieldOtpOld({super.key});

  static OtpScreenController otpController = Get.find();

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        OtpBox(
          focusNodePrevious: null,
          focusNodeCurrent: otpController.focusDigit,
          focusNodeNext: otpController.focusDigit2,
          textController: otpController.otpDigitController,
        ),
        OtpBox(
            focusNodePrevious: otpController.focusDigit,
            focusNodeCurrent: otpController.focusDigit2,
            focusNodeNext: otpController.focusDigit3,
            textController: otpController.otpDigitController2),
        OtpBox(
            focusNodePrevious: otpController.focusDigit2,
            focusNodeCurrent: otpController.focusDigit3,
            focusNodeNext: otpController.focusDigit4,
            textController: otpController.otpDigitController3),
        OtpBox(
            focusNodePrevious: otpController.focusDigit3,
            focusNodeCurrent: otpController.focusDigit4,
            focusNodeNext: otpController.focusDigit5,
            textController: otpController.otpDigitController4),
        OtpBox(
            focusNodePrevious: otpController.focusDigit4,
            focusNodeCurrent: otpController.focusDigit5,
            focusNodeNext: otpController.focusDigit6,
            textController: otpController.otpDigitController5),
        OtpBox(
            focusNodePrevious: otpController.focusDigit5,
            focusNodeCurrent: otpController.focusDigit6,
            focusNodeNext: null,
            textController: otpController.otpDigitController6),
      ],
    );
  }
}
*/
