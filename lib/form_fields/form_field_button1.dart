import 'package:flutter/material.dart';

class FormFieldButton1 extends StatelessWidget {
  const FormFieldButton1({
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
        onPressed: () => onTapAction,
        child: Text(
          buttonText,
        ),
      ),
    );
  }
}
