import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:stationeryhub_attendance/albums/album_organization.dart';
import 'package:stationeryhub_attendance/albums/album_users.dart';

class FirebaseFirestoreServices {
  final FirebaseFirestore db = FirebaseFirestore.instance;
  // List<AlbumUsers> usersList = [];
  //FirebaseFirestoreServices(this.db);

  Future<AlbumUsers?> isUserExists({required String phoneNum}) async {
    AlbumUsers? tempUser;
    try {
      await db
          .collection("users")
          .where('phone_num', isEqualTo: phoneNum)
          .get()
          .then((event) async {
        for (var doc in event.docs) {
          tempUser = AlbumUsers.fromJson(doc.data());
          tempUser?.uid = doc.id;
          print('Fetched user=$tempUser');
          //usersList.add(tempUser);
        }
        if (kDebugMode) {
          //print('User List: $usersList\n');
        }
        return tempUser;
      });
    } on Exception catch (e) {
      // TODO
      if (kDebugMode) {
        print('Error:${e.toString()}');
      }
    }
    return tempUser;
  }

  Future<void> addNewUser(
      {required String phoneNum, required String userType}) async {
    AlbumUsers tempUser =
        AlbumUsers(uid: '', category: userType, name: '', phoneNum: phoneNum);
    try {
      await db.collection("users").add(tempUser.toJson()).then((event) async {
        if (kDebugMode) {
          //print('User List: $usersList\n');
        }
        return tempUser;
      });
    } on Exception catch (e) {
      // TODO
      if (kDebugMode) {
        print('Error:${e.toString()}');
      }
    }
  }

  Future<AlbumOrganization?> getOrganization({required String phoneNum}) async {
    AlbumOrganization? organization;
    try {
      await db
          .collection("organizations")
          .where('phone_num', isEqualTo: phoneNum)
          .get()
          .then((event) async {
        for (var doc in event.docs) {
          organization = AlbumOrganization.fromJson(doc.data());
        }
        if (kDebugMode) {
          //print('User List: $usersList\n');
        }
      });
    } on Exception catch (e) {
      // TODO
      if (kDebugMode) {
        print('Error:${e.toString()}');
      }
    }
    return organization;
  }
}
