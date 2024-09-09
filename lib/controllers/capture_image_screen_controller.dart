import 'package:camera/camera.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';

import '../main.dart';

class CaptureImageScreenController extends GetxController
    with GetSingleTickerProviderStateMixin {
  RxBool isCameraInitialized = false.obs;
  Rx<CameraController?> controller =
      CameraController(cameras[0], ResolutionPreset.max).obs;
  RxInt cameraDirection = 0.obs;

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
    controller.value =
        CameraController(cameras[cameraDirection.value], ResolutionPreset.max);
    controller.value?.initialize().then((_) {
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
    controller.value
        ?.setDescription(cameras[cameraDirection.value])
        .then((v) {});
    isCameraInitialized.value = true;
  }
}
