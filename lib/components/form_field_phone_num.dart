import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
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
    this.border,
    this.fillColor,
    this.hintText,
    this.prefixIcon,
  });

  final FocusNode? focusNode;
  final String? labelText;
  final TextEditingController? phoneNumController;
  final String? Function(String?)? validatorPhoneNum;
  final void Function(String?)? onChangedAction;
  final InputBorder? border;
  final Color? fillColor;
  final String? hintText;
  final Widget? prefixIcon;

  @override
  Widget build(BuildContext context) {
    return Wrap(children: [
      Text(
        labelText ?? '',
        style: Get.textTheme.headlineMedium
            ?.copyWith(color: Constants.colourTextDark),
      ),
      SizedBox(height: 20.h),
      TextFormField(
        controller: phoneNumController,
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
                    .copyWith(color: Constants.colourTextLight),
              ),
              border: border,
              fillColor: fillColor,
              prefixIcon: prefixIcon,
              prefixIconColor: Constants.colourTextFieldIcon,
              hintText: hintText,
              hintStyle: Get.textTheme.headlineMedium
                  ?.copyWith(color: Constants.colourTextLight),
              contentPadding:
                  EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h),
            ),
        validator: validatorPhoneNum,
        onChanged: onChangedAction,
        cursorOpacityAnimates: true,
        onEditingComplete: () {
          focusNode?.unfocus(disposition: UnfocusDisposition.scope);
        },
        /* onTapOutside: (event) {
          focusNode?.unfocus(disposition: UnfocusDisposition.scope);
        },*/
      ),
    ]);
  }
}
