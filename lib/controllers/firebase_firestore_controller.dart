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
  Rx<UsersModel?> registeredUser = UsersModel().obs;
  Rx<OrganizationModel?> registeredOrganization = OrganizationModel().obs;
  final FirebaseFirestore firestoreInstance = FirebaseFirestore.instance;

  RxBool isLoading = false.obs;
  RxBool showPlaceholder = false.obs;

  RxInt userCountForOrganization = 0.obs;

  @override
  Future onReady() async {
    super.onReady();
    //registeredUser = Rx<AlbumUsers?>(AlbumUsers());
    //print(authController.firebaseUser.value!.uid);
    //getting user
    /*registeredUser?.value = await getUser(
        phoneNum: authController.firebaseUser.value!.phoneNumber!);
    print('Registered user onReady=$registeredUser');*/

    //------------------------------
    /*if (authController.firebaseUser.value != null) {
      registeredUser?.value =
          await getUser(firebaseId: authController.firebaseUser.value?.uid);
      //Attaching listener to user
      if (registeredUser?.value != null) {
        await firestoreController.attachUserListener();
      }
    }*/

    /*  OrganizationModel? tempOrganization =
        await getOrganization(orgId: registeredUser?.value?.organizationId);
    if (tempOrganization != null) {
      registeredOrganization?.value = tempOrganization;
      //attaching listener to organization
      await firestoreController.attachOrganizationListener();
    }*/
    //-----------------------------------

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

  Future attachUserListener() async {
    isLoading.value = true;
    if (kDebugMode) {
      debugPrint(
          'Attaching listener for current user = ${authController.firebaseUser.value?.uid}');
    }
    UsersModel? temp =
        await getUser(firebaseId: authController.firebaseUser.value?.uid);
    print('tempUser in attaching user Listener=$temp');
    firestoreInstance
        .collection("users")
        .where('userId', isEqualTo: registeredUser.value?.userId)
        .snapshots()
        .listen((event) {
      registeredUser(UsersModel.fromJson(event.docs[0].data()));
      if (kDebugMode) {
        print('user data changed and synchronized');
      }
      // _getStorageController.writeUserDetails(registeredUser.value);
    });
    isLoading.value = false;
    Future.delayed(Duration(seconds: 2));
  }

  Future attachOrganizationListener() async {
    isLoading.value = true;

    if (kDebugMode) {
      debugPrint(
          'Attaching listener for organization = ${registeredOrganization.value?.id}');
    }
    firestoreInstance
        .collection("organizations")
        .where('id', isEqualTo: registeredOrganization.value?.id)
        .snapshots()
        .listen((event) {
      registeredOrganization(OrganizationModel.fromJson(event.docs[0].data()));
      setUserCountForOrganization();
      if (kDebugMode) {
        print('Organization data changed and synchronized');
      }
    });
    isLoading.value = false;
  }

  //return user data from firestore.
  Future<UsersModel?> getUser({
    String? phoneNum,
    String? firebaseId,
    String? uid,
    GetOptions? getOptions,
  }) async {
    isLoading.value = true;

    UsersModel? tempUser;
    if (kDebugMode) {
      debugPrint(
          'Fetching registered user details from firestore phoneNum=$phoneNum,firebaseId=$firebaseId, uid=$uid...');
    }
    Query<UsersModel> ref;
    try {
      if (firebaseId == null) {
        ref = firestoreInstance
            .collection("users")
            .where('phoneNum', isEqualTo: phoneNum)
            .withConverter(
              fromFirestore: UsersModel.fromFirestore,
              toFirestore: (UsersModel user, _) => user.toJson(),
            );
      } else if (uid != null) {
        ref = firestoreInstance
            .collection("users")
            .where('userId', isEqualTo: uid)
            .withConverter(
              fromFirestore: UsersModel.fromFirestore,
              toFirestore: (UsersModel user, _) => user.toJson(),
            );
      } else {
        ref = firestoreInstance
            .collection("users")
            .where('firebaseUserId', isEqualTo: firebaseId)
            .withConverter(
              fromFirestore: UsersModel.fromFirestore,
              toFirestore: (UsersModel user, _) => user.toJson(),
            );
      }

      final docSnap = await ref
          .get(getOptions ?? const GetOptions(source: Source.serverAndCache));
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

  //register user
  Future<void> registerNewUser(
      {required String phoneNum,
      required UserType userType,
      String? name,
      String? orgId}) async {
    isLoading.value = true;

    if (kDebugMode) {
      debugPrint('Registering new user to firestore...');
    }
    try {
      final ref = firestoreInstance.collection("users").doc().withConverter(
            fromFirestore: UsersModel.fromFirestore,
            toFirestore: (UsersModel user, _) => user.toJson(),
          );
      UsersModel tempUser = UsersModel(
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
      await firestoreController.updateUser(user: UsersModel(userId: ref.id));
    } on FirebaseException catch (e) {
      errorController.getErrorMsg(e);
      if (kDebugMode) {
        print('Error:${e.toString()}');
      }
    }
    isLoading.value = false;
  }

  //add new user
  Future<void> addNewUser({required UsersModel user}) async {
    isLoading.value = true;

    if (kDebugMode) {
      debugPrint('Storing new user to firestore...');
    }
    try {
      final ref = firestoreInstance.collection("users").doc().withConverter(
            fromFirestore: UsersModel.fromFirestore,
            toFirestore: (UsersModel user, _) => user.toJson(),
          );
      await ref.set(user);
      if (kDebugMode) {
        debugPrint('New user Id added = ${ref.id}');
      }
      //update userId of the user
      await firestoreController.updateUser(user: UsersModel(userId: ref.id));
    } on FirebaseException catch (e) {
      errorController.getErrorMsg(e);
      if (kDebugMode) {
        print('Error:${e.toString()}');
      }
    }
    setUserCountForOrganization();
    isLoading.value = false;
  }

  //update user details
  Future<void> updateUser({required UsersModel user}) async {
    isLoading.value = true;

    if (kDebugMode) {
      debugPrint('Updating user details in firestore...');
    }
    try {
      final ref =
          firestoreInstance.collection("users").doc(user.userId).withConverter(
                fromFirestore: UsersModel.fromFirestore,
                toFirestore: (UsersModel user, _) => user.toJson(),
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
      if (user.profilePicPath != null) {
        await ref.update({'profilePicPath': '${user.profilePicPath}'});
      }
      if (user.idCardFrontPath != null) {
        await ref.update({'idCardFrontPath': '${user.idCardFrontPath}'});
      }
      if (user.idCardBackPath != null) {
        await ref.update({'idCardBackPath': '${user.idCardBackPath}'});
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
  Future<OrganizationModel?> getOrganization({
    String? orgId,
    UsersModel? user,
    GetOptions? getOptions,
  }) async {
    isLoading.value = true;

    OrganizationModel? tempOrganization;
    if (kDebugMode) {
      debugPrint(
          'Fetching registered organization details from firestore for orgId=$orgId,user=$user...');
    }
    Query<OrganizationModel> ref;
    try {
      if (orgId != null) {
        ref = firestoreInstance
            .collection("organizations")
            .where('id', isEqualTo: orgId)
            .withConverter(
              fromFirestore: OrganizationModel.fromFirestore,
              toFirestore: (OrganizationModel user, _) => user.toJson(),
            );
      } else {
        ref = firestoreInstance
            .collection("organizations")
            .where('id', isEqualTo: user?.organizationId)
            .withConverter(
              fromFirestore: OrganizationModel.fromFirestore,
              toFirestore: (OrganizationModel user, _) => user.toJson(),
            );
      }

      final docSnap = await ref
          .get(getOptions ?? const GetOptions(source: Source.serverAndCache));
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
      {required OrganizationModel newOrganization}) async {
    isLoading.value = true;

    if (kDebugMode) {
      debugPrint('Creating new Organization...');
    }
    try {
      final ref =
          firestoreInstance.collection("organizations").doc().withConverter(
                fromFirestore: OrganizationModel.fromFirestore,
                toFirestore: (OrganizationModel organization, _) =>
                    organization.toJson(),
              );
      await ref.set(newOrganization);
      if (kDebugMode) {
        debugPrint('New organization added = ${ref.id}');
      }

      //update orgId on firestore
      var tempOrg = OrganizationModel(
          id: ref.id, createdBy: registeredUser.value?.userId);
      print('tempOrg=$tempOrg');
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
      UsersModel tempUser = UsersModel(
          userId: registeredUser.value?.userId, organizationId: ref.id);
      print(tempUser);
      await updateUser(user: tempUser);
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
      {required OrganizationModel organization}) async {
    isLoading.value = true;

    if (kDebugMode) {
      debugPrint('Updating organization details in firestore...');
    }
    try {
      final ref = firestoreInstance
          .collection("organizations")
          .doc(organization.id)
          .withConverter(
            fromFirestore: UsersModel.fromFirestore,
            toFirestore: (UsersModel user, _) => user.toJson(),
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
            fromFirestore: OrganizationModel.fromFirestore,
            toFirestore: (OrganizationModel organization, _) =>
                organization.toJson(),
          );
      ref.update({"organizationId": organizationId}).then(
        (value) async {
          if (kDebugMode) {
            print(
                "DocumentSnapshot successfully updated!\nstoring new user data to shared prefs");
          }
          UsersModel? currentUser = await SharedPrefsServices
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

  Future<void> setUserCountForOrganization() async {
    showPlaceholder.value = true;
    if (kDebugMode) {
      debugPrint(
          'Fetching no. of employees of registered organization from firestore for orgId=$registeredOrganization');
    }
    try {
      {
        firestoreInstance
            .collection("users")
            .where('organizationId',
                isEqualTo: firestoreController.registeredOrganization.value?.id)
            .count()
            .get()
            .then((response) {
          userCountForOrganization.value =
              response.count == null ? 0 : response.count! - 1;
        });
      }
    } on FirebaseException catch (e) {
      errorController.getErrorMsg(e);
      if (kDebugMode) {
        print('Error:${e.toString()}');
      }
    }
    showPlaceholder.value = false;
  }
}
