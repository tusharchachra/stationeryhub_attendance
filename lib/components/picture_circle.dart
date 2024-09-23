import 'dart:io';

import 'package:flutter/material.dart';

class PictureCircle extends StatelessWidget {
  const PictureCircle({
    super.key,
    required this.height,
    required this.width,
    required this.imgPath,
    this.icon,
    this.backgroundColor,
    this.onTap,
  });

  final double height;
  final double width;
  final String imgPath;
  final Icon? icon;
  final Color? backgroundColor;
  final Function? onTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: backgroundColor ?? Colors.transparent,
      ),
      child: imgPath == ''
          ? icon ??
              Icon(
                Icons.person,
                color: Colors.white,
                size: width / 1.5,
              )
          : GestureDetector(
              onTap: () {
                /* Get.off(() => DisplayCapturedImageScreen());*/
                if (onTap != null) {
                  onTap!();
                }
              },
              child: Image.file(
                File(imgPath),
                fit: BoxFit.fitWidth,
              ),
            ),
    );
  }
}
