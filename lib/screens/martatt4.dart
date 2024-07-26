import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';

class MarkAtt4 extends StatefulWidget {
  const MarkAtt4({super.key});

  @override
  State<MarkAtt4> createState() => _MarkAtt4State();
}

class _MarkAtt4State extends State<MarkAtt4> {
  late List<CameraDescription> cameras;
  CameraController? controller;
  bool isInitialized = false;
  dynamic _scanResults;
  CameraImage? frame;
  late FaceDetector faceDetector;
  CameraLensDirection camDirec = CameraLensDirection.front;
  bool isBusy = false;
  final _orientations = {
    DeviceOrientation.portraitUp: 0,
    DeviceOrientation.landscapeLeft: 90,
    DeviceOrientation.portraitDown: 180,
    DeviceOrientation.landscapeRight: 270,
  };

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initializeCamera();
  }

  initializeCamera() async {
    cameras = await availableCameras();
    controller = CameraController(cameras[1], ResolutionPreset.low,
        imageFormatGroup: Platform.isAndroid
            ? ImageFormatGroup.nv21 // for Android
            : ImageFormatGroup.bgra8888,
        enableAudio: false);
    await controller!.initialize().then((_) {
      if (!mounted) {
        return;
      }
      controller!.startImageStream((image) {
        if (!isBusy) {
          // isBusy = true;
          frame = image;
          doFaceDetectionOnFrame();
        }
      });
    });
    setState(() {
      isInitialized = true;
    });
    var options = FaceDetectorOptions(
      performanceMode: FaceDetectorMode.fast,
      enableClassification: true,
      enableContours: true,
      enableLandmarks: true,
    );
    faceDetector = FaceDetector(options: options);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    controller!.dispose();
    super.dispose();
  }

  doFaceDetectionOnFrame() async {
    //TODO convert frame into InputImage format
    // print('dfd');
    InputImage? inputImage = getInputImage();
    //TODO pass InputImage to face detection model and detect faces
    List<Face> faces = await faceDetector.processImage(inputImage!);

    for (Face face in faces) {
      if (face.smilingProbability! >= 0.6) {
        //print(face.landmarks[FaceContourType.leftEye].toString());
        print("fl=" + faces.length.toString());
        print('smiling prob=${face.smilingProbability}');
        //dispose();
        //return;
        // performFaceRecognition(faces);
      } else {
        //print('not smiling');
      }
      setState(() {
        isBusy = false;
      });
    }

    //TODO perform face recognition on detected faces
    // performFaceRecognition(faces);
    // setState(() {
    //   _scanResults = faces;
    //   isBusy = false;
    // });
  }

  //TODO convert CameraImage to InputImage
  InputImage? getInputImage() {
    final camera =
        camDirec == CameraLensDirection.front ? cameras[1] : cameras[0];
    final sensorOrientation = camera.sensorOrientation;

    InputImageRotation? rotation;
    if (Platform.isIOS) {
      rotation = InputImageRotationValue.fromRawValue(sensorOrientation);
    } else if (Platform.isAndroid) {
      var rotationCompensation =
          _orientations[controller!.value.deviceOrientation];
      if (rotationCompensation == null) return null;
      if (camera.lensDirection == CameraLensDirection.front) {
        // front-facing
        rotationCompensation = (sensorOrientation + rotationCompensation) % 360;
      } else {
        // back-facing
        rotationCompensation =
            (sensorOrientation - rotationCompensation + 360) % 360;
      }
      rotation = InputImageRotationValue.fromRawValue(rotationCompensation);
    }
    if (rotation == null) return null;

    final format = InputImageFormatValue.fromRawValue(frame!.format.raw);
    if (format == null ||
        (Platform.isAndroid && format != InputImageFormat.nv21) ||
        (Platform.isIOS && format != InputImageFormat.bgra8888)) return null;

    if (frame!.planes.length != 1) return null;
    final plane = frame!.planes.first;

    return InputImage.fromBytes(
      bytes: plane.bytes,
      metadata: InputImageMetadata(
        size: Size(frame!.width.toDouble(), frame!.height.toDouble()),
        rotation: rotation,
        format: format,
        bytesPerRow: plane.bytesPerRow,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (!isInitialized) {
      return Container();
    }
    return MaterialApp(
      home: CameraPreview(controller!),
    );
  }
}
