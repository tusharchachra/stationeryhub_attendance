import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:stationeryhub_attendance/services/shared_prefs_services.dart';

import '../albums/album_organizations.dart';
import '../albums/album_users.dart';
import '../albums/enum_user_type.dart';
import '../controllers/firebase_auth_controller.dart';
import 'firebase_error_controller.dart';
import 'login_screen_controller.dart';

class FirebaseFirestoreController extends GetxController {
  static FirebaseFirestoreController firestoreController = Get.find();
  static FirebaseAuthController authController = Get.find();
  static LoginScreenController loginController = Get.find();
  static FirebaseErrorController errorController = Get.find();
  Rx<AlbumUsers?>? registeredUser = AlbumUsers().obs;
  Rx<AlbumOrganization>? registeredOrganization = AlbumOrganization().obs;
  final FirebaseFirestore firestoreInstance = FirebaseFirestore.instance;

  @override
  Future onReady() async {
    super.onReady();

    super.onReady();
    registeredUser = Rx<AlbumUsers?>(AlbumUsers());
    //Attaching listener to user
    firestoreController.attachUserListener();
    /*registeredUser?.bindStream(
        getUserForStreamBiding(phoneNum: loginController.phoneNum.value));
    ever(registeredUser!, (val) {
      print('registered listener');
    });*/

    /* var tempUser =
        await getUser(phoneNum: loginController.phoneNum.value ?? '');
    if (kDebugMode) {
      debugPrint('Updating registered user...');
    }
    registeredUser?.update((user) {
      user?.phoneNum = tempUser?.phoneNum;
      user?.name = tempUser?.name;
    });*/
    //registeredUser?.value = tempUser;
  }

  void attachUserListener({
    String? phoneNum,
  }) {
    if (kDebugMode) {
      debugPrint(
          'Attaching listener for firebase user = ${authController.firebaseUser.value?.uid}');
    }
    firestoreInstance
            .collection("users")
            .where('firebaseId',
                isEqualTo: authController.firebaseUser.value?.uid)
            /*.withConverter(
          fromFirestore: AlbumUsers.fromFirestore,
          toFirestore: (AlbumUsers user, _) => user.toJson(),
        )*/
            .snapshots()
            .listen((event) {
      if (kDebugMode) {
        print('user data changed');
      }
      print(event.docs[0].data());
      registeredUser?.value = AlbumUsers.fromJson(event.docs[0].data());
    })
        /* .map((snapshot) {
      print(snapshot);
      x = AlbumUsers.fromFirestore(snapshot, null);
      // return AlbumUsers.fromFirestore(snapshot.docs[0], null);
    })*/
        ;

        print(registeredUser);
  }

  //return user data from firestore
  Future<AlbumUsers?> getUser({
    required String phoneNum,
    GetOptions? getOptions,
  }) async {
    AlbumUsers? tempUser;
    if (kDebugMode) {
      debugPrint('Fetching registered user details from firestore...');
    }
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
        //tempUser.setUid(authController.firebaseUser.value!.uid);
      } else {}
      print(tempUser);
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
      errorController.getErrorMsg(e);

      if (kDebugMode) {
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
    if (kDebugMode) {
      debugPrint('Storing new user to firestore...');
    }
    try {
      final ref = firestoreInstance.collection("users").doc().withConverter(
            fromFirestore: AlbumUsers.fromFirestore,
            toFirestore: (AlbumUsers user, _) => user.toJson(),
          );
      AlbumUsers tempUser = AlbumUsers(
          firebaseId: authController.firebaseUser.value?.uid,
          userType: userType,
          name: name ?? '',
          phoneNum: phoneNum,
          organizationId: orgId);
      await ref.set(tempUser);
      if (kDebugMode) {
        debugPrint('New user Id added = ${ref.id}');
      }
    } on FirebaseException catch (e) {
      errorController.getErrorMsg(e);
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
    if (kDebugMode) {
      debugPrint('Fetching organization details from firestore...');
    }
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
    if (kDebugMode) {
      debugPrint('Creating new Organization...');
    }
    try {
      final ref =
          firestoreInstance.collection("organizations").doc().withConverter(
                fromFirestore: AlbumOrganization.fromFirestore,
                toFirestore: (AlbumOrganization organization, _) =>
                    organization.toJson(),
              );
      await ref.set(newOrganization);
      if (kDebugMode) {
        debugPrint('New organization added = ${ref.id}');
      }
      AlbumOrganization? insertedOrganization =
          await getOrganization(orgId: ref.id);
      //Storing
      registeredOrganization?.update((org) {
        org?.id = insertedOrganization?.id;
        org?.name = insertedOrganization?.name;
        org?.address = insertedOrganization?.address;
      });

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
        //  errorController.getErrorMsg(e);
        print('Error:${e.toString()}');
      }
    }
    return null;
  }

  //update OrganizationId to the user's/creator's profile
  Future<void> updateOrganizationIdInCreator(
      {required String currentUserId, required String organizationId}) async {
    if (kDebugMode) {
      debugPrint('Updating org Id to uers\' profile on firestore...');
    }
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
            print('Updated user details:$currentUser');
          }
          /* await SharedPrefsServices.sharedPrefsInstance
              .storeUserToSharedPrefs(user: currentUser!);*/
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
}
