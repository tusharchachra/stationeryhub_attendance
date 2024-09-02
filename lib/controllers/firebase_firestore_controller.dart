import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:stationeryhub_attendance/services/shared_prefs_services.dart';

import '../controllers/firebase_auth_controller.dart';
import '../models/organizations_model.dart';
import '../models/user_type_enum.dart';
import '../models/users_model.dart';
import 'firebase_error_controller.dart';
import 'login_screen_controller.dart';

class FirebaseFirestoreController extends GetxController {
  static FirebaseFirestoreController firestoreController = Get.find();
  static FirebaseAuthController authController = Get.find();
  static LoginScreenController loginController = Get.find();
  static FirebaseErrorController errorController = Get.find();
  Rx<AlbumUsers?>? registeredUser = AlbumUsers().obs;
  Rx<AlbumOrganization?>? registeredOrganization = AlbumOrganization().obs;
  final FirebaseFirestore firestoreInstance = FirebaseFirestore.instance;

  RxBool isLoading = false.obs;

  @override
  Future onReady() async {
    super.onReady();
    //registeredUser = Rx<AlbumUsers?>(AlbumUsers());
    //print(authController.firebaseUser.value!.uid);
    //getting user
    /*registeredUser?.value = await getUser(
        phoneNum: authController.firebaseUser.value!.phoneNumber!);
    print('Registered user onReady=$registeredUser');*/
    registeredUser?.value =
        await getUser(firebaseId: authController.firebaseUser.value?.uid);
    //Attaching listener to user
    await firestoreController.attachUserListener();

    AlbumOrganization? tempOrganization =
        await getOrganization(orgId: registeredUser?.value?.organizationId);
    if (tempOrganization != null) {
      registeredOrganization?.value = tempOrganization;
      //attaching listener to organization
      await firestoreController.attachOrganizationListener();
    }
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

  Future attachUserListener(/*{
    String? phoneNum,
  }*/
      ) async {
    isLoading.value = true;
    if (kDebugMode) {
      debugPrint(
          'Attaching listener for current user = ${authController.firebaseUser.value?.uid}');
    }
    await firestoreController.getUser(
        firebaseId: authController.firebaseUser.value?.uid);
    firestoreInstance
        .collection("users")
        .doc(registeredUser?.value
            ?.userId) /*.withConverter(
          fromFirestore: AlbumUsers.fromFirestore,
          toFirestore: (AlbumUsers user, _) => user.toJson(),
        )*/
        .snapshots()
        .listen((event) {
      //print(event.docs[0].data());
      registeredUser?.value = AlbumUsers.fromJson(event.data()!);
      if (kDebugMode) {
        print('user data changed and synchronized');
      }
    });

    isLoading.value = false;
    /* .map((snapshot) {
      print(snapshot);
      x = AlbumUsers.fromFirestore(snapshot, null);
      // return AlbumUsers.fromFirestore(snapshot.docs[0], null);
    })*/
  }

  Future attachOrganizationListener(/*{
    String? orgId,
  }*/
      ) async {
    isLoading.value = true;

    if (kDebugMode) {
      debugPrint(
          'Attaching listener for organization = ${registeredOrganization?.value?.id}');
    }

    firestoreInstance
        .collection("organizations")
        .where('id', isEqualTo: registeredOrganization?.value?.id)
        /*.withConverter(
          fromFirestore: AlbumUsers.fromFirestore,
          toFirestore: (AlbumUsers user, _) => user.toJson(),
        )*/
        .snapshots()
        .listen((event) {
      registeredOrganization?.value =
          AlbumOrganization.fromJson(event.docs[0].data());
      if (kDebugMode) {
        print('Organization data changed and synchronized');
      }
    });
    isLoading.value = false;

    /* .map((snapshot) {
      print(snapshot);
      x = AlbumUsers.fromFirestore(snapshot, null);
      // return AlbumUsers.fromFirestore(snapshot.docs[0], null);
    })*/
  }

  //return user data from firestore.
  Future<AlbumUsers?> getUser({
    String? phoneNum,
    String? firebaseId,
    GetOptions? getOptions,
  }) async {
    isLoading.value = true;

    AlbumUsers? tempUser;
    if (kDebugMode) {
      debugPrint(
          'Fetching registered user details from firestore phoneNum=$phoneNum,firebaseId=$firebaseId...');
    }
    Query<AlbumUsers> ref;
    try {
      if (firebaseId == null) {
        ref = firestoreInstance
            .collection("users")
            .where('phoneNum', isEqualTo: phoneNum)
            .withConverter(
              fromFirestore: AlbumUsers.fromFirestore,
              toFirestore: (AlbumUsers user, _) => user.toJson(),
            );
      } else {
        ref = firestoreInstance
            .collection("users")
            .where('firebaseUserId', isEqualTo: firebaseId)
            .withConverter(
              fromFirestore: AlbumUsers.fromFirestore,
              toFirestore: (AlbumUsers user, _) => user.toJson(),
            );
      }

      final docSnap =
          await ref.get(getOptions ?? const GetOptions(source: Source.server));
      if (docSnap.docs.isNotEmpty) {
        tempUser = docSnap.docs[0].data();
      } else {}
      return tempUser;
    } on FirebaseException catch (e) {
      // TODO
      errorController.getErrorMsg(e);

      if (kDebugMode) {
        print('Error:${e.toString()}');
      }
    }
    isLoading.value = false;

    return null;
    //return {'user': tempUser, 'userId': };
  }

  Future<void> addNewUser(
      {required String phoneNum,
      required UserType userType,
      String? name,
      String? orgId}) async {
    isLoading.value = true;

    if (kDebugMode) {
      debugPrint('Storing new user to firestore...');
    }
    try {
      final ref = firestoreInstance.collection("users").doc().withConverter(
            fromFirestore: AlbumUsers.fromFirestore,
            toFirestore: (AlbumUsers user, _) => user.toJson(),
          );
      AlbumUsers tempUser = AlbumUsers(
          firebaseUserId: authController.firebaseUser.value?.uid,
          userId: '',
          userType: userType,
          name: name ?? '',
          phoneNum: phoneNum,
          organizationId: orgId);
      await ref.set(tempUser);
      if (kDebugMode) {
        debugPrint('New user Id added = ${ref.id}');
      }
      //update userId of the user
      await firestoreController.updateUser(user: AlbumUsers(userId: ref.id));
    } on FirebaseException catch (e) {
      errorController.getErrorMsg(e);
      if (kDebugMode) {
        print('Error:${e.toString()}');
      }
    }
    isLoading.value = false;
  }

  //update user details
  Future<void> updateUser({required AlbumUsers user}) async {
    isLoading.value = true;

    if (kDebugMode) {
      debugPrint('Updating user details in firestore...');
    }
    try {
      final ref =
          firestoreInstance.collection("users").doc(user.userId).withConverter(
                fromFirestore: AlbumUsers.fromFirestore,
                toFirestore: (AlbumUsers user, _) => user.toJson(),
              );
      if (user.firebaseUserId != null) {
        await ref.update({'firebaseUserId': '${user.firebaseUserId}'});
      }
      if (user.userId != null) {
        await ref.update({'userId': '${user.userId}'});
      }
      if (user.name != null) {
        await ref.update({'name': '${user.name}'});
      }
      if (user.phoneNum != null) {
        await ref.update({'phoneNum': '${user.phoneNum}'});
      }
      if (user.organizationId != null) {
        await ref.update({'organizationId': '${user.organizationId}'});
      }
      if (user.userType != null) {
        await ref.update({'userType': '${user.userType}'});
      }

      if (kDebugMode) {
        debugPrint('User details updated');
      }
    } on FirebaseException catch (e) {
      errorController.getErrorMsg(e);
      if (kDebugMode) {
        print('Error:${e.toString()}');
      }
    }
    isLoading.value = false;
  }

  //fetch Organization data from firestore
  Future<AlbumOrganization?> getOrganization({
    String? orgId,
    AlbumUsers? user,
    GetOptions? getOptions,
  }) async {
    isLoading.value = true;

    AlbumOrganization? tempOrganization;
    if (kDebugMode) {
      debugPrint(
          'Fetching registered organization details from firestore for orgId=$orgId,user=$user...');
    }
    Query<AlbumOrganization> ref;
    try {
      if (orgId != null) {
        ref = firestoreInstance
            .collection("organizations")
            .where('id', isEqualTo: orgId)
            .withConverter(
              fromFirestore: AlbumOrganization.fromFirestore,
              toFirestore: (AlbumOrganization user, _) => user.toJson(),
            );
      } else {
        ref = firestoreInstance
            .collection("organizations")
            .where('id', isEqualTo: user?.organizationId)
            .withConverter(
              fromFirestore: AlbumOrganization.fromFirestore,
              toFirestore: (AlbumOrganization user, _) => user.toJson(),
            );
      }

      final docSnap =
          await ref.get(getOptions ?? const GetOptions(source: Source.server));
      if (docSnap.docs.isNotEmpty) {
        tempOrganization = docSnap.docs[0].data();
        //tempUser.setUid(authController.firebaseUser.value!.uid);
      } else {}
      return tempOrganization;
    } on FirebaseException catch (e) {
      // TODO
      errorController.getErrorMsg(e);

      if (kDebugMode) {
        print('Error:${e.toString()}');
      }
    }
    isLoading.value = false;

    return null;
    //return {'user': tempUser, 'userId': };
  }

/*  //get organization details based on phone number of the user
  Future<AlbumOrganization?> getOrganization({
    String? orgId,
    AlbumUsers? user,
    GetOptions? getOptions,
  }) async {
    AlbumOrganization? fetchedOrganization;
    if (kDebugMode) {
      debugPrint('Fetching organization details from firestore...');
    }
    var ref;
    try {
      ref = firestoreInstance
          .collection("organizations")
          .doc(orgId)
          .withConverter(
            fromFirestore: AlbumOrganization.fromFirestore,
            toFirestore: (AlbumOrganization organization, _) =>
                organization.toJson(),
          );
      final docSnap =
          await ref.get(getOptions ?? const GetOptions(source: Source.server));
      // if (docSnap.docs.isEmpty) return null;
      if (docSnap.docs.isNotEmpty) {
        fetchedOrganization = docSnap.docs[0].data();
        //tempUser.setUid(authController.firebaseUser.value!.uid);
      } else {}
      return fetchedOrganization;
      */ /* if(docSnap.docs.is)
      fetchedOrganization = docSnap.data();
      if (fetchedOrganization != null) {
        if (kDebugMode) {
          print('fetched organization=$fetchedOrganization');
        }
        registeredOrganization?.value = fetchedOrganization;
      }
      if (kDebugMode) {
        print('Registered organization=$registeredOrganization');
      }
      return fetchedOrganization;*/ /*
    } on Exception catch (e) {
      // TODO
      if (kDebugMode) {
        print('Error:${e.toString()}');
      }
    }
    return null;
  }*/

  //create new organisation and add org id to users table against the particular user
  Future<String?> createOrganization(
      {required AlbumOrganization newOrganization}) async {
    isLoading.value = true;

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

      //update orgId on firestore
      var tempOrg = AlbumOrganization(
          id: ref.id, createdBy: registeredUser?.value?.userId);
      await updateOrganization(organization: tempOrg);

      /* AlbumOrganization? insertedOrganization =
          await getOrganization(orgId: ref.id);*/

      //Storing
      /* registeredOrganization?.update((org) {
        org?.id = insertedOrganization?.id;
        org?.name = insertedOrganization?.name;
        org?.address = insertedOrganization?.address;
      });*/

      //inserting the newOrganizationId to the user's profile on firestore
      await updateUser(
          user: AlbumUsers(
              userId: registeredUser?.value?.userId, organizationId: ref.id));
      /*await firestoreController.updateOrganizationIdInCreator(
          currentUserId:
              firestoreController.registeredUser!.value!.firebaseUserId!,
          organizationId: ref.id);*/

      /* if (kDebugMode) {
        print('inserted organization=$insertedOrganization');
      }*/
      /*  if (insertedOrganization != null) {
        await SharedPrefsServices.sharedPrefsInstance
            .storeOrganizationToSharedPrefs(organization: insertedOrganization);
      }*/

      return ref.id;
    } on Exception catch (e) {
      // TODO
      if (kDebugMode) {
        //  errorController.getErrorMsg(e);
        print('Error:${e.toString()}');
      }
    }
    isLoading.value = false;

    return null;
  }

