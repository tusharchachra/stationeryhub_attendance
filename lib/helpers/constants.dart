import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class Constants {
  Constants._privateConstructor();

  static final Constants instance = Constants._privateConstructor();

  static const colourPrimary = Color(0xFF0055FD);
  //static const colourBackground = Color(0x000fffff);
  static final Color colourIconBackground =
      const Color(0xFF0055FD).withOpacity(0.15);

  static const colourTextDark = Color(0xff555555);
  static const colourTextMedium = Color(0xff5C5C5C);
  static const colourTextLight = Color(0xffA8A8A8);
  static const colourBorderLight = Color(0xffF0F0F0);
  static const colourBorderMedium = Color(0xffD9E1E7);
  static const colourBorderDark = Color(0xffA8A8A8);
//------------------
  static const colourOtpBoxBorder = Color(0xffB3ABC2);
  static const colourTextFieldIcon = Color(0xff939393);
  static const colourError = Colors.red;
  static const colourStatusBar = Color(0xff284EAD);
  static const colourProfilePicIconBackground = Color(0xffC1CFEE);
  static const colourScaffoldBackground = Color(0xffF8F8F8);
  static const colourDashboardBox1 = Color(0xff0FA4F8);
  static const colourDashboardBox2 = Color(0xff009950);
  static const colourDashboardBox3 = Color(0xffE40001);
  static const colourDashboardBox4 = Colors.deepOrange;
  static const colourDashboardBox5 = Colors.tealAccent;
  static const colourDateBoxBorder = Color(0xffEFEFEF);
  static const colourIdCardBackground = Color(0xffC6E6F9);

  static const otpResendTime = 5;
  static const snackbarDuration = 4;

  static final unselectedDateBoxDecoration = BoxDecoration(
    color: Colors.white,
    border: Border.all(color: colourDateBoxBorder),
    borderRadius: BorderRadius.all(
      Radius.circular(14.r),
    ),
  );

  static final selectedDateBoxDecoration = BoxDecoration(
    color: colourPrimary,
    border: Border.all(color: colourDateBoxBorder),
    borderRadius: BorderRadius.all(
      Radius.circular(14.r),
    ),
  );

  static final inactiveDateBoxDecoration = BoxDecoration(
    color: colourBorderMedium,
    border: Border.all(color: colourDateBoxBorder),
    borderRadius: BorderRadius.all(
      Radius.circular(14.r),
    ),
  );

  static final selectedYearBoxDecoration = BoxDecoration(
    color: colourPrimary,
    border: Border.all(color: colourDateBoxBorder),
    borderRadius: BorderRadius.all(
      Radius.circular(10.r),
    ),
  );

  static final unselectedYearBoxDecoration = BoxDecoration(
    color: Colors.white,
    border: Border.all(color: colourDateBoxBorder),
    borderRadius: BorderRadius.all(
      Radius.circular(10.r),
    ),
  );

  static final inactiveYearBoxDecoration = BoxDecoration(
    color: colourTextLight,
    border: Border.all(color: colourDateBoxBorder),
    borderRadius: BorderRadius.all(
      Radius.circular(10.r),
    ),
  );

  static final buttonStyleWhite = Get.theme.filledButtonTheme.style?.copyWith(
      foregroundColor: const WidgetStatePropertyAll(Constants.colourTextDark),
      backgroundColor: const WidgetStatePropertyAll(Colors.white),
      iconColor: const WidgetStatePropertyAll(colourTextDark),
      side: const WidgetStatePropertyAll(BorderSide(color: colourTextDark)));
}
