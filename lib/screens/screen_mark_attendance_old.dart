//to take click a picture

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

class MarkAttendanceScreen extends StatefulWidget {
  static const String id = 'TakePicture';

  const MarkAttendanceScreen({super.key});

  @override
  State<MarkAttendanceScreen> createState() => _MarkAttendanceScreen();
}

class _MarkAttendanceScreen extends State<MarkAttendanceScreen> {
  late CameraController _controller;
  Future<void>? _initializedCameraController;

  @override
  void initState() {
    super.initState();
    //ensurePlugins();
    initializeCameraController();
  }

  void initializeCameraController() async {
    final cameras = await availableCameras();
    _controller = CameraController(cameras[1], ResolutionPreset.low);
    _initializedCameraController = _controller.initialize();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Stationery Hub'),
      ),
      //FutureBuilder is used to wait until the cameraController is initialized.
      //Once intitialized, a preview(camera feed) is displayed
      body: Column(
        children: [
          Expanded(
            flex: 2,
            child: FutureBuilder<void>(
              future: _initializedCameraController,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  return CameraPreview(_controller);
                } else {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
              },
            ),
          ),
          Expanded(
            flex: 1,
            child: Column(
              children: [
                FloatingActionButton(
                  onPressed: () async {
                    try {
                      await _initializedCameraController;
                      final image = await _controller.takePicture();
                      print(image);
                      /*await Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => DisplayPictureScreen(
                          imagePath: image.path,
                          camera: cameras[0],
                        ),
                      ));*/
                    } catch (e) {
                      print(e);
                    }
                  },
                  child: const Icon(Icons.camera),
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text('Cancel'),
                )
              ],
            ),
          ),
        ],
      ),

      //when picture is clicked, the path of cache is tapped into and is
      // passed on to the DisplayScreen for confirmation
    );
  }
}
