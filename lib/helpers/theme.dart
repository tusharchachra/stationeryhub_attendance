import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
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
        titleTextStyle: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: SizeConfig.getSize(5),
            color: Colors.indigo),
        foregroundColor: Colors.white,
      ),
      progressIndicatorTheme: const ProgressIndicatorThemeData(
        color: Colors.white,
        circularTrackColor: Colors.transparent,
      ),
      iconTheme: const IconThemeData(color: colourPrimary),
      textTheme: TextTheme(
        displayLarge: TextStyle(
          color: colourTextDark,
          fontSize: 20.sp,
          fontWeight: FontWeight.w400,
        ),
        displayMedium: TextStyle(
          color: colourTextDark,
          fontSize: 14.sp,
          fontWeight: FontWeight.w400,
        ),
        bodyLarge: TextStyle(
          color: Colors.white,
          fontSize: SizeConfig.getSize(4),
          fontWeight: FontWeight.bold,
        ),
        bodyMedium: TextStyle(
          color: Colors.white,
          fontSize: SizeConfig.getSize(3),
          fontWeight: FontWeight.bold,
        ),
        bodySmall: TextStyle(
          color: Colors.white,
          fontSize: SizeConfig.getSize(3),
          fontWeight: FontWeight.normal,
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        fillColor: Colors.white,
        filled: true,
        border: OutlineInputBorder(
          borderSide: BorderSide(color: colourTextLight),
          borderRadius: BorderRadius.all(
            Radius.circular(5.0.r),
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: colourTextLight),
          borderRadius: BorderRadius.all(
            Radius.circular(5.0.r),
          ),
        ),
        contentPadding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h),
        errorStyle: TextStyle(
          height: 0.1,
          color: Colors.red[900],
          fontWeight: FontWeight.bold,
          fontSize: SizeConfig.getSize(3),
        ),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: ButtonStyle(
            backgroundColor: WidgetStatePropertyAll(colourPrimary),
            foregroundColor: WidgetStatePropertyAll(Colors.white),
            padding: WidgetStatePropertyAll(
              EdgeInsets.symmetric(vertical: 12.7.h),
            ),
            shape: WidgetStatePropertyAll(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(50.r),
              ),
            ),
            textStyle: WidgetStatePropertyAll(
              TextStyle(
                color: Colors.white,
                fontSize: 14.sp,
                fontWeight: FontWeight.w400,
              ),
            )),
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
