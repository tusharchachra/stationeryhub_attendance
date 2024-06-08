import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

class Markatt2 extends StatefulWidget {
  const Markatt2({super.key});

  @override
  State<Markatt2> createState() => _Markatt2State();
}

class _Markatt2State extends State<Markatt2> {
  late List<CameraDescription> cameras;
  bool isLoading = true;
  late CameraController controller;

  @override
  void initState() {
    // TODO: implement initState

    super.initState();
    initializeCamera();
  }

  Future initializeCamera() async {
    cameras = await availableCameras();
    controller = CameraController(cameras[1], ResolutionPreset.medium);
    await controller.initialize().then((_) {
      if (!mounted) {
        return;
      }
      setState(() {});
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

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return CircularProgressIndicator();
    }
    return MaterialApp(
      home: CameraPreview(controller),
    );
  }
}
