import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:stationeryhub_attendance/services/login_screen_controller.dart';
import 'package:stationeryhub_attendance/services/shared_prefs_services.dart';

import '../albums/album_organizations.dart';
import '../albums/album_users.dart';
import '../albums/enum_user_type.dart';
import 'firebase_auth_controller.dart';

class FirebaseFirestoreController extends GetxController {
  static FirebaseFirestoreController firestoreController = Get.find();
  static FirebaseAuthController authController = Get.find();
  static LoginScreenController loginController = Get.find();
  Rx<AlbumUsers?>? registeredUser = AlbumUsers().obs;
  final FirebaseFirestore firestoreInstance = FirebaseFirestore.instance;

  @override
  void onReady() async {
    super.onReady();
    var tempUser =
        await getUser(phoneNum: loginController.phoneNum.value ?? '');
    registeredUser?.update((user) {
      user?.phoneNum = tempUser?.phoneNum;
      user?.name = tempUser?.name;
    });
    //registeredUser?.value = tempUser;
  }

  Future<AlbumUsers?> getUser({
    required String phoneNum,
    GetOptions? getOptions,
  }) async {
    AlbumUsers? tempUser;
    try {
      final ref = firestoreInstance
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
    } on FirebaseException catch (e) {
      // TODO
      if (kDebugMode) {
        print(e.code);
        print('Error:${e.toString()}');
      }
    }
    return null;
    //return {'user': tempUser, 'userId': };
  }

  Future<void> addNewUser(
      {required String phoneNum,
      required UserType userType,
      String? name,
      String? orgId}) async {
    try {
      final ref = firestoreInstance.collection("users").doc().withConverter(
            fromFirestore: AlbumUsers.fromFirestore,
            toFirestore: (AlbumUsers user, _) => user.toJson(),
          );
      AlbumUsers tempUser = AlbumUsers(
          uid: ref.id,
          userType: userType,
          name: name ?? '',
          phoneNum: phoneNum,
          organizationId: orgId);
      await ref.set(tempUser);
      if (kDebugMode) {
        print('New user Id added = ${ref.id}');
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
      final ref = firestoreInstance
          .collection("organizations")
          .doc("$orgId")
          .withConverter(
            fromFirestore: AlbumOrganization.fromFirestore,
            toFirestore: (AlbumOrganization organization, _) =>
                organization.toJson(),
          );
      final docSnap =
          await ref.get(getOptions ?? const GetOptions(source: Source.server));
      // if (docSnap.docs.isEmpty) return null;
      fetchedOrganization = docSnap.data();
      if (kDebugMode) {
        print('fetched organization=$fetchedOrganization');
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
      final ref =
          firestoreInstance.collection("organizations").doc().withConverter(
                fromFirestore: AlbumOrganization.fromFirestore,
                toFirestore: (AlbumOrganization organization, _) =>
                    organization.toJson(),
              );
      await ref.set(newOrganization);
      if (kDebugMode) {
        print('New organization added = ${ref.id}');
      }
      AlbumOrganization? insertedOrganization =
          await getOrganization(orgId: ref.id);
      if (kDebugMode) {
        print('inserted organization=$insertedOrganization');
      }
      if (insertedOrganization != null) {
        await SharedPrefsServices.sharedPrefsInstance
            .storeOrganizationToSharedPrefs(organization: insertedOrganization);
      }

      return ref.id;
    } on Exception catch (e) {
      // TODO
      if (kDebugMode) {
        print('Error:${e.toString()}');
      }
    }
    return null;
  }

  //update OrganizationId to the user's/creator's profile
  Future<void> updateOrganizationIdInCreator(
      {required String currentUserId, required String organizationId}) async {
    try {
      final ref = firestoreInstance
          .collection("users")
          .doc(currentUserId)
          .withConverter(
            fromFirestore: AlbumOrganization.fromFirestore,
            toFirestore: (AlbumOrganization organization, _) =>
                organization.toJson(),
          );
      ref.update({"organizationId": organizationId}).then(
        (value) async {
          if (kDebugMode) {
            print(
                "DocumentSnapshot successfully updated!\nstoring new user data to shared prefs");
          }
          AlbumUsers? currentUser = await SharedPrefsServices
              .sharedPrefsInstance
              .getUserFromSharedPrefs();
          // currentUser = await getUser(phoneNum: currentUser!.phoneNum);
          if (kDebugMode) {
            print(
                'Updated user details:$currentUser.\n Storing to Shared prefs');
          }
          await SharedPrefsServices.sharedPrefsInstance
              .storeUserToSharedPrefs(user: currentUser!);
        },
        onError: (e) {
          if (kDebugMode) {
            print("Error updating document $e");
          }
        },
      );
    } on Exception catch (e) {
      // TODO
      if (kDebugMode) {
        print('Error:${e.toString()}');
      }
    }
  }

  String? _getFirestoreErrorMsg(FirebaseException e) {
    if (e.code == 'unavailable') {
      return 'No interent';
    } else {
      return e.message;
    }
  }
}
