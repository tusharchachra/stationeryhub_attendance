import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:stationeryhub_attendance/controllers/capture_image_screen_controller.dart';
import 'package:stationeryhub_attendance/controllers/face_controller.dart';
import 'package:stationeryhub_attendance/controllers/firebase_firestore_controller.dart';
import 'package:stationeryhub_attendance/scaffold/scaffold_dashboard.dart';

import '../components/gradient_progress_bar.dart';
import '../helpers/constants.dart';

class MarkAtt5 extends StatelessWidget {
  const MarkAtt5({super.key});

  @override
  Widget build(BuildContext context) {
    final captureImageScreenController =
        Get.put(CaptureImageScreenController());
    final faceController = Get.put(FaceController());
    final FirebaseFirestoreController firestoreController = Get.find();
    captureImageScreenController.cameraDirection.value = 1;
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
                        bottom: 69.h,
                        left: 0,
                        right: 0,
                        child: GestureDetector(
                          onTap: () async {
                            await captureImageScreenController.clickPicture();
                            if (captureImageScreenController
                                    .imageFilePath.value !=
                                '') {
                              faceController.assignValues(
                                  path: captureImageScreenController
                                      .imageFilePath.value);
                              await faceController.detectFace();
                              await faceController.processFace();
                              print(
                                  'faceController.embeddings=${faceController.embeddings}');
                              /* await firestoreController.updateUser(
                                  user: UsersModel(
                                      userId: 'CqXl46E3sFF5Il2qU5WI',
                                      embeddings:
                                          faceController.embeddings.value));*/
                            }
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
                      ),
                    ],
                  ),
      ),
    );
  }
}
