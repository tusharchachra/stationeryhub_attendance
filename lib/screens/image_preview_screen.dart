import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:photo_view/photo_view.dart';
import 'package:stationeryhub_attendance/scaffold/scaffold_dashboard.dart';

class ImagePreviewScreen extends StatelessWidget {
  const ImagePreviewScreen(
      {super.key, required this.imagePath, required this.imageTitle});
  final String imagePath;
  final String imageTitle;

  @override
  Widget build(BuildContext context) {
    //bool isNetworkImage = Uri.parse(imagePath).isAbsolute ? true : false;

    return ScaffoldDashboard(
      pageTitle: Text(
        imageTitle,
        style: Get.textTheme.displaySmall?.copyWith(color: Colors.white),
      ),
      bodyWidget: Align(
        alignment: Alignment.center,
        child: PhotoView(
          tightMode: true,
          imageProvider: CachedNetworkImageProvider(imagePath)
          //backgroundDecoration: BoxDecoration(color: Colors.transparent),
        ),
      ),
    );
  }
}
