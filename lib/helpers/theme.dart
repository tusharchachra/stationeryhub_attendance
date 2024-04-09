import 'package:flutter/material.dart';
import 'package:stationeryhub_attendance/helpers/size_config.dart';

class ThemeCustom {
  static ThemeData get lightTheme {
    return ThemeData(
        scaffoldBackgroundColor: Colors.white70,
        useMaterial3: true,
        appBarTheme: AppBarTheme(
          titleTextStyle: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: SizeConfig.getSize(5),
              color: Colors.indigo),
          foregroundColor: Colors.white,
        ),
        progressIndicatorTheme: const ProgressIndicatorThemeData(
          color: Colors.indigo,
          circularTrackColor: Colors.white,
        ),
        iconTheme: const IconThemeData(color: Colors.indigo),
        textTheme: TextTheme(
          displayLarge: TextStyle(
            color: Colors.white,
            fontSize: SizeConfig.getSize(10),
            fontWeight: FontWeight.bold,
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
            fillColor: Colors.black38,
            filled: true,
            border: const OutlineInputBorder(
              borderRadius: BorderRadius.all(
                Radius.circular(40.0),
              ),
            ),
            focusedBorder: const OutlineInputBorder(
                borderSide: BorderSide(color: Colors.white),
                borderRadius: BorderRadius.all(Radius.circular(40.0))),
            contentPadding: const EdgeInsets.symmetric(horizontal: 20.0),
            errorStyle: TextStyle(
                height: 0.1,
                color: Colors.red[900],
                fontWeight: FontWeight.bold,
                fontSize: SizeConfig.getSize(3))));
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
