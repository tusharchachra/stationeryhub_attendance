import 'dart:io';
import 'dart:ui';

import 'package:flutter/painting.dart' as painting;
import 'package:get/get.dart';
import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';
import 'package:image/image.dart' as img;

import '../face_detection_recognition/ML/recognition.dart';
import '../face_detection_recognition/ML/recognizer.dart';

class FaceController extends GetxController {
  InputImage? inputImage;
  File? image;
  FaceDetectorOptions options = FaceDetectorOptions(
      minFaceSize: 0.4, performanceMode: FaceDetectorMode.accurate);
  FaceDetector? faceDetector;
  RxList<Face> faces = <Face>[].obs;
  RxString embeddings = ''.obs;

  late Recognizer recognizer;

  RxBool isFaceDetected = false.obs;

  void assignValues({required String path}) {
    image = File(path);
  }

  Future<void> detectFace() async {
    inputImage = InputImage.fromFile(image!);
    faceDetector = FaceDetector(options: options);
    if (inputImage != null) {
      print('image captured');
    } else {
      print('inputImage is null');
    }
    faces.value = await faceDetector!.processImage(inputImage!);
    faces.refresh();
    if (faces.isNotEmpty) {
      isFaceDetected.value = true;
    }
  }

  Future<void> processFace() async {
    recognizer = Recognizer();
    // var imgUInt8List = await image!.readAsBytes();
    var imageDecoded =
        await painting.decodeImageFromList(image!.readAsBytesSync());
    /* decodeImageFromList(
      imgUInt8List,
      (result) => imageDecoded = result,
    );*/
    print(imageDecoded);
    for (Face face in faces) {
      final Rect boundingBox = face.boundingBox;
      print('boundingBox=${boundingBox.toString()}');

      num left = boundingBox.left < 0 ? 0 : boundingBox.left;
      num top = boundingBox.top < 0 ? 0 : boundingBox.top;
      num right = boundingBox.right > imageDecoded.width
          ? imageDecoded.width - 1
          : boundingBox.right;
      num bottom = boundingBox.bottom > imageDecoded.height
          ? imageDecoded.height - 1
          : boundingBox.bottom;
      num width = right - left;
      num height = bottom - top;
      final bytes = await image!.readAsBytes();
      img.Image? faceImg = img.decodeImage(bytes);
      img.Image? croppedFace = img.copyCrop(faceImg!,
          x: left.toInt(),
          y: top.toInt(),
          width: width.toInt(),
          height: height.toInt());
      print('croppedFace.height=${croppedFace.height}');
      Recognition recognition = recognizer.recognize(croppedFace, boundingBox);
      embeddings.value = recognition.embeddings.join(',');
      print('embeddings.value=${recognition.embeddings}');
    }
  }

  @override
  void onClose() {
    // TODO: implement onClose
    faceDetector?.close();
    super.onClose();
  }
}
