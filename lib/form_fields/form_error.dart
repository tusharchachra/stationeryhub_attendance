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
    return const Row(
      children: [
        Icon(
          Icons.error_outline,
          color: Colors.red,
        ),
        SizedBox(
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
