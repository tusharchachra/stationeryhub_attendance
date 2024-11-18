import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:stationeryhub_attendance/components/form_field_button.dart';
import 'package:stationeryhub_attendance/components/gradient_progress_bar.dart';
import 'package:stationeryhub_attendance/controllers/id_card_capture_controller.dart';
import 'package:stationeryhub_attendance/helpers/constants.dart';
import 'package:stationeryhub_attendance/scaffold/scaffold_dashboard.dart';

enum ScanDirection { front, back }

class UserIdCardUploadScreen extends StatelessWidget {
  UserIdCardUploadScreen({super.key});
  final IdCardCaptureController cardController = Get.find();
  @override
  Widget build(BuildContext context) {
    return ScaffoldDashboard(
      backgroundColour: Colors.white,
      isLoading: false,
      pageTitle: Text('Upload ID'),
      bodyWidget: SizedBox.expand(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            buildCardBox(direction: ScanDirection.front),
            buildCardBox(direction: ScanDirection.back),
            Wrap(
              runSpacing: 13.h,
              children: [
                /* FormFieldButton(
                  width: 384.w,
                  height: 56.h,
                  buttonText: 'Add more',
                  buttonStyle: Constants.buttonStyleWhite,
                  onTapAction: () {},
                ),*/
                FormFieldButton(
                  width: 384.w,
                  height: 56.h,
                  buttonText: 'Add documents',
                  onTapAction: () {
                    Get.back();
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Stack buildCardBox({required ScanDirection direction}) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        GestureDetector(
          onTap: () {
            direction == ScanDirection.front
                ? cardController.scanFront()
                : cardController.scanBack();
          },
          child: Obx(
            () => Container(
              width: 366.w,
              height: 247.h,
              decoration: BoxDecoration(
                color: Constants.colourBorderLight,
                borderRadius: BorderRadius.circular(10.r),
              ),
              child: Center(
                child: (direction == ScanDirection.front &&
                            cardController.isLoadingFront.value == true) ||
                        (direction == ScanDirection.back &&
                            cardController.isLoadingBack.value == true)
                    ? GradientProgressBar(size: Size(366.w, 247.h))
                    : (direction == ScanDirection.front &&
                                cardController.documentFront.isNotEmpty) ||
                            (direction == ScanDirection.back &&
                                cardController.documentBack.isNotEmpty)
                        ? Padding(
                            padding: EdgeInsets.symmetric(
                              horizontal: 20.w,
                              vertical: 20.h,
                            ),
                            child: Container(
                                clipBehavior: Clip.hardEdge,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10.r),
                                ),
                                foregroundDecoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10.r),
                                  border: Border.all(color: Colors.black),
                                ),
                                child: direction == ScanDirection.front
                                    ? Uri.parse(cardController.documentFront[0])
                                            .isAbsolute
                                        ? CachedNetworkImage(
                                            imageUrl:
                                                cardController.documentFront[0])
                                        : Image.file(File(
                                            cardController.documentFront[0]))
                                    : Uri.parse(cardController.documentBack[0])
                                            .isAbsolute
                                        ? CachedNetworkImage(
                                            imageUrl:
                                                cardController.documentBack[0])
                                        : Image.file(File(
                                            cardController.documentBack[0]))
                                /*child: Image.file(
                                File(direction == ScanDirection.front
                                    ? cardController.documentFront[0]
                                    : cardController.documentBack[0]),
                                fit: BoxFit.fill,
                              ),*/
                                ),
                          )
                        : Text(
                            direction == ScanDirection.front ? 'Front' : 'Back',
                            style: Get.textTheme.displaySmall
                                ?.copyWith(color: Constants.colourTextLight),
                          ),
              ),
            ),
          ),
        ),
        Positioned(
          right: -10,
          top: -10,
          child: Container(
            width: 32.w,
            height: 32.h,
            // alignment: Alignment.centerRight,
            padding: EdgeInsets.all(5.w),
            decoration: const BoxDecoration(
              color: Constants.colourPrimary,
              shape: BoxShape.circle,
            ),
            child: FittedBox(
              fit: BoxFit.fill,
              child: IconButton(
                icon: Icon(
                  Icons.delete,
                  size: 50.w,
                ),
                color: Colors.white,
                onPressed: () {
                  direction == ScanDirection.front
                      ? cardController.clearFrontScan()
                      : cardController.clearBackScan();
                },
              ),
            ),
          ),
        )
      ],
    );
  }
}
