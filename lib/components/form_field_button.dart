import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/firebase_error_controller.dart';

class FormFieldButton extends StatelessWidget {
  static FirebaseErrorController errorController = Get.find();
  const FormFieldButton({
    super.key,
    required this.width,
    required this.height,
    required this.buttonText,
    required this.onTapAction,
    this.leadingIcon,
    this.buttonStyle,

    //required this.buttonDecoration,
  });

  final double width;
  final double height;
  final String buttonText;
  final Widget? leadingIcon;
  final void Function() onTapAction;
  final ButtonStyle? buttonStyle;
  //final BoxDecoration buttonDecoration;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height,
      child: FilledButton(
        style: buttonStyle != null
            ? buttonStyle
            : Get.theme.filledButtonTheme.style,
        onPressed: () {
          errorController.resetValues();
          /* if (errorController.isInternetConnected.value == false) {
            print(errorController.errorMsg);
          }*/
          onTapAction();
        },
        child: FittedBox(
          fit: BoxFit.contain,
          child: Row(
            children: [
              leadingIcon ?? Container(),
              SizedBox(width: 5),
              Text(
                buttonText,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
