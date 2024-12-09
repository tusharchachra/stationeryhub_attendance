import 'package:get/get.dart';
import 'package:stationeryhub_attendance/controllers/face_controller.dart';
import 'package:stationeryhub_attendance/controllers/firebase_firestore_controller.dart';
import 'package:stationeryhub_attendance/models/users_model.dart';

import '../face_detection_recognition/ML/recognition.dart';
import 'capture_image_screen_controller.dart';

class MarkAttendanceScreenController extends GetxController {
  RxBool isLoading = false.obs;
  Rx<UsersModel> recognizedUser = UsersModel().obs;
  RxBool isRecognitionCorrect = false.obs;

  @override
  void onReady() {
    // TODO: implement onReady
    super.onReady();
  }

  Future<void> markAttendance() async {
    isLoading(true);
    final CaptureImageScreenController captureImageScreenController =
        Get.find();
    final FirebaseFirestoreController firestoreController = Get.find();
    final FaceController faceController = Get.find();
    recognizedUser(UsersModel());
    isRecognitionCorrect(false);

    print('Marking attendance...');
    await captureImageScreenController.clickPicture();
    if (captureImageScreenController.imageFilePath.value != '') {
      await faceController.detectFace(
          path: captureImageScreenController.imageFilePath.value);
      //print(faceController.isFaceDetected);
      if (faceController.isFaceDetected.isTrue) {
        String embeddings = await faceController.processFace(
            path: captureImageScreenController.imageFilePath.value);
        // print(embeddings);
        Recognition recognition = faceController.recognize(
            users: firestoreController.userList,
            currentEmbeddings: embeddings,
            location: faceController.boundingBox.value);
        //print('recognition.distance=${recognition.distance}');
        if (recognition.distance < 0.9) {
          recognizedUser(firestoreController.userList
              .firstWhere((val) => val.userId == recognition.name));
          String name = recognizedUser.value.name!;
          print('recognizedUser.value.name=$name');
        } else {
          print('unknown');
        }
      }
    }
    isLoading(false);

    //recognizedUser(recognizedUser);
    //return recognizedUser;
  }
}
