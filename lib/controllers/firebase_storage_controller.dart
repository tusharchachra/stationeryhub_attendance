import 'dart:io' as io;

import 'package:camera/camera.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:stationeryhub_attendance/controllers/firebase_error_controller.dart';
import 'package:stationeryhub_attendance/models/pic_path_enum.dart';

class FirebaseStorageController extends GetxController {
  RxBool isLoading = false.obs;
  final FirebaseErrorController errorController = Get.find();
  //final FirebaseFirestoreController firestoreController = Get.find();

  Future<String?> uploadPicture(
      {required XFile? file, required PicPathEnum storagePath}) async {
    isLoading.value = true;
    String path = '';
    String? uploadPath;
    print('storagePath=$storagePath');
    if (file == null) {
      print('no file');
      return null;
    }
    if (storagePath == null) {
      return null;
    }
    path = storagePath.getPath();
    // UploadTask uploadTask;
    // Create a Reference to the file
    Reference ref = FirebaseStorage.instance
        .ref()
        .child('/$path')
        .child(DateTime.timestamp().toString());
    final metadata = SettableMetadata(
      contentType: 'image/jpeg',
      customMetadata: {'picked-file-path': file.path},
    );
    try {
      if (kIsWeb) {
        /*uploadTask = */ await ref.putData(await file.readAsBytes(), metadata);
      } else {
        /*uploadTask = */ await ref.putFile(io.File(file.path), metadata);
        uploadPath = await ref.getDownloadURL();
        print('Pic path=$uploadPath');
        /*await firestoreController.updateUser(
          user: firestoreController.registeredUser!.value!,
        );*/
      }
    } on FirebaseException catch (e) {
      // TODO
      errorController.getErrorMsg(e);
    }
    isLoading.value = false;
    return uploadPath;
    //return Future.value(uploadTask);
  }

  /*Future<UsersModel?> uploadIdCard(
      {required XFile fileFront, XFile? fileBack}) async {
    isLoading.value = true;
    String? frontPath;
    String? backPath;
    UsersModel? tempUserDetails = UsersModel();
    // UploadTask uploadTask;
    // Create a Reference to the file
    Reference ref = FirebaseStorage.instance
        .ref()
        .child('/idCard')
        .child(DateTime.timestamp().toString());
    //upload front side
    {
      final metadataFront = SettableMetadata(
        contentType: 'image/jpeg',
        customMetadata: {'picked-file-path': fileFront.path},
      );
      try {
        if (kIsWeb) {
          */ /*uploadTask = */ /* await ref.putData(
              await fileFront.readAsBytes(), metadataFront);
        } else {
          */ /*uploadTask = */ /* await ref.putFile(
              io.File(fileFront.path), metadataFront);
          tempUserDetails.idCardFrontPath = await ref.getDownloadURL();
          print('Id card Front path=$frontPath');
        }
      } on FirebaseException catch (e) {
        // TODO
        errorController.getErrorMsg(e);
      }
    }
    //upload back side
    if (fileBack != null) {
      final metadataBack = SettableMetadata(
        contentType: 'image/jpeg',
        customMetadata: {'picked-file-path': fileBack.path},
      );
      try {
        if (kIsWeb) {
          */ /*uploadTask = */ /* await ref.putData(
              await fileBack.readAsBytes(), metadataBack);
        } else {
          */ /*uploadTask = */ /* await ref.putFile(
              io.File(fileBack.path), metadataBack);
          tempUserDetails.idCardBackPath = await ref.getDownloadURL();
          print('ID card back path=$backPath');
        }
      } on FirebaseException catch (e) {
        // TODO
        errorController.getErrorMsg(e);
      }
    }

    isLoading.value = false;
    return tempUserDetails;
    //return Future.value(uploadTask);
  }*/
}