  //update organization details
  Future<void> updateOrganization(
      {required AlbumOrganization organization}) async {
    isLoading.value = true;

    if (kDebugMode) {
      debugPrint('Updating organization details in firestore...');
    }
    try {
      final ref = firestoreInstance
          .collection("organizations")
          .doc(organization.id)
          .withConverter(
            fromFirestore: AlbumUsers.fromFirestore,
            toFirestore: (AlbumUsers user, _) => user.toJson(),
          );
      if (organization.address != null) {
        await ref.update({'address': '${organization.address}'});
      }
      if (organization.createdBy != null) {
        await ref.update({'createdBy': '${organization.createdBy}'});
      }
      if (organization.createdOn != null) {
        await ref.update({'createdOn': '${organization.createdOn}'});
      }
      if (organization.geoLocationLat != null) {
        await ref.update({'geolocationLat': '${organization.geoLocationLat}'});
      }
      if (organization.geoLocationLong != null) {
        await ref
            .update({'geoLocationLong': '${organization.geoLocationLong}'});
      }
      if (organization.id != null) {
        await ref.update({'id': '${organization.id}'});
      }
      if (organization.name != null) {
        await ref.update({'name': '${organization.name}'});
      }
      if (organization.subscription != null) {
        await ref.update({'subscription': '${organization.subscription}'});
      }

      if (kDebugMode) {
        debugPrint('Organization details updated');
      }
    } on FirebaseException catch (e) {
      errorController.getErrorMsg(e);
      if (kDebugMode) {
        print('Error:${e.toString()}');
      }
    }
    isLoading.value = false;
  }

  //update OrganizationId to the user's/creator's profile
  Future<void> updateOrganizationIdInCreator(
      {required String currentUserId, required String organizationId}) async {
    isLoading.value = true;

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
    isLoading.value = false;
  }
}
