import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:stationeryhub_attendance/components/form_field_button.dart';

import '../scaffold/scaffold_dashboard.dart';
import 'capture_image_screen.dart';

class PicInfoScreen extends StatelessWidget {
  const PicInfoScreen({
    super.key,
    this.title,
    this.infoTile,
    this.infoBody,
    this.buttonTitle,
    this.icon,
    this.backgroundImagePath,
    this.displayForegroundWhileCapture,
  });

  final String? title;
  final String? infoTile;
  final String? infoBody;
  final String? buttonTitle;
  final Icon? icon;
  final String? backgroundImagePath;
  final bool? displayForegroundWhileCapture;

  @override
  Widget build(BuildContext context) {
    return ScaffoldDashboard(
      isLoading: false,
      pageTitle: Text(title ?? ''),
      bodyWidget: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Wrap(
            runAlignment: WrapAlignment.start,
            //alignment: WrapAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.fromLTRB(12.w, 25.h, 12.w, 12.h),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(right: 12.w),
                      child: icon ?? Container(),
                    ),
                    Text(
                      infoTile ?? '',
                      style: Get.textTheme.titleLarge,
                    )
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(39.w, 0, 12.w, 12.h),
                child: Text(
                  infoBody ?? '',
                  style: Get.textTheme.displayMedium,
                ),
              ),
            ],
          ),
          if (backgroundImagePath != null)
            Center(child: Image.asset(backgroundImagePath!)),
          Padding(
            padding: EdgeInsets.only(bottom: 48.h),
            child: FormFieldButton(
                width: 384.w,
                height: 56.h,
                buttonText: buttonTitle ?? '',
                onTapAction: () {
                  Get.off(() => CaptureImageScreen(
                        displayForeground: displayForegroundWhileCapture,
                      ));
                }),
          )
        ],
      ),
    );
  }
}
