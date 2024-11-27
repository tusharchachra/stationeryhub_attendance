import 'dart:ui';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';
import 'package:stationeryhub_attendance/controllers/capture_image_screen_controller.dart';
import 'package:stationeryhub_attendance/scaffold/scaffold_dashboard.dart';
import 'package:stationeryhub_attendance/screens/mark_attendance_result_screen.dart';

import '../components/gradient_progress_bar.dart';
import '../controllers/admin_dashboard_screen_controller.dart';
import '../controllers/face_controller.dart';
import '../controllers/mark_attendance_screen_controller.dart';
import '../helpers/constants.dart';

class MarkAttendanceScreen extends StatelessWidget {
  const MarkAttendanceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final captureImageScreenController =
        Get.put(CaptureImageScreenController());

    //final FirebaseFirestoreController firestoreController = Get.find();
    captureImageScreenController.cameraDirection.value = 1;
    final faceController = Get.put(FaceController());
    final markAttendanceScreenController =
        Get.put(MarkAttendanceScreenController());
    final AdminDashboardScreenController adminDashboardScreenController =
        Get.find();
    return ScaffoldDashboard(
      pageTitle: Text(
        'Mark attendance',
        style: Get.textTheme.displaySmall?.copyWith(color: Colors.white),
      ),
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
                                        .cameraController!,
                                  );
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
                      markAttendanceScreenController.isLoading.isTrue
                          ? BackdropFilter(
                              filter:
                                  ImageFilter.blur(sigmaY: 10.0, sigmaX: 10.0),
                              child: Center(child: CircularProgressIndicator()))
                          : Positioned(
                              bottom: 69.h,
                              left: 0,
                              right: 0,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  GestureDetector(
                                    onTap: () async {
                                      /*captureImageScreenController
                                          .cameraController!
                                          .pausePreview();*/
                                      await markAttendanceScreenController
                                          .markAttendance(
                                              faceController: faceController,
                                              captureImageScreenController:
                                                  captureImageScreenController,
                                              adminDashboardScreenController:
                                                  adminDashboardScreenController);
                                      /* if (captureImageScreenController
                                          .cameraController!
                                          .value
                                          .isPreviewPaused)*/
                                      /*  captureImageScreenController
                                          .cameraController!
                                          .resumePreview();*/

                                      Get.dialog(
                                        MarkAttendanceResultScreen(),
                                        barrierDismissible: false,
                                      );
                                      /*if (faceController.isFaceDetected.isTrue) {
                                    await markAttendanceScreenController
                                        .markAttendance(
                                            faceController: faceController,
                                            captureImageScreenController:
                                                captureImageScreenController,
                                            adminDashboardScreenController:
                                                adminDashboardScreenController);
                                    if (markAttendanceScreenController
                                            .recognizedUser.value.userId !=
                                        null) {
                                      Get.off(MarkAttendanceResultScreen());
                                    }
                                  }*/
                                      /*  if (faceController.isFaceDetected.isFalse ||
                                      markAttendanceScreenController
                                              .recognizedUser.value.userId ==
                                          null) {
                                    Get.dialog(Dialog(
                                      child: Text(
                                        'No face detected. Try again\nYou may try taking a close-up picture',
                                        style: Get.textTheme.displaySmall!
                                            .copyWith(
                                                color:
                                                    Constants.colourTextMedium),
                                      ),
                                    ));
                               }   }*/
                                    },
                                    child: Container(
                                      width: 94.w,
                                      height: 94.h,
                                      padding: EdgeInsets.all(10.w),
                                      decoration: const BoxDecoration(
                                          color: Constants.colourPrimary,
                                          shape: BoxShape.circle),
                                      child: Icon(
                                        Icons.camera,
                                        color: Colors.white,
                                        size: 60.w,
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
                                  ),
                                ],
                              ),
                            ),
                    ],
                  ),
      ),
    );
  }
}

class FaceDetectorPainter extends CustomPainter {
  FaceDetectorPainter(this.absoluteImageSize, this.faces, this.camDire2);

  final Size absoluteImageSize;
  final List<Face> faces;
  CameraLensDirection camDire2;

  @override
  void paint(Canvas canvas, Size size) {
    final double scaleX = size.width / absoluteImageSize.width;
    final double scaleY = size.height / absoluteImageSize.height;

    final Paint paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0
      ..color = Colors.indigoAccent;

    for (Face face in faces) {
      canvas.drawRect(
        Rect.fromLTRB(
          camDire2 == CameraLensDirection.front
              ? (absoluteImageSize.width - face.boundingBox.right) * scaleX
              : face.boundingBox.left * scaleX,
          face.boundingBox.top * scaleY,
          camDire2 == CameraLensDirection.front
              ? (absoluteImageSize.width - face.boundingBox.left) * scaleX
              : face.boundingBox.right * scaleX,
          face.boundingBox.bottom * scaleY,
        ),
        paint,
      );

      // TextSpan span = TextSpan(
      //     style: const TextStyle(color: Colors.white, fontSize: 20),
      //     text: "${face.name}  ${face.distance.toStringAsFixed(2)}");
      // TextPainter tp = TextPainter(
      //     text: span,
      //     textAlign: TextAlign.left,
      //     textDirection: TextDirection.ltr);
      // tp.layout();
      // tp.paint(canvas, Offset(face.location.left*scaleX, face.location.top*scaleY));
    }
  }

  @override
  bool shouldRepaint(FaceDetectorPainter oldDelegate) {
    return true;
  }
}
