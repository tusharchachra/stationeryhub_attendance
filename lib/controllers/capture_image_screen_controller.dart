import 'package:camera/camera.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';

import '../main.dart';

class CaptureImageScreenController extends GetxController
    with GetSingleTickerProviderStateMixin {
  RxBool isCameraInitialized = false.obs;
  CameraController? cameraController =
      CameraController(cameras[0], ResolutionPreset.max);
  RxInt cameraDirection = 0.obs;
  XFile? imageFile;
  late Future<void> initializeControllerFuture;

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
  }

  @override
  void onReady() {
    // TODO: implement onReady
    super.onReady();
    initializeCamera();
  }

  void initializeCamera() {
    if (kDebugMode) {
      debugPrint('initializing camera');
    }
    cameraController =
        CameraController(cameras[cameraDirection.value], ResolutionPreset.max);
    initializeControllerFuture = cameraController!.initialize().then((_) {
      isCameraInitialized.value = true;
      if (kDebugMode) {
        print('isCameraInitialized=$isCameraInitialized');
      }
      /* if (isClosed) {
        return;
      }*/
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
  }

  void switchCameraDirection() {
    isCameraInitialized.value = false;
    cameraDirection.value = cameraDirection.value == 0 ? 1 : 0;
    cameraController
        ?.setDescription(cameras[cameraDirection.value])
        .then((v) {});
    isCameraInitialized.value = true;
  }

  Future<void> clickPicture() async {
    //  final CameraController? cameraController = controller;
    if (cameraController == null || !cameraController!.value.isInitialized) {
      Get.showSnackbar(GetSnackBar(
        title: 'Error: select a camera first.',
      ));
      // return null;
    }

    if (cameraController!.value.isTakingPicture) {
      // A capture is already pending, do nothing.
      // return null;
      print('capturing');
    }

    try {
      //final XFile? file = await cameraController?.takePicture();
      //return file;

      imageFile = await cameraController?.takePicture();

      //print('file.path=${file.path}');
      // imageFile?.value = file;
      //print('imageFile.path=${imageFile?.path}');
      //print('imageFile${imageFile}');
    } on CameraException catch (e) {
      print(e);
      //return null;
    }
  }
}
