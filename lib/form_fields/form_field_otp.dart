import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:pinput/pinput.dart';
import 'package:stationeryhub_attendance/helpers/constants.dart';
import 'package:stationeryhub_attendance/services/otp_screen_controller.dart';

class FormFieldOtp extends StatelessWidget {
  const FormFieldOtp({super.key});

  static OtpScreenController otpController = Get.find();

  Widget build(BuildContext context) {
    final defaultPinTheme = PinTheme(
      width: 49.w,
      height: 46.h,
      textStyle: Get.textTheme.displayMedium,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(7.5.r),
        border: Border.all(color: colourOtpBoxBorder),
      ),
    );

    /// Optionally you can use form to validate the Pinput
    return Form(
      key: otpController.formKeyOtp,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Directionality(
            // Specify direction if desired
            textDirection: TextDirection.ltr,
            child: (Pinput(
              // You can pass your own SmsRetriever implementation based on any package
              // in this example we are using the SmartAuth
              //smsRetriever: smsRetriever,
              length: 6,
              showCursor: false,
              controller: otpController.otpDigitController.value,
              focusNode: otpController.focusDigit,
              defaultPinTheme: defaultPinTheme,
              separatorBuilder: (index) => SizedBox(width: 3.w),
              validator: (s) {
                /*return value!.length < 6 ? null : 'Incorrect OTP';*/
                otpController.validateForm(s);
                return otpController.error.value == ''
                    ? null
                    : otpController.error.value;
              },
              errorText: otpController.error.value,
              hapticFeedbackType: HapticFeedbackType.lightImpact,
              /*validator: (s) {
                    return otpController.validateForm(s);
                  },*/
              onCompleted: (pin) {
                otpController.otp = RxString(pin);
                debugPrint('onCompleted: $pin');
              },
              onChanged: (value) {
                debugPrint('onChanged: $value');
              },
              /*cursor: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Container(
                    margin: const EdgeInsets.only(bottom: 9),
                    width: 22,
                    height: 1,
                    color: focusedBorderColor,
                  ),
                ],
              ),*/
              focusedPinTheme: defaultPinTheme.copyWith(
                decoration: defaultPinTheme.decoration!.copyWith(
                  border: Border.all(color: colourPrimary),
                ),
              ),
              /* submittedPinTheme: defaultPinTheme.copyWith(
                decoration: defaultPinTheme.decoration!.copyWith(
                  color: fillColor,
                  borderRadius: BorderRadius.circular(19),
                  border: Border.all(color: focusedBorderColor),
                ),
              ),*/
              errorPinTheme: defaultPinTheme.copyBorderWith(
                border: Border.all(color: colourError),
              ),
              errorTextStyle:
                  Get.textTheme.displayMedium?.copyWith(color: colourError),
            )),
          ),
          /*TextButton(
            onPressed: () {
              otpController.focusDigit1.unfocus();
              otpController.formKeyOtp.currentState!.validate();
            },
            child: const Text('Validate'),
          ),*/
        ],
      ),
    );
  }
}
