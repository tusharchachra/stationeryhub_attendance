import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stationeryhub_attendance/helpers/constants.dart';

class FormFieldPhoneNum extends StatelessWidget {
  const FormFieldPhoneNum({
    super.key,
    this.focusNode,
    this.phoneNumController,
    required this.validatorPhoneNum,
    required this.onChangedAction,
  });

  final FocusNode? focusNode;
  final TextEditingController? phoneNumController;
  final String? Function(String?)? validatorPhoneNum;
  final void Function(String?)? onChangedAction;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      // controller: phoneNumController,
      focusNode: focusNode,
      style: Get.textTheme.displayMedium!,
      keyboardType: TextInputType.phone,
      autofocus: false,
      maxLength: 10,
      cursorColor: colourTextLight,
      decoration: const InputDecoration()
          .applyDefaults(Theme.of(context).inputDecorationTheme)
          .copyWith(
            counterText: '',
            prefix: Text('+91-', style: Get.textTheme.displayMedium!),
            /*prefixIcon: const Icon(Icons.phone),*/
            /*prefixIconColor: Colors.white,*/
          ),
      validator: validatorPhoneNum,
      onChanged: onChangedAction,
    );
  }
}
