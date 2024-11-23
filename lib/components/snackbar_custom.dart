import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get_navigation/src/snackbar/snackbar.dart';

class SnackBarCustom extends GetSnackBar {
  final Text msgText;

  const SnackBarCustom({
    super.key,
    required this.msgText,
  });

  @override
  // TODO: implement messageText
  Widget? get messageText => msgText;

  Widget build(BuildContext context) {
    return GetSnackBar(
      messageText: messageText,
      duration: const Duration(seconds: 2),
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.white,
      boxShadows: [
        BoxShadow(color: Colors.grey, blurRadius: 62.0.r),
      ],
      snackStyle: SnackStyle.FLOATING,
      borderRadius: 50.r,
      margin: EdgeInsets.all(10.w),
    );
  }
}
