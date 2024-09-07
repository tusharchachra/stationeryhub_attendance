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

    //required this.buttonDecoration,
  });

  final double width;
  final double height;
  final String buttonText;
  final void Function() onTapAction;
  //final BoxDecoration buttonDecoration;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height,
      child: FilledButton(
        onPressed: () {
          errorController.resetValues();
          /* if (errorController.isInternetConnected.value == false) {
            print(errorController.errorMsg);
          }*/
          onTapAction();
        },
        child: FittedBox(
          fit: BoxFit.contain,
          child: Text(
            buttonText,
          ),
        ),
      ),
    );
  }
}
