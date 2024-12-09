import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/painting.dart' as painting;
import 'package:get/get.dart';
import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';
import 'package:image/image.dart' as img;
import 'package:stationeryhub_attendance/face_detection_recognition/ML/recognition.dart';
import 'package:stationeryhub_attendance/models/users_model.dart';

import '../face_detection_recognition/ML/recognizer.dart';

class FaceController extends GetxController {
  InputImage? inputImage;
  File? image;
  FaceDetectorOptions options = FaceDetectorOptions(
    minFaceSize: 0.4,
    performanceMode: FaceDetectorMode.accurate,
  );
  FaceDetector? faceDetector;
  RxList<Face> faces = <Face>[].obs;
  //RxString embeddings = ''.obs;
  Rx<Rect> boundingBox = Rect.zero.obs;
  late Recognizer recognizer;

  RxBool isFaceDetected = false.obs;

  /*void assignValues({required String path}) {
    image = File(path);
  }*/

  Future<void> detectFace({required String path}) async {
    image = File(path);
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

  Future<String> processFace({required String path}) async {
    image = File(path);
    recognizer = Recognizer();
    // var imgUInt8List = await image!.readAsBytes();
    var imageDecoded =
        await painting.decodeImageFromList(image!.readAsBytesSync());
    /* decodeImageFromList(
      imgUInt8List,
      (result) => imageDecoded = result,
    );*/
    //print(imageDecoded);
    for (Face face in faces) {
      //Rect boundingBox = face.boundingBox;
      boundingBox.value = face.boundingBox;

      //print('boundingBox=${boundingBox.toString()}');

      num left = boundingBox.value.left < 0 ? 0 : boundingBox.value.left;
      num top = boundingBox.value.top < 0 ? 0 : boundingBox.value.top;
      num right = boundingBox.value.right > imageDecoded.width
          ? imageDecoded.width - 1
          : boundingBox.value.right;
      num bottom = boundingBox.value.bottom > imageDecoded.height
          ? imageDecoded.height - 1
          : boundingBox.value.bottom;
      num width = right - left;
      num height = bottom - top;
      final bytes = await image!.readAsBytes();
      img.Image? faceImg = img.decodeImage(bytes);
      img.Image? croppedFace = img.copyCrop(faceImg!,
          x: left.toInt(),
          y: top.toInt(),
          width: width.toInt(),
          height: height.toInt());
      /* final png = img.encodePng(croppedFace);
      Get.dialog(Dialog(
        child: Stack(children: [
          Image.memory(png),
        ]),
      ));*/

      //print('croppedFace.height=${croppedFace.height}');
      return recognizer.getEmbeddings(croppedFace);
      //Recognition recognition = recognizer.getEmbeddings(croppedFace, boundingBox);
      //embeddings.value = recognition.embeddings.join(',');
      //print('embeddings.value=${recognition.embeddings}');
      //print(recognition.distance);
    }
    return '';
  }

  Recognition recognize(
      {required List<UsersModel> users,
      required String currentEmbeddings,
      required Rect location}) {
    recognizer = Recognizer();
    List<List<double>> storedEmbeddings = [];
    List<double> currentEmbeddingsDouble = [];
    var tempCurrentEmbeddings = currentEmbeddings.split(',');
    for (var value in tempCurrentEmbeddings) {
      currentEmbeddingsDouble.add(double.parse(value));
    }
    Recognition recognition = recognizer.recognize(
        users: users,
        currentEmbeddings: currentEmbeddingsDouble,
        location: location);
    return recognition;
  }

  void resetData() {
    isFaceDetected(false);
    faces([]);
  }

  @override
  void onClose() {
    // TODO: implement onClose
    faceDetector?.close();
    super.onClose();
  }
}
