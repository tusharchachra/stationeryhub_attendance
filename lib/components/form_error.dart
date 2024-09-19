import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:stationeryhub_attendance/controllers/form_error_controller.dart';

class FormError extends StatelessWidget {
  const FormError({super.key});

  @override
  Widget build(BuildContext context) {
    final FormErrorController formErrorController = Get.find();
    return Column(
      children: List.generate(formErrorController.errors.length,
          (index) => formErrorText(error: formErrorController.errors[index])),
    );
  }

  Widget formErrorText({required String error}) {
    return Row(
      children: [
        Icon(
          Icons.error_outline,
          color: Colors.red,
          size: 15.w,
        ),
        SizedBox(width: 5.h),
        Text(
          error,
          style: Get.textTheme.bodySmall?.copyWith(color: Colors.red),
        ),
      ],
    );
  }
}
