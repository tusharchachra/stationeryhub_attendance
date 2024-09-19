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
import 'package:stationeryhub_attendance/screens/display_captured_image_screen.dart';

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
        () => /*captureImageScreenController.imageFile != null
            ? Image.file(File(captureImageScreenController.imageFile!.path))
            : */
            captureImageScreenController.isCameraInitialized.value == false
                ? GradientProgressBar(
                    size: Size(1.sw, 1.sh),
                  )
                : Stack(
                    children: [
                      SizedBox(
                        width: 1.sw,
                        height: 1.sh,
                        child: Transform.flip(
                          flipX: captureImageScreenController
                                      .cameraDirection.value ==
                                  1
                              ? true
                              : false,
                          child: FutureBuilder(
                              future: captureImageScreenController
                                  .initializeControllerFuture,
                              builder: (context, snapshot) {
                                if (snapshot.connectionState ==
                                    ConnectionState.done) {
                                  // If the Future is complete, display the preview.
                                  return CameraPreview(
                                      captureImageScreenController
                                          .cameraController!);
                                } else {
                                  // Otherwise, display a loading indicator.
                                  return Center(
                                    child: GradientProgressBar(
                                      size: Size(1.sw, 1.sh),
                                    ),
                                  );
                                }
                              }),
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
                      Positioned(
                        top: 95.h,
                        left: 0,
                        right: 0,
                        child: Center(
                          child: LineAnimationView(size: Size(300.w, 300.h)),
                        ),
                      ),
                      buildButtons(captureImageScreenController),
                    ],
                  ),
      ),
    );
  }

  Widget buildButtons(
      CaptureImageScreenController captureImageScreenController) {
    return Positioned(
      bottom: 69.h,
      left: 0,
      right: 0,
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
                  color: Constants.colourTextFieldIcon, shape: BoxShape.circle),
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
              // print(captureImageScreenController.imageFile);

              if (captureImageScreenController.imageFilePath.value != '') {
                Get.off(() => DisplayCapturedImageScreen());
              }
            },
            child: Container(
              width: 94.w,
              height: 94.h,
              padding: EdgeInsets.all(10.w),
              decoration: const BoxDecoration(
                  color: Constants.colourPrimary, shape: BoxShape.circle),
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
              captureImageScreenController.switchCameraDirection();
            },
            child: Container(
              width: 61.w,
              height: 61.h,
              // alignment: Alignment.centerRight,
              padding: EdgeInsets.all(15.w),
              decoration: const BoxDecoration(
                  color: Constants.colourTextFieldIcon, shape: BoxShape.circle),
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
    );
  }
}
