import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stationeryhub_attendance/services/otp_screen_controller.dart';

import 'otp_box.dart';

class FormFieldOtp extends StatelessWidget {
  const FormFieldOtp({super.key});

  static OtpScreenController otpController = Get.find();

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        /*SizedBox(
          width: 49.w,
          height: 46.h,
          child: TextField(
              enableInteractiveSelection: false,
              controller: otpController.otpDigitController1,
              focusNode: otpController.focusDigit1,
              showCursor: false,
              keyboardType: TextInputType.number,
              textAlign: TextAlign.center,
              maxLength: 1,
              style: Get.textTheme.displayMedium!,
              decoration: const InputDecoration()
                  .applyDefaults(Get.theme.inputDecorationTheme)
                  .copyWith(
                    counterText: '',
                    */ /*prefixIcon: const Icon(Icons.phone),*/ /*
                    */ /*prefixIconColor: Colors.white,*/ /*
                  ),
              onChanged: (str) {
                onChangedAction(str: str, focusNext: otpController.focusDigit2);
              }),
        ),
        SizedBox(
          width: 49.w,
          height: 46.h,
          child: TextField(
              enableInteractiveSelection: false,
              controller: otpController.otpDigitController2,
              focusNode: otpController.focusDigit2,
              showCursor: false,
              keyboardType: TextInputType.number,
              textAlign: TextAlign.center,
              maxLength: 1,
              style: Get.textTheme.displayMedium!,
              decoration: const InputDecoration()
                  .applyDefaults(Get.theme.inputDecorationTheme)
                  .copyWith(
                    counterText: '',
                    */ /*prefixIcon: const Icon(Icons.phone),*/ /*
                    */ /*prefixIconColor: Colors.white,*/ /*
                  ),
              onChanged: (str) {
                onChangedAction(
                    str: str,
                    focusNext: otpController.focusDigit3,
                    focusPrev: otpController.focusDigit1);
              }),
        ),
        SizedBox(
          width: 49.w,
          height: 46.h,
          child: TextField(
              enableInteractiveSelection: false,
              controller: otpController.otpDigitController3,
              focusNode: otpController.focusDigit3,
              showCursor: false,
              keyboardType: TextInputType.number,
              textAlign: TextAlign.center,
              maxLength: 1,
              style: Get.textTheme.displayMedium!,
              decoration: const InputDecoration()
                  .applyDefaults(Get.theme.inputDecorationTheme)
                  .copyWith(
                    counterText: '',
                    */ /*prefixIcon: const Icon(Icons.phone),*/ /*
                    */ /*prefixIconColor: Colors.white,*/ /*
                  ),
              onChanged: (str) {
                onChangedAction(
                    str: str,
                    focusNext: otpController.focusDigit4,
                    focusPrev: otpController.focusDigit2);
              }),
        ),*/
        OtpBox(
            focusNodePrevious: null,
            focusNodeCurrent: otpController.focusDigit1,
            focusNodeNext: otpController.focusDigit2,
            textController: otpController.otpDigitController1),
        OtpBox(
            focusNodePrevious: otpController.focusDigit1,
            focusNodeCurrent: otpController.focusDigit2,
            focusNodeNext: otpController.focusDigit3,
            textController: otpController.otpDigitController2),
        OtpBox(
            focusNodePrevious: otpController.focusDigit2,
            focusNodeCurrent: otpController.focusDigit3,
            focusNodeNext: otpController.focusDigit4,
            textController: otpController.otpDigitController3),
        /* OtpBox(
            focusNodePrevious: otpController.focusDigit3,
            focusNodeCurrent: otpController.focusDigit4,
            focusNodeNext: otpController.focusDigit5,
            textController: otpController.otpDigitController4),*/
        /*OtpBox(
            focusNodePrevious: otpController.focusDigit4,
            focusNodeCurrent: otpController.focusDigit5,
            focusNodeNext: otpController.focusDigit6,
            textController: otpController.otpDigitController5),*/
        /*OtpBox(
            focusNodePrevious: otpController.focusDigit5,
            focusNodeCurrent: otpController.focusDigit6,
            focusNodeNext: null,
            textController: otpController.otpDigitController6),*/
      ],
    );
  }

  void onChangedAction(
      {required String str, FocusNode? focusNext, FocusNode? focusPrev}) {
    if (str.length == 1) {
      Get.focusScope?.requestFocus(focusNext);
    } else if (str.isEmpty) {
      Get.focusScope?.requestFocus(focusPrev);
    }

    //if (widget.onTextChanged != null) widget.onTextChanged!();
  }
}
