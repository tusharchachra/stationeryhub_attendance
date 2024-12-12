import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:stationeryhub_attendance/models/attendance_model.dart';
import 'package:stationeryhub_attendance/screens/mark_attendance_screen.dart';

import '../controllers/firebase_auth_controller.dart';
import '../helpers/constants.dart';
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
  RxList<UsersModel> userList = <UsersModel>[].obs;

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
        .where('userId', isEqualTo: temp?.userId)
        .snapshots()
        .listen((event) {
      registeredUser(UsersModel.fromJson(event.docs[0].data()));
      if (kDebugMode) {
        print('user data changed and synchronized $registeredUser');
      }
      // _getStorageController.writeUserDetails(registeredUser.value);
    });
    isLoading.value = false;
  }

  Future attachOrganizationListener() async {
    isLoading.value = true;

    if (kDebugMode) {
      debugPrint(
          'Attaching listener for organization = ${registeredOrganization.value?.id}');
    }
    firestoreInstance
        .collection(Constants.organizationNodeName)
        .doc(authController.firebaseUser.value?.uid)
        /* .where('id', isEqualTo: registeredOrganization.value?.id)*/
        .snapshots()
        .listen((event) {
      registeredOrganization(OrganizationModel.fromJson(event.data()!));
      print('registered Organization=$registeredOrganization');
      //setUserCountForOrganization();
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
    ///Fetches users and converts to the UsersModel from the firestore based on the parameters passed.
    ///
    /// fetch by phoneNum -> pass only `phoneNum`
    /// fetch by firebaseId -> pass only `firebaseId`
    /// fetch by userId -> pass only `uid`

    isLoading.value = true;

    UsersModel? tempUser;
    if (kDebugMode) {
      debugPrint(
          'Fetching registered user details from firestore phoneNum=$phoneNum,firebaseId=$firebaseId, uid=$uid...');
    }
    //print(uid);
    Query<UsersModel> ref;
    try {
      if (phoneNum != null && firebaseId == null && uid == null) {
        ref = firestoreInstance
            .collection(Constants.organizationNodeName)
            .doc(firestoreController.registeredOrganization.value?.id)
            .collection(Constants.usersNodeName)
            .where('phoneNum', isEqualTo: phoneNum)
            .withConverter(
              fromFirestore: UsersModel.fromFirestore,
              toFirestore: (UsersModel user, _) => user.toJson(),
            );
      } else if (phoneNum == null && firebaseId == null && uid != null) {
        ref = firestoreInstance
            .collection(Constants.organizationNodeName)
            .doc(firestoreController.registeredOrganization.value?.id)
            .collection(Constants.usersNodeName)
            .where('userId', isEqualTo: uid)
            .withConverter(
              fromFirestore: UsersModel.fromFirestore,
              toFirestore: (UsersModel user, _) => user.toJson(),
            );
      } else {
        ref = firestoreInstance
            .collection(Constants.organizationNodeName)
            .doc(firestoreController.registeredOrganization.value?.id)
            .collection(Constants.usersNodeName)
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
      isLoading.value = false;
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

  //get all users of the organization
  Future<void> getAllUsers() async {
    isLoading(true);
    List<UsersModel> tempUserList = [];
    //userList.clear();
    // userList.refresh();
    final ref = firestoreInstance
        .collection(Constants.organizationNodeName)
        .doc(firestoreController.registeredOrganization.value?.id)
        .collection(Constants.usersNodeName)
        //.where('organizationId', isEqualTo: registeredOrganization.value?.id)
        .where('userType', isNotEqualTo: UserType.employer.toString())
        .withConverter(
          fromFirestore: UsersModel.fromFirestore,
          toFirestore: (UsersModel user, _) => user.toJson(),
        );
    final docSnap = await ref.get();
    if (docSnap.docs.isNotEmpty) {
      for (var doc in docSnap.docs) {
        tempUserList.add(doc.data());
      }
      tempUserList.sort((a, b) => a.name!.compareTo(b.name!));
    } else {}
    userList(tempUserList);
    isLoading(false);

    //return userList;
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
      firestoreController.updateUser(user: UsersModel(userId: ref.id));
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
      final ref = firestoreInstance
          .collection(Constants.organizationNodeName)
          .doc(firestoreController.registeredOrganization.value?.id)
          .collection(Constants.usersNodeName)
          .doc()
          .withConverter(
            fromFirestore: UsersModel.fromFirestore,
            toFirestore: (UsersModel user, _) => user.toJson(),
          );
      await ref.set(user);
      if (kDebugMode) {
        debugPrint('New user Id added = ${ref.id}');
      }
      //update userId of the user
      firestoreController.updateUser(user: UsersModel(userId: ref.id));
    } on FirebaseException catch (e) {
      errorController.getErrorMsg(e);
      if (kDebugMode) {
        print('Error:${e.toString()}');
      }
    }
    //setUserCountForOrganization();
    //firestoreController.userList.add(user);
    //firestoreController.getAllUsers();

    isLoading.value = false;
  }

  //update user details
  Future<void> updateUser({required UsersModel user}) async {
    isLoading.value = true;

    if (kDebugMode) {
      debugPrint('Updating user details in firestore...');
    }
    try {
      final ref = firestoreInstance
          .collection(Constants.organizationNodeName)
          .doc(firestoreController.registeredOrganization.value?.id)
          .collection(Constants.usersNodeName)
          .doc(user.userId)
          .withConverter(
            fromFirestore: UsersModel.fromFirestore,
            toFirestore: (UsersModel user, _) => user.toJson(),
          );
      if (user.firebaseUserId != null) {
        ref.update({'firebaseUserId': '${user.firebaseUserId}'});
      }
      if (user.userId != null) {
        ref.update({'userId': '${user.userId}'});
      }
      if (user.name != null) {
        ref.update({'name': '${user.name}'});
      }
      if (user.phoneNum != null) {
        ref.update({'phoneNum': '${user.phoneNum}'});
      }
      if (user.organizationId != null) {
        ref.update({'organizationId': '${user.organizationId}'});
      }
      if (user.userType != null) {
        ref.update({'userType': '${user.userType}'});
      }
      if (user.isActive != null) {
        ref.update({'isActive': user.isActive});
      }
      if (user.salary != null) {
        ref.update({'salary': user.salary});
      }
      if (user.profilePicPath != null) {
        ref.update({'profilePicPath': '${user.profilePicPath}'});
      }
      if (user.idCardFrontPath != null) {
        ref.update({'idCardFrontPath': '${user.idCardFrontPath}'});
      }
      if (user.idCardBackPath != null) {
        ref.update({'idCardBackPath': '${user.idCardBackPath}'});
      }
      if (user.embeddings != null) {
        ref.update({'embeddings': '${user.embeddings}'});
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
  Future<OrganizationModel?> getOrganization(
/* String? orgId,
    UsersModel? user,
    GetOptions? getOptions,*/
      ) async {
    isLoading.value = true;

    OrganizationModel? tempOrganization;
    if (kDebugMode) {
      debugPrint('Fetching registered organization details from firestore...');
    }
    DocumentReference<OrganizationModel> ref;
    try {
      ref = firestoreInstance
          .collection(Constants.organizationNodeName)
          .doc(authController.firebaseUser.value?.uid)
          .withConverter(
            fromFirestore: OrganizationModel.fromFirestore,
            toFirestore: (OrganizationModel user, _) => user.toJson(),
          );

      /*if (orgId != null) {
        ref = firestoreInstance
            .collection("organizations")
            .where('id', isEqualTo: orgId)
            .withConverter(
              fromFirestore: OrganizationModel.fromFirestore,
              toFirestore: (OrganizationModel user, _) => user.toJson(),
            );
      }*/ /* else {
        ref = firestoreInstance
            .collection("organizations")
            .where('id', isEqualTo: user?.organizationId)
            .withConverter(
              fromFirestore: OrganizationModel.fromFirestore,
              toFirestore: (OrganizationModel user, _) => user.toJson(),
            );
      }*/

      final docSnap =
          await ref.get(/*const GetOptions(source: Source.serverAndCache)*/);
      /*print(docSnap.data());*/
      /*if (docSnap.data()) {
        tempOrganization = docSnap.docs[0].data();
        //tempUser.setUid(authController.firebaseUser.value!.uid);
      }*/ /*else {}*/
      tempOrganization = docSnap.data();
      registeredOrganization(tempOrganization);
    } on FirebaseException catch (e) {
      // TODO
      errorController.getErrorMsg(e);

      if (kDebugMode) {
        print('Error:${e.toString()}');
      }
    }
    isLoading.value = false;
    return tempOrganization;
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
      final ref = firestoreInstance
          .collection(Constants.organizationNodeName)
          .doc(newOrganization.id)
          .withConverter(
            fromFirestore: OrganizationModel.fromFirestore,
            toFirestore: (OrganizationModel organization, _) =>
                organization.toJson(),
          );
      await ref.set(newOrganization);
      if (kDebugMode) {
        debugPrint('New organization added = ${ref.id}');
      }

      //update orgId on firestore
      /*var tempOrg = OrganizationModel(
          id: registeredUser.value?.userId,
          createdBy: registeredUser.value?.userId);*/
      //print('tempOrg=$tempOrg');
      //updateOrganization(organization: tempOrg);

      /* AlbumOrganization? insertedOrganization =
          await getOrganization(orgId: ref.id);*/

      //Storing
      /* registeredOrganization?.update((org) {
        org?.id = insertedOrganization?.id;
        org?.name = insertedOrganization?.name;
        org?.address = insertedOrganization?.address;
      });*/

      //inserting the newOrganizationId to the user's profile on firestore
      /* UsersModel tempUser = UsersModel(
          userId: registeredUser.value?.userId, organizationId: ref.id);*/
      //print(tempUser);
      /*  updateUser(user: tempUser);*/
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

      registeredOrganization(newOrganization);
      isLoading.value = false;
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
          .collection(Constants.organizationNodeName)
          .doc(organization.id)
          .withConverter(
            fromFirestore: UsersModel.fromFirestore,
            toFirestore: (UsersModel user, _) => user.toJson(),
          );
      if (organization.address != null) {
        ref.update({'address': '${organization.address}'});
      }
      if (organization.createdBy != null) {
        ref.update({'createdBy': '${organization.createdBy}'});
      }
      if (organization.createdOn != null) {
        ref.update({'createdOn': '${organization.createdOn}'});
      }
      if (organization.geoLocationLat != null) {
        ref.update({'geolocationLat': '${organization.geoLocationLat}'});
      }
      if (organization.geoLocationLong != null) {
        ref.update({'geoLocationLong': '${organization.geoLocationLong}'});
      }
      if (organization.id != null) {
        ref.update({'id': '${organization.id}'});
      }
      if (organization.name != null) {
        ref.update({'name': '${organization.name}'});
      }
      if (organization.subscription != null) {
        ref.update({'subscription': '${organization.subscription}'});
      }
      if (organization.profilePicPath != null) {
        ref.update({'profilePicPath': '${organization.profilePicPath}'});
      }

      ref.update({'lastUpdatedOn': '${organization.lastUpdatedOn}'});

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
    firestoreController.getOrganization();
  }

  //update OrganizationId to the user's/creator's profile
  /*Future<void> updateOrganizationIdInCreator(
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
          */ /* await SharedPrefsServices.sharedPrefsInstance
              .storeUserToSharedPrefs(user: currentUser!);*/ /*
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
  }*/

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

  Future<void> storeAttendance(
      {/*required AttendanceModel attendance*/ required String userId,
      required String orgId}) async {
    isLoading(true);
    print('storing attendance...');
    try {
      /*bool isCollectionExists = await firestoreInstance
          .collection('attendance')
          .doc(orgId)
          .get()
          .then((val) => (val));*/
      var temp = firestoreInstance
              .collection(Constants.organizationNodeName)
              .doc(firestoreController.registeredOrganization.value?.id)
              .collection(Constants.usersNodeName)
              .doc(userId)
              .collection(Constants.attendanceNodeName)
              .doc(DateFormat('dd-MM-y').format(DateTime.now()))
          /*.withConverter(
            fromFirestore: AttendanceModel.fromFirestore,
            toFirestore: (AttendanceModel attendance, _) => attendance.toJson(),
          )*/
          ;
      Map<String, dynamic> attendance = {
        DateFormat('y-M-d H:m').format(DateTime.now()): MarkedBy.user.toString()
      };
      await temp.set(attendance, SetOptions(merge: true));
      //await temp.set({'entries': attendance}, SetOptions(merge: true));
    } on FirebaseException catch (e) {
      errorController.getErrorMsg(e);
      if (kDebugMode) {
        print('Error:${e.toString()}');
      }
    }
    isLoading(false);
    print('attendance stored');
  }

  Future<List<AttendanceModel>> fetchAttendanceDay(
      {required String userId, required DateTime date}) async {
    print('fetching attendance for $userId...');
    List<AttendanceModel> attendance = <AttendanceModel>[];
    try {
      /*bool isCollectionExists = await firestoreInstance
          .collection('attendance')
          .doc(orgId)
          .get()
          .then((val) => (val));*/

      //AttendanceModel fetchedAttendance;
      var ref = firestoreInstance
              .collection(Constants.organizationNodeName)
              .doc(firestoreController.registeredOrganization.value?.id)
              .collection(Constants.usersNodeName)
              .doc(userId)
              .collection(Constants.attendanceNodeName)
              .doc(DateFormat('dd-MM-y').format(date))
          /*.withConverter(
            fromFirestore: AttendanceModel.fromFirestore,
            toFirestore: (AttendanceModel attendance, _) => attendance.toJson(),
          )*/
          ;
      var docSnap = await ref.get();
      print(docSnap.data());
      if (docSnap.data() != null) {
        docSnap.data()?.forEach((key, value) =>
            attendance.add(AttendanceModel.fromJson({key: value})));
      }
      //print(attendance);
      /* print(doc.data());
      print(doc.exists);*/
      /*if (doc.exists) {
          final data = doc.data() as Map<String, dynamic>;
          attendance.add(AttendanceModel.fromJson(data));
          print(attendance);
        }*/

      //print('attendance=${att.data()}');
    } on FirebaseException catch (e) {
      errorController.getErrorMsg(e);
      if (kDebugMode) {
        print('Error:${e.toString()}');
      }
    }
    return attendance;
  }
}
