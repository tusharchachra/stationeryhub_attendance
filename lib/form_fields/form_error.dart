import 'package:flutter/material.dart';

class FormError extends StatelessWidget {
  const FormError({
    Key? key,
    required this.errors,
    this.errorDisplayStyle,
  }) : super(key: key);

  final List<String> errors;
  final TextStyle? errorDisplayStyle;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: List.generate(
          errors.length, (index) => formErrorText(error: errors[index])),
    );
  }

  Widget formErrorText({required String error}) {
    return Row(
      children: [
        const Icon(
          Icons.error_outline,
          color: Colors.red,
        ),
        const SizedBox(
          width: 5,
        ),
        /*Text(
          error,
          style: kTextStyleError,
        ),*/
      ],
    );
  }
}
