import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:stationeryhub_attendance/components/border_painter.dart';
import 'package:stationeryhub_attendance/components/gradient_progress_bar.dart';
import 'package:stationeryhub_attendance/components/line_animation_view.dart';
import 'package:stationeryhub_attendance/controllers/capture_image_screen_controller.dart';
import 'package:stationeryhub_attendance/helpers/constants.dart';
import 'package:stationeryhub_attendance/scaffold/scaffold_dashboard.dart';

class CaptureImageScreen extends StatelessWidget {
  const CaptureImageScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final CaptureImageScreenController captureImageScreenController =
        Get.put(CaptureImageScreenController());

    return ScaffoldDashboard(
      isLoading: false,
      pageTitle: 'Click a picture',
      bodyWidget: Obx(
        () => captureImageScreenController.isCameraInitialized.value == false
            ? GradientProgressBar(
                child: Container(
                  width: 1.sw,
                  height: 1.sh,
                  color: Colors.black,
                ),
              )
            : Stack(
                children: [
                  SizedBox(
                    width: 1.sw,
                    height: 1.sh,
                    child: Transform.flip(
                      flipX:
                          captureImageScreenController.cameraDirection.value ==
                                  1
                              ? true
                              : false,
                      child: CameraPreview(
                          captureImageScreenController.cameraController.value!),
                    ),
                  ),
                  Positioned(
                    top: 70.h,
                    left: 0,
                    right: 0,
                    child: Center(
                      child: CustomPaint(
                        foregroundPainter: BorderPainter(),
                        child: Container(
                          width: 350.w,
                          height: 350.h,
                          color: Colors.transparent,
                        ),
                      ),
                    ),
                  ),
                  /* Positioned(
                      top: 76.h,
                      left: 0,
                      right: 0,
                      child: Center(
                        child: GradientProgressBar(
                          //period: Duration(milliseconds: 1000),
                          //shimmerDirection: ShimmerDirection.ttb,
                          baseCol: Colors.transparent,
                          highlightCol: Constants.colourTextLight,
                          child: ClipRRect(
                            borderRadius:
                                BorderRadius.all(Radius.circular(50.0.r)),
                            child: Container(
                              width: 344.w,
                              height: 344.h,
                              color: Constants.colourDateBoxBorder,
                            ),
                          ),
                        ),
                      )),*/
                  Positioned(
                      top: 95.h,
                      left: 0,
                      right: 0,
                      child: Center(
                        child: LineAnimationView(size: Size(300.w, 300.h)),
                      )),
                  Positioned(
                    bottom: 69.h,
                    left: 0, right: 0,
                    //top: 200,
                    //left: 168.w,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        GestureDetector(
                          onTap: () {
                            Get.back();
                          },
                          child: Container(
                            width: 61.w,
                            height: 61.h,
                            // alignment: Alignment.centerRight,
                            padding: EdgeInsets.all(15.w),
                            decoration: const BoxDecoration(
                                color: Constants.colourTextFieldIcon,
                                shape: BoxShape.circle),
                            child: const FittedBox(
                              fit: BoxFit.fill,
                              child: Icon(
                                Icons.close,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(width: 35.w),
                        GestureDetector(
                          onTap: () async {
                            await captureImageScreenController.clickPicture();
                            print(
                                captureImageScreenController.imageFile?.value);
                          },
                          child: Container(
                            width: 94.w,
                            height: 94.h,
                            padding: EdgeInsets.all(10.w),
                            decoration: const BoxDecoration(
                                color: Constants.colourPrimary,
                                shape: BoxShape.circle),
                            child: const FittedBox(
                              fit: BoxFit.fill,
                              child: Icon(
                                Icons.camera,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(width: 35.w),
                        GestureDetector(
                          onTap: () {
                            captureImageScreenController
                                .switchCameraDirection();
                          },
                          child: Container(
                            width: 61.w,
                            height: 61.h,
                            // alignment: Alignment.centerRight,
                            padding: EdgeInsets.all(15.w),
                            decoration: const BoxDecoration(
                                color: Constants.colourTextFieldIcon,
                                shape: BoxShape.circle),
                            child: const FittedBox(
                              fit: BoxFit.fill,
                              child: Icon(
                                Icons.cameraswitch_rounded,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
