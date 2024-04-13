import 'package:flutter/material.dart';

import '../helpers/size_config.dart';

class FormFieldButton extends StatelessWidget {
  const FormFieldButton({
    super.key,
    required this.width,
    required this.height,
    required this.buttonText,
    required this.onTapAction,
    required this.buttonDecoration,
    required this.textStyle,
  });

  final int width;
  final int height;
  final String buttonText;
  final void Function() onTapAction;
  final BoxDecoration buttonDecoration;
  final TextStyle? textStyle;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTapAction,
      child: Container(
        width: SizeConfig.getSize(width),
        height: SizeConfig.getSize(height),
        decoration: buttonDecoration,
        child: Center(
          child: Text(
            buttonText,
            style: textStyle,
          ),
        ),
      ),
    );
  }
}
