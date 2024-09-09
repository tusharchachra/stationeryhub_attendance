import 'package:camera/camera.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';

import '../main.dart';

class CaptureImageScreenController extends GetxController
    with GetSingleTickerProviderStateMixin {
  RxBool isCameraInitialized = false.obs;
  Rx<CameraController?> cameraController =
      CameraController(cameras[0], ResolutionPreset.max).obs;
  RxInt cameraDirection = 0.obs;
  Rx<XFile?>? imageFile;

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
    cameraController.value =
        CameraController(cameras[cameraDirection.value], ResolutionPreset.max);
    cameraController.value?.initialize().then((_) {
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
    cameraController.value
        ?.setDescription(cameras[cameraDirection.value])
        .then((v) {});
    isCameraInitialized.value = true;
  }

  Future<void> clickPicture() async {
    //  final CameraController? cameraController = controller;
    if (cameraController == null ||
        !cameraController.value!.value.isInitialized) {
      Get.showSnackbar(GetSnackBar(
        title: 'Error: select a camera first.',
      ));
      // return null;
    }

    if (cameraController.value!.value.isTakingPicture) {
      // A capture is already pending, do nothing.
      // return null;
      print('capturing');
    }

    try {
      final XFile file = await cameraController.value!.takePicture();
      //return file;

      print(file.path);
      imageFile?.value = file;
      print(imageFile?.value?.path);
    } on CameraException catch (e) {
      print(e);
      //return null;
    }
  }
}
