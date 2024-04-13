import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:stationeryhub_attendance/albums/album_users.dart';

class FirebaseFirestoreServices {
  final FirebaseFirestore db = FirebaseFirestore.instance;
  List<AlbumUsers> usersList = [];
  //FirebaseFirestoreServices(this.db);

  Future<bool> isUserExists({required String phoneNum}) async {
    await db.collection("users").get().then((event) {
      for (var doc in event.docs) {
        AlbumUsers tempUser = AlbumUsers.fromJson(doc.data());
        tempUser.uid = doc.id;
        usersList.add(tempUser);
      }
      if (kDebugMode) {
        print('User List: $usersList\n');
      }
    });
    for (var user in usersList) {
      if (user.phoneNum == phoneNum) return true;
    }
    return false;
  }
}
