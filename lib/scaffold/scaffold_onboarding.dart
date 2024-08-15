import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../helpers/constants.dart';

class ScaffoldOnboarding extends StatelessWidget {
  const ScaffoldOnboarding({
    super.key,
    required this.bodyWidget,
  });
  final Widget bodyWidget;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
          clipBehavior: Clip.none,
          alignment: Alignment.topCenter,
          children: [
            Container(
              width: 460.w,
              height: 379.h,
              decoration: BoxDecoration(
                color: colourPrimary,
                image: const DecorationImage(
                    image: AssetImage('assets/images/map.png'),
                    fit: BoxFit.fill),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(90.r),
                  bottomRight: Radius.circular(90.r),
                ),
              ),
            ),
            bodyWidget,
          ]),
    );
  }
}
