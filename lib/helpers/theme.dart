import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:stationeryhub_attendance/helpers/constants.dart';
import 'package:stationeryhub_attendance/helpers/size_config.dart';

class ThemeCustom {
  static ThemeData get lightTheme {
    return ThemeData(
      scaffoldBackgroundColor: Colors.white,
      useMaterial3: true,
      fontFamily: GoogleFonts.poppins().fontFamily,
      appBarTheme: AppBarTheme(
        toolbarHeight: 71.h,
        systemOverlayStyle: const SystemUiOverlayStyle(
          statusBarColor: Constants.colourStatusBar,
        ),
        titleTextStyle: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: SizeConfig.getSize(5),
            color: Colors.indigo),
        foregroundColor: Colors.white,
      ),
      progressIndicatorTheme: const ProgressIndicatorThemeData(
        color: Constants.colourPrimary,
        circularTrackColor: Colors.transparent,
      ),
      iconTheme: const IconThemeData(color: Constants.colourPrimary),
      textTheme: TextTheme(
        displayLarge: TextStyle(
          //color: Constants.colourTextDark,
          fontSize: 25.sp,
          fontWeight: FontWeight.w500,
        ),
        displayMedium: TextStyle(
          //color: Constants.colourTextDark,
          fontSize: 20.sp,
          fontWeight: FontWeight.w400,
        ),
        displaySmall: TextStyle(
          //color: Constants.colourTextDark,
          fontSize: 16.sp,
          fontWeight: FontWeight.w400,
        ),
        headlineLarge: TextStyle(
          //color: Colors.white,
          fontSize: 14.sp,
          fontWeight: FontWeight.w500,
        ),
        headlineMedium: TextStyle(
          //color: Colors.white,
          fontSize: 14.sp,
          fontWeight: FontWeight.w400,
        ),
        titleLarge: TextStyle(
          // color: Constants.colourPrimary,
          fontSize: 12.sp,
          fontWeight: FontWeight.w500,
        ),
        titleMedium: TextStyle(
          //color: Colors.white,
          fontSize: 12.sp,
          fontWeight: FontWeight.w400,
        ),
        titleSmall: TextStyle(
          //color: Colors.white,
          fontSize: 8.sp,
          fontWeight: FontWeight.w500,
        ),
        bodySmall: TextStyle(
          fontSize: 10.sp,
          fontWeight: FontWeight.w400,
        ),
        bodyLarge: TextStyle(
          fontSize: 18.sp,
          fontWeight: FontWeight.w500,
        ),
        //-----------------------------------------------------

        bodyMedium: TextStyle(
          color: Colors.white,
          fontSize: 12.sp,
          fontWeight: FontWeight.w500,
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        fillColor: Colors.white,
        filled: true,
        border: OutlineInputBorder(
          borderSide: const BorderSide(color: Constants.colourTextLight),
          borderRadius: BorderRadius.all(
            Radius.circular(10.0.r),
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Constants.colourPrimary),
          borderRadius: BorderRadius.all(
            Radius.circular(10.0.r),
          ),
        ),
        contentPadding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h),
        errorStyle: TextStyle(
          height: 0.1.h,
          color: Constants.colourError,
          fontWeight: FontWeight.normal,
          fontSize: 10.sp,
        ),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: ButtonStyle(
            backgroundColor:
                const WidgetStatePropertyAll(Constants.colourPrimary),
            foregroundColor: const WidgetStatePropertyAll(Colors.white),
            padding: WidgetStatePropertyAll(
              EdgeInsets.symmetric(vertical: 12.7.h),
            ),
            maximumSize: WidgetStatePropertyAll(Size(384.w, 56.h)),
            shape: WidgetStatePropertyAll(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(50.r),
              ),
            ),
            textStyle: WidgetStatePropertyAll(
              TextStyle(
                color: Colors.white,
                fontSize: 14.sp,
                fontWeight: FontWeight.w600,
              ),
            )),
      ),
      datePickerTheme: DatePickerThemeData(
        //dayForegroundColor: WidgetStatePropertyAll(Constants.colourTextMedium),
        locale: Locale('en', 'IN'),
        dayOverlayColor: WidgetStatePropertyAll(Colors.transparent),
        dayBackgroundColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return Constants.colourPrimary;
          }
          return Colors.transparent;
        }),
        dayForegroundColor: WidgetStateProperty.resolveWith(
          (states) => states.contains(WidgetState.disabled)
              ? Constants.colourBorderMedium
              : states.contains(WidgetState.selected)
                  ? Colors.white
                  : Constants.colourTextDark,
        ),
        dayStyle: TextStyle(
            fontSize: Get.textTheme.displaySmall!.fontSize, inherit: true),
        dayShape: WidgetStatePropertyAll(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.r),
            side: BorderSide(color: Colors.transparent),
          ),
        ),
        todayBorder: BorderSide(color: Constants.colourPrimary),
        todayForegroundColor: WidgetStateProperty.resolveWith(
          (states) => states.contains(WidgetState.selected)
              ? Colors.white
              : Constants.colourPrimary,
        ),
        todayBackgroundColor: WidgetStateProperty.resolveWith(
          (states) => states.contains(WidgetState.selected)
              ? Constants.colourPrimary
              : Colors.transparent,
        ),
        weekdayStyle: Get.textTheme.displaySmall!.copyWith(
          color: Constants.colourTextDark,
          inherit: true,
        ),
        yearStyle: Get.textTheme.displaySmall!.copyWith(
          color: Constants.colourTextDark,
          inherit: true,
        ),
        yearBackgroundColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return Constants.colourPrimary;
          }
          return Colors.transparent;
        }),
        yearForegroundColor: WidgetStateProperty.resolveWith(
          (states) => states.contains(WidgetState.disabled)
              ? Constants.colourBorderMedium
              : states.contains(WidgetState.selected)
                  ? Colors.white
                  : Constants.colourTextDark,
        ),
      ),
    );
  }

  static ThemeData get darkTheme {
    return ThemeData(
        scaffoldBackgroundColor: Colors.black,
        useMaterial3: true,
        appBarTheme: AppBarTheme(
          titleTextStyle: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: SizeConfig.getSize(10),
              color: Colors.indigo),
          foregroundColor: Colors.white,
        ),
        progressIndicatorTheme: const ProgressIndicatorThemeData(
          color: Colors.indigo,
          circularTrackColor: Colors.black,
        ),
        iconTheme: const IconThemeData(color: Colors.indigo),
        inputDecorationTheme:
            const InputDecorationTheme(errorStyle: TextStyle(fontSize: 0)));
  }
}
