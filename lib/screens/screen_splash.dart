import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../helpers/constants.dart';

class SplashScreen extends GetWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: colourPrimary,
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Flexible(
              child: Container(
                width: 624.w,
                height: 579.h,
                decoration: const BoxDecoration(
                    image: DecorationImage(
                        image: AssetImage('assets/images/map.png'),
                        fit: BoxFit.fitWidth)),
              ),
            ),
            const CircularProgressIndicator(
              color: Colors.white,
              backgroundColor: Colors.transparent,
            )
          ],
        ));
  }
}
