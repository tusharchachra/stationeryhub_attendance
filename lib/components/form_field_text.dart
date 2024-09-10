import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stationeryhub_attendance/helpers/constants.dart';

class FormFieldText extends StatelessWidget {
  const FormFieldText({
    super.key,
    this.hintText,
    this.labelText,
    this.prefixIcon,
    this.isMultiLine = false,
    this.textController,
    this.validator,
    this.onChangedAction,
  });

  final TextEditingController? textController;
  final String? hintText;
  final String? labelText;
  final Widget? prefixIcon;
  final bool isMultiLine;
  final String? Function(String?)? validator;
  final void Function(String?)? onChangedAction;

  @override
  Widget build(BuildContext context) {
    return Wrap(children: [
      Text(
        labelText ?? '',
        style: Get.textTheme.displayLarge,
      ),
      TextFormField(
        controller: textController,
        style: Get.textTheme.displayMedium!,
        keyboardType: TextInputType.name,
        autofocus: false,
        cursorColor: Constants.colourTextLight,
        maxLines: isMultiLine ? 3 : 1,
        minLines: 1,
        textCapitalization: TextCapitalization.words,
        textAlignVertical: TextAlignVertical.center,
        decoration: const InputDecoration()
            .applyDefaults(Get.theme.inputDecorationTheme)
            .copyWith(
              counterText: '',
              prefixIcon: prefixIcon,
              prefixIconColor: Constants.colourTextFieldIcon,
              hintText: hintText,
            ),
        validator: validator,
        onChanged: onChangedAction,
        cursorOpacityAnimates: true,
      ),
    ]);
  }
}
