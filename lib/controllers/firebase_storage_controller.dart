import 'dart:io' as io;

import 'package:camera/camera.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:stationeryhub_attendance/controllers/firebase_error_controller.dart';

class FirebaseStorageController extends GetxController {
  RxBool isLoading = false.obs;
  final FirebaseErrorController errorController = Get.find();
  Future<UploadTask?> uploadProfilePic(XFile? file) async {
    isLoading.value = true;
    if (file == null) {
      print('no file');

      return null;
    }

    UploadTask uploadTask;

    // Create a Reference to the file
    Reference ref = FirebaseStorage.instance
        .ref()
        .child('/profilePic')
        .child(DateTime.timestamp().toString());

    final metadata = SettableMetadata(
      contentType: 'image/jpeg',
      customMetadata: {'picked-file-path': file.path},
    );

    try {
      if (kIsWeb) {
        uploadTask = ref.putData(await file.readAsBytes(), metadata);
      } else {
        uploadTask = ref.putFile(io.File(file.path), metadata);
      }
    } on Exception catch (e) {
      // TODO
    }
    isLoading.value = false;
    //return Future.value(uploadTask);
  }
}
