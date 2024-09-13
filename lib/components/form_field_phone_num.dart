import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stationeryhub_attendance/helpers/constants.dart';

class FormFieldPhoneNum extends StatelessWidget {
  const FormFieldPhoneNum({
    super.key,
    this.focusNode,
    this.labelText,
    this.phoneNumController,
    required this.validatorPhoneNum,
    required this.onChangedAction,
  });

  final FocusNode? focusNode;
  final String? labelText;
  final TextEditingController? phoneNumController;
  final String? Function(String?)? validatorPhoneNum;
  final void Function(String?)? onChangedAction;

  @override
  Widget build(BuildContext context) {
    return Wrap(children: [
      Text(
        labelText ?? '',
        style: Get.textTheme.headlineMedium
            ?.copyWith(color: Constants.colourTextDark),
      ),
      TextFormField(
        // controller: phoneNumController,
        focusNode: focusNode,
        style: Get.textTheme.headlineMedium
            ?.copyWith(color: Constants.colourTextMedium),
        keyboardType: TextInputType.phone,
        autofocus: false,
        maxLength: 10,
        cursorColor: Constants.colourTextLight,
        decoration: const InputDecoration()
            .applyDefaults(Get.theme.inputDecorationTheme)
            .copyWith(
              counterText: '',
              prefix: Text(
                '+91-',
                style: Get.textTheme.headlineMedium!
                    .copyWith(color: Constants.colourTextMedium),
              ),
              /*prefixIcon: const Icon(Icons.phone),*/
              /*prefixIconColor: Colors.white,*/
            ),
        validator: validatorPhoneNum,
        onChanged: onChangedAction,
        cursorOpacityAnimates: true,
        /* onTapOutside: (event) {
          focusNode?.unfocus(disposition: UnfocusDisposition.scope);
        },*/
      ),
    ]);
  }
}
