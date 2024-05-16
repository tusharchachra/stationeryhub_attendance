import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:stationeryhub_attendance/albums/album_organizations.dart';
import 'package:stationeryhub_attendance/albums/album_users.dart';
import 'package:stationeryhub_attendance/albums/enum_user_type.dart';

class FirebaseFirestoreServices {
  final FirebaseFirestore db = FirebaseFirestore.instance;
  // List<AlbumUsers> usersList = [];
  //FirebaseFirestoreServices(this.db);

  Future<AlbumUsers?> isUserExists({
    required String phoneNum,
    GetOptions? getOptions,
  }) async {
    AlbumUsers? tempUser;
    try {
      final ref = db
          .collection("users")
          .where('phoneNum', isEqualTo: phoneNum)
          .withConverter(
            fromFirestore: AlbumUsers.fromFirestore,
            toFirestore: (AlbumUsers user, _) => user.toJson(),
          );
      final docSnap =
          await ref.get(getOptions ?? const GetOptions(source: Source.server));
      if (docSnap.docs.isNotEmpty) {
        tempUser = docSnap.docs[0].data();
        tempUser.setUid(docSnap.docs[0].id);
        //  return {'user': tempUser, 'userId': docSnap.docs[0].id};
      } else {
        //return {'user': tempUser, 'userId': '0'};
      }
      return tempUser;
/*
      await db
          .collection("users")
          .where('phone_num', isEqualTo: phoneNum)
          .get(getOptions ?? const GetOptions(source: Source.server))
          .then((event) async {
        for (var doc in event.docs) {
          tempUser = AlbumUsers.fromJson(doc.data());
          print(doc.id);
          tempUser?.uid = doc.id;
          print('Fetched user=$tempUser');
          //usersList.add(tempUser);
        }
        if (kDebugMode) {
          //print('User List: $usersList\n');
        }
        return tempUser;
      });*/
    } on Exception catch (e) {
      // TODO
      if (kDebugMode) {
        print('Error:${e.toString()}');
      }
    }
    //return {'user': tempUser, 'userId': };
  }

  Future<void> addNewUser(
      {required String phoneNum, required UserType userType}) async {
    try {
      final ref = db.collection("users").doc().withConverter(
            fromFirestore: AlbumUsers.fromFirestore,
            toFirestore: (AlbumUsers user, _) => user.toJson(),
          );
      AlbumUsers tempUser = AlbumUsers(
          uid: ref.id, userType: userType, name: '', phoneNum: phoneNum);
      await ref.set(tempUser);
      if (kDebugMode) {
        print('New user added = ${ref.id}');
      }
      // return ref.id;
    } on Exception catch (e) {
      // TODO
      if (kDebugMode) {
        print('Error:${e.toString()}');
      }
    }
  }

  //get organization details based on phone number of the user
  Future<AlbumOrganization?> getOrganization({
    String? orgId,
    AlbumUsers? user,
    GetOptions? getOptions,
  }) async {
    AlbumOrganization? fetchedOrganization;
    try {
      if (user != null) {
        final ref = db
            .collection("organizations")
            .doc(user.organizationId)
            .withConverter(
              fromFirestore: AlbumOrganization.fromFirestore,
              toFirestore: (AlbumOrganization organization, _) =>
                  organization.toJson(),
            );
        final docSnap = await ref
            .get(getOptions ?? const GetOptions(source: Source.server));
        // if (docSnap.docs.isEmpty) return null;
        fetchedOrganization = docSnap.data();
      }
    } on Exception catch (e) {
      // TODO
      if (kDebugMode) {
        print('Error:${e.toString()}');
      }
    }
    return fetchedOrganization;
  }

  //create new organisation and add org id to users table against the particular user
  Future<String?> createOrganization(
      {required AlbumOrganization newOrganization}) async {
    try {
      final ref = db.collection("organizations").doc().withConverter(
            fromFirestore: AlbumOrganization.fromFirestore,
            toFirestore: (AlbumOrganization organization, _) =>
                organization.toJson(),
          );
      await ref.set(newOrganization);
      if (kDebugMode) {
        print('New organization added = ${ref.id}');
      }
      return ref.id;
    } on Exception catch (e) {
      // TODO
      if (kDebugMode) {
        print('Error:${e.toString()}');
      }
    }
  }

  //update OrganizationId to the user's/creator's profile
  Future<void> updateOrganizationId(
      {required String currentUserId, required String organizationId}) async {
    try {
      final ref = db.collection("users").doc(currentUserId).withConverter(
            fromFirestore: AlbumOrganization.fromFirestore,
            toFirestore: (AlbumOrganization organization, _) =>
                organization.toJson(),
          );
      ref.update({"organizationId": organizationId}).then(
          (value) => print("DocumentSnapshot successfully updated!"),
          onError: (e) => print("Error updating document $e"));
    } on Exception catch (e) {
      // TODO
      if (kDebugMode) {
        print('Error:${e.toString()}');
      }
    }
  }
}
