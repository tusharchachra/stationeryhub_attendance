import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class AdminDashboardBox extends StatelessWidget {
  const AdminDashboardBox({
    super.key,
    required this.colour,
    required this.title,
    required this.subTitle,
    this.supportingText,
  });

  final Color colour;
  final String title;
  final String subTitle;
  final String? supportingText;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 81.h,
      width: 0.5.sw,
      color: colour,
      child: Padding(
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
                  style: Get.textTheme.bodySmall,
                ),
                Text(
                  subTitle,
                  style: Get.textTheme.headlineLarge,
                ),
              ],
            ),
            if (supportingText != null)
              Expanded(
                child: Align(
                  alignment: Alignment.topRight,
                  child: Text(
                    supportingText!,
                    style: Get.textTheme.bodySmall,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
