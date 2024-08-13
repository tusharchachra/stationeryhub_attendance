import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:stationeryhub_attendance/services/firebase_services.dart';

import '../albums/album_users.dart';

class FirebaseServicesController extends GetxController {
  FirebaseServices _firebaseFirestoreServices;
  RxList<AlbumUsers> users;
  FirebaseServicesController() {
    _firebaseFirestoreServices = FirebaseServices(FirebaseFirestore.instance);
    users.bindStream(_firebaseFirestoreServices.getUserStream());
  }
}
