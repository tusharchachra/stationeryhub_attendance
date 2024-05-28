import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';
import 'package:image/image.dart' as img;
import 'package:stationeryhub_attendance/scaffold/scaffold_home.dart';

import '../ML/Recognition.dart';
import '../ML/Recognizer.dart';
import '../services/face_detector_painter.dart';

class MarkAttendanceScreen extends StatefulWidget {
  const MarkAttendanceScreen({super.key});

  @override
  State<MarkAttendanceScreen> createState() => _MarkAttendanceScreenState();
}

class _MarkAttendanceScreenState extends State<MarkAttendanceScreen>
    with WidgetsBindingObserver {
  late List<CameraDescription> _cameras;
  int cameraIndex = 1;
  dynamic controller;
  bool isLoading = true;
  bool isBusy = false;
  late Size size;
  late List<Recognition> recognitions = [];
  dynamic _scanResults;
  CameraImage? frame;
  late FaceDetector faceDetector;
  late Recognizer recognizer;
  List<Face> faces = [];
  img.Image? image;
  bool register = false;
  TextEditingController nameController = TextEditingController();
  static var IOS_BYTES_OFFSET = 28;
  /*int cameraIndex = 1;
  bool isLoading = false;
  XFile? imageFile;
  InputImage? inputImage;
  FaceDetector faceDetector = FaceDetector(
      options: FaceDetectorOptions(
    enableLandmarks: true,
    enableClassification: true,
  ));

  final _orientations = {
    DeviceOrientation.portraitUp: 0,
    DeviceOrientation.landscapeLeft: 90,
    DeviceOrientation.portraitDown: 180,
    DeviceOrientation.landscapeRight: 270,
  };*/

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    //TODO initialize face detector
    var options =
        FaceDetectorOptions(performanceMode: FaceDetectorMode.accurate);
    faceDetector = FaceDetector(options: options);
    //TODO initialize face recognizer
    recognizer = Recognizer();
    initializeCamera();
  }

  initializeCamera() async {
    _cameras = await availableCameras();
    controller =
        CameraController(_cameras[cameraIndex], ResolutionPreset.medium,
            imageFormatGroup: Platform.isAndroid
                ? ImageFormatGroup.nv21 // for Android
                : ImageFormatGroup.bgra8888,
            enableAudio: false);
    await controller.initialize().then((_) {
      if (!mounted) {
        return;
      }
      controller.startImageStream((image) {
        if (!isBusy) {
          isBusy = true;
          frame = image;
          doFaceDetectionOnFrame();
        }
      });
    }).catchError((Object e) {
      if (e is CameraException) {
        switch (e.code) {
          case 'CameraAccessDenied':
            // Handle access errors here.
            break;
          default:
            // Handle other errors here.
            break;
        }
      }
    });
    setState(() {
      isLoading = false;
    });
  }

  doFaceDetectionOnFrame() async {
    print('dfd');
    InputImage? inputImage = getInputImage();
    faces = await faceDetector.processImage(inputImage!);
    print("fl=" + faces.length.toString());
    for (Face face in faces) {}
    performFaceRecognition(faces);
    setState(() {
      _scanResults = faces;
      isBusy = false;
    });
  }

  InputImage? getInputImage() {
    final camera = _cameras[cameraIndex];
    final sensorOrientation = camera.sensorOrientation;
    InputImageRotation? rotation;
    if (Platform.isIOS) {
      rotation = InputImageRotationValue.fromRawValue(sensorOrientation);
    } else if (Platform.isAndroid) {
      var rotationCompensation =
          _orientations[controller!.value.deviceOrientation];
      print(rotationCompensation);
      if (rotationCompensation == null) return null;
      if (camera.lensDirection == CameraLensDirection.front) {
        // front-facing
        rotationCompensation = (sensorOrientation + rotationCompensation) % 360;
        print(rotationCompensation);
      } else {
        // back-facing
        rotationCompensation =
            (sensorOrientation - rotationCompensation + 360) % 360;
      }
      rotation = InputImageRotationValue.fromRawValue(rotationCompensation);
    }
    if (rotation == null) return null;

    final format = InputImageFormatValue.fromRawValue(frame!.format.raw);
    /*  if (format == InputImageFormat.yuv_420_888) {
      image = _convertNV21(frame!);
    }*/
    print(format);
/*    if (format == null ||
        (Platform.isAndroid && format != InputImageFormat.nv21) ||
        (Platform.isIOS && format != InputImageFormat.bgra8888)) return null;*/

    //if (frame!.planes.length != 1) return null;
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

  final _orientations = {
    DeviceOrientation.portraitUp: 0,
    DeviceOrientation.landscapeLeft: 90,
    DeviceOrientation.portraitDown: 180,
    DeviceOrientation.landscapeRight: 270,
  };

  Widget buildResult() {
    if (_scanResults == null ||
        controller == null ||
        !controller.value.isInitialized) {
      return const Center(child: Text('Camera is not initialized'));
    }
    final Size imageSize = Size(
      controller.value.previewSize!.height,
      controller.value.previewSize!.width,
    );
    CustomPainter painter = FaceDetectorPainter(
        imageSize, _scanResults, _cameras[cameraIndex].lensDirection);
    return CustomPaint(
      painter: painter,
    );
  }

  performFaceRecognition(List<Face> faces) async {
    recognitions.clear();

    //TODO convert CameraImage to Image and rotate it so that our frame will be in a portrait
    image = Platform.isIOS
        ? _convertBGRA8888ToImage(frame!) as img.Image?
        : _convertNV21(frame!);
    image = img.copyRotate(image!,
        angle: _cameras[cameraIndex].lensDirection == CameraLensDirection.front
            ? 270
            : 90);

    for (Face face in faces) {
      Rect faceRect = face.boundingBox;
      //TODO crop face
      img.Image croppedFace = img.copyCrop(image!,
          x: faceRect.left.toInt(),
          y: faceRect.top.toInt(),
          width: faceRect.width.toInt(),
          height: faceRect.height.toInt());

      //TODO pass cropped face to face recognition model
      Recognition recognition = recognizer.recognize(croppedFace, faceRect);
      if (recognition.distance > 1.0) {
        recognition.name = "Unknown";
      }
      recognitions.add(recognition);

      //TODO show face registration dialogue
      if (register) {
        showFaceRegistrationDialogue(croppedFace, recognition);
        register = false;
      }
    }

    setState(() {
      isBusy = false;
      _scanResults = recognitions;
    });
  }

  static img.Image _convertBGRA8888ToImage(CameraImage cameraImage) {
    final plane = cameraImage.planes[0];

    return img.Image.fromBytes(
      width: cameraImage.width,
      height: cameraImage.height,
      bytes: plane.bytes.buffer,
      rowStride: plane.bytesPerRow,
      bytesOffset: IOS_BYTES_OFFSET,
      order: img.ChannelOrder.bgra,
    );
  }

  img.Image convertYUV420ToImage(CameraImage cameraImage) {
    final width = cameraImage.width;
    final height = cameraImage.height;

    final yRowStride = cameraImage.planes[0].bytesPerRow;
    final uvRowStride = cameraImage.planes[1].bytesPerRow;
    final uvPixelStride = cameraImage.planes[1].bytesPerPixel!;

    final image = img.Image(width: width, height: height);

    for (var w = 0; w < width; w++) {
      for (var h = 0; h < height; h++) {
        final uvIndex =
            uvPixelStride * (w / 2).floor() + uvRowStride * (h / 2).floor();
        final index = h * width + w;
        final yIndex = h * yRowStride + w;

        final y = cameraImage.planes[0].bytes[yIndex];
        final u = cameraImage.planes[1].bytes[uvIndex];
        final v = cameraImage.planes[2].bytes[uvIndex];

        image.data!.setPixelR(w, h, yuv2rgb(y, u, v)); //= yuv2rgb(y, u, v);
      }
    }
    return image;
  }

  static img.Image _convertNV21(CameraImage image) {
    final width = image.width.toInt();
    final height = image.height.toInt();

    Uint8List yuv420sp = image.planes[0].bytes;

    final outImg = img.Image(height: height, width: width);
    final int frameSize = width * height;

    for (int j = 0, yp = 0; j < height; j++) {
      int uvp = frameSize + (j >> 1) * width, u = 0, v = 0;
      for (int i = 0; i < width; i++, yp++) {
        int y = (0xff & yuv420sp[yp]) - 16;
        if (y < 0) y = 0;
        if ((i & 1) == 0) {
          v = (0xff & yuv420sp[uvp++]) - 128;
          u = (0xff & yuv420sp[uvp++]) - 128;
        }
        int y1192 = 1192 * y;
        int r = (y1192 + 1634 * v);
        int g = (y1192 - 833 * v - 400 * u);
        int b = (y1192 + 2066 * u);

        if (r < 0)
          r = 0;
        else if (r > 262143) r = 262143;
        if (g < 0)
          g = 0;
        else if (g > 262143) g = 262143;
        if (b < 0)
          b = 0;
        else if (b > 262143) b = 262143;

        // I don't know how these r, g, b values are defined, I'm just copying what you had bellow and
        // getting their 8-bit values.
        outImg.setPixelRgb(i, j, ((r << 6) & 0xff0000) >> 16,
            ((g >> 2) & 0xff00) >> 8, (b >> 10) & 0xff);
      }
    }
    return outImg;
  }

  int yuv2rgb(int y, int u, int v) {
    // Convert yuv pixel to rgb
    var r = (y + v * 1436 / 1024 - 179).round();
    var g = (y - u * 46549 / 131072 + 44 - v * 93604 / 131072 + 91).round();
    var b = (y + u * 1814 / 1024 - 227).round();

    // Clipping RGB values to be inside boundaries [ 0 , 255 ]
    r = r.clamp(0, 255);
    g = g.clamp(0, 255);
    b = b.clamp(0, 255);

    return 0xff000000 |
        ((b << 16) & 0xff0000) |
        ((g << 8) & 0xff00) |
        (r & 0xff);
  }

  showFaceRegistrationDialogue(img.Image croppedFace, Recognition recognition) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text("Face Registration", textAlign: TextAlign.center),
        alignment: Alignment.center,
        content: SizedBox(
          height: 340,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(
                height: 20,
              ),
              Image.memory(
                Uint8List.fromList(img.encodeBmp(croppedFace)),
                width: 200,
                height: 200,
              ),
              SizedBox(
                width: 200,
                child: TextField(
                    controller: nameController,
                    decoration: const InputDecoration(
                        fillColor: Colors.white,
                        filled: true,
                        hintText: "Enter Name")),
              ),
              const SizedBox(
                height: 10,
              ),
              ElevatedButton(
                  onPressed: () {
                    recognizer.registerFaceInDB(
                        nameController.text, recognition.embeddings);
                    nameController.text = "";
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                      content: Text("Face Registered"),
                    ));
                  },
                  child: const Text("Register"))
            ],
          ),
        ),
        contentPadding: EdgeInsets.zero,
      ),
    );
  }

  /*InputImage? _inputImageFromCameraImage(CameraImage image) {
    final camera = _cameras[cameraIndex];
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

    // get image format
    final format = InputImageFormatValue.fromRawValue(image.format.raw);
    // validate format depending on platform
    // only supported formats:
    // * nv21 for Android
    // * bgra8888 for iOS
    print('format=$format');
    if (format == null ||
        (Platform.isAndroid && format != InputImageFormat.nv21) ||
        (Platform.isIOS && format != InputImageFormat.bgra8888)) return null;

    // since format is constraint to nv21 or bgra8888, both only have one plane
    if (image.planes.length != 1) return null;
    final plane = image.planes.first;

    // compose InputImage using bytes
    return InputImage.fromBytes(
      bytes: plane.bytes,
      metadata: InputImageMetadata(
        size: Size(image.width.toDouble(), image.height.toDouble()),
        rotation: rotation, // used only in Android
        format: format, // used only in iOS
        bytesPerRow: plane.bytesPerRow, // used only in iOS
      ),
    );
  }*/

  @override
  void dispose() {
    controller?.dispose();
    faceDetector.close();
    super.dispose();
  }

  @override
  Future<void> didChangeAppLifecycleState(AppLifecycleState state) async {
    final CameraController? cameraController = controller;

    // App state changed before we got the chance to initialize.
    if (cameraController == null || !cameraController.value.isInitialized) {
      return;
    }

    if (state == AppLifecycleState.inactive) {
      cameraController.dispose();
    } else if (state == AppLifecycleState.resumed) {
      // _initializeCameraController(cameraController.description);
      await initializeCamera();
    }
  }

  @override
  Widget build(BuildContext context) {
    return ScaffoldHome(
      isLoading: isLoading,
      pageTitle: 'Mark Att',
      bodyWidget: isLoading
          ? Container()
          : Column(
              children: [
                CameraPreview(controller),
                IconButton(
                  onPressed: () async {
                    cameraIndex = cameraIndex == 1 ? 0 : 1;
                    await initializeCamera();
                  },
                  icon: Icon(Icons.cameraswitch),
                ),
                IconButton(
                  onPressed: () {
                    takePicture().then((XFile? file) async {
                      if (mounted) {
                        setState(() {
                          //imageFile = file;
                        });
                      }
                    });
                  },
                  icon: Icon(Icons.camera),
                ),
                IconButton(
                  icon: const Icon(
                    Icons.face_retouching_natural,
                    color: Colors.white,
                  ),
                  iconSize: 40,
                  color: Colors.black,
                  onPressed: () {
                    setState(() {
                      register = true;
                    });
                  },
                ),
                faces.isNotEmpty
                    ? Positioned(
                        top: 0.0,
                        left: 0.0,
                        width: size.width,
                        height: size.height,
                        child: buildResult(),
                      )
                    : Container()
              ],
            ),
    );
  }

  Future<XFile?> takePicture() async {
    final CameraController? cameraController = controller;
    if (cameraController == null || !cameraController.value.isInitialized) {
      print('Error: select a camera first.');
      return null;
    }

    if (cameraController.value.isTakingPicture) {
      // A capture is already pending, do nothing.
      return null;
    }

    try {
      final XFile file = await cameraController.takePicture();
      return file;
    } on CameraException catch (e) {
      print(e);
      return null;
    }
  }

  //---------------------------------Conversion to nv21-----
}
