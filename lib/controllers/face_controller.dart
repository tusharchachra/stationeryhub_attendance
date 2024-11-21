import 'dart:ui';

import 'package:get/get.dart';
import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';

class FaceController extends GetxController {
  InputImage? inputImage;
  FaceDetectorOptions options = FaceDetectorOptions(
      minFaceSize: 0.4, performanceMode: FaceDetectorMode.accurate);
  late FaceDetector faceDetector;

  RxBool isFaceDetected = false.obs;

  Future<void> detectFace() async {
    faceDetector = FaceDetector(options: options);
    if (inputImage != null) {
      print('image captured');
    } else {
      print('inputImage is null');
    }
    final List<Face> faces = await faceDetector.processImage(inputImage!);
    for (Face face in faces) {
      final Rect boundingBox = face.boundingBox;
      print('rect=${boundingBox.toString()}');
    }
    if (faces.isNotEmpty) {
      isFaceDetected.value = true;
    }
  }

  @override
  void onClose() {
    // TODO: implement onClose
    faceDetector.close();
    super.onClose();
  }
}
