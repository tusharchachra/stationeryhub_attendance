import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:stationeryhub_attendance/components/gradient_progress_bar.dart';

class AdminDashboardBox extends StatelessWidget {
  const AdminDashboardBox({
    super.key,
    required this.colour,
    required this.title,
    required this.subTitle,
    this.supportingText,
    this.showPlaceholder = false,
  });

  final Color colour;
  final String title;
  final String subTitle;
  final String? supportingText;
  final bool? showPlaceholder;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 4.5.h),
        child: Container(
          height: 80.h,
          // width: 198.w,
          decoration: BoxDecoration(
            color: colour,
            borderRadius: BorderRadius.circular(5.r),
          ),
          child: showPlaceholder! ? buildPlaceholder() : buildValues(),
        ),
      ),
    );
  }

  Widget buildValues() {
    return Padding(
      padding: EdgeInsets.fromLTRB(20.w, 10.h, 14.w, 10.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: Get.textTheme.bodySmall?.copyWith(color: Colors.white),
              ),
              Text(
                subTitle,
                style:
                    Get.textTheme.displayMedium?.copyWith(color: Colors.white),
              ),
            ],
          ),
          if (supportingText != null)
            Expanded(
              child: Align(
                alignment: Alignment.topRight,
                child: Text(
                  supportingText!,
                  style: Get.textTheme.bodySmall?.copyWith(color: Colors.white),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget buildPlaceholder() {
    return Padding(
      padding: EdgeInsets.all(15.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GradientProgressBar(
            size: Size(150.w, 15.h),
            baseCol: Colors.white60,
          ),
          SizedBox(height: 10),
          GradientProgressBar(
            size: Size(80.w, 10.h),
            baseCol: Colors.white60,
          ),
        ],
      ),
    );
  }
}
