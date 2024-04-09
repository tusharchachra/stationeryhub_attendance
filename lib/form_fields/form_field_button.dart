import 'package:flutter/material.dart';

import '../helpers/size_config.dart';

class FormFieldButton extends StatelessWidget {
  const FormFieldButton({
    super.key,
    required this.isPhoneNumValid,
    required this.width,
    required this.height,
    required this.buttonText,
    required this.onTapAction,
  });

  final bool isPhoneNumValid;
  final int width;
  final int height;
  final String buttonText;
  final void Function() onTapAction;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTapAction,
      child: Container(
        width: SizeConfig.getSize(width),
        height: SizeConfig.getSize(height),
        decoration: BoxDecoration(
            color: isPhoneNumValid ? Colors.white : Colors.black26,
            borderRadius: const BorderRadius.all(Radius.circular(40.0))),
        child: Center(
          child: Text(
            buttonText,
            style: isPhoneNumValid
                ? Theme.of(context)
                    .textTheme
                    .bodyMedium!
                    .copyWith(color: Colors.indigo)
                : Theme.of(context).textTheme.bodyMedium,
          ),
        ),
      ),
    );
  }
}
