import 'package:flutter/material.dart';

class FormFieldPhoneNum extends StatefulWidget {
  const FormFieldPhoneNum({
    super.key,
    required this.phoneNumController,
    required this.validatorPhoneNum,
    required this.onChangedAction,
  });

  final TextEditingController phoneNumController;
  final String? Function(String?)? validatorPhoneNum;
  final Function onChangedAction;

  @override
  State<FormFieldPhoneNum> createState() => _FormFieldPhoneNumState();
}

class _FormFieldPhoneNumState extends State<FormFieldPhoneNum> {
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.phoneNumController,
      style:
          Theme.of(context).textTheme.bodyLarge!.copyWith(letterSpacing: 5.0),
      keyboardType: TextInputType.phone,
      autofocus: false,
      maxLength: 10,
      cursorColor: Colors.white,
      decoration: const InputDecoration()
          .applyDefaults(Theme.of(context).inputDecorationTheme)
          .copyWith(
            counterText: '',
            prefix: Text(
              '+91-',
              style: Theme.of(context)
                  .textTheme
                  .bodyLarge!
                  .copyWith(letterSpacing: 5.0),
            ),
            prefixIcon: const Icon(Icons.phone),
            prefixIconColor: Colors.white,
          ),
      validator: widget.validatorPhoneNum,
      onChanged: (value) {
        widget.onChangedAction(value);
      },
    );
  }
}
