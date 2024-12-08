import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'gradient_progress_bar.dart';

class PictureCircle extends StatelessWidget {
  const PictureCircle({
    super.key,
    required this.height,
    required this.width,
    required this.imgPath,
    // required this.isNetworkPath,
    this.icon,
    this.iconSize,
    this.backgroundColor,
    this.onTap,
  });

  final double height;
  final double width;
  final String imgPath;
  // final bool isNetworkPath;
  final Icon? icon;
  final double? iconSize;
  final Color? backgroundColor;
  final Function? onTap;

  @override
  Widget build(BuildContext context) {
    bool isNetworkPath = Uri.parse(imgPath).isAbsolute ? true : false;
    return Container(
      width: width,
      height: height,
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: backgroundColor ?? Colors.transparent,
      ),
      child: imgPath == '' || imgPath == 'null'
          ? icon ??
              Icon(
                Icons.person,
                color: Colors.white,
                size: iconSize ?? width / 1.5,
              )
          : GestureDetector(
              onTap: () {
                /* Get.off(() => DisplayCapturedImageScreen());*/
                if (onTap != null) {
                  onTap!();
                }
              },
              child: isNetworkPath
                  ? CachedNetworkImage(
                      imageUrl: imgPath,
                      fit: BoxFit.fitWidth,
                      useOldImageOnUrlChange: true,
                      placeholder: (context, url) =>
                          GradientProgressBar(size: Size(34.w, 34.h)),
                    )
                  : Image.file(
                      File(imgPath),
                      fit: BoxFit.fitWidth,
                    ),
            ),
    );
  }
}
