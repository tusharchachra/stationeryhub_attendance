import 'package:cloud_firestore/cloud_firestore.dart';

import './user_type_enum.dart';

class UsersModel {
  String? firebaseUserId;
  UserType? userType;
  String? name;
  String? phoneNum;
  String? organizationId;
  String? userId;
  String? profilePicPath;
  String? idCardFrontPath;
  String? idCardBackPath;
  bool? isActive;
  int? salary; //per month

  UsersModel({
    this.firebaseUserId,
    this.userId,
    this.userType,
    this.name,
    this.phoneNum,
    this.organizationId,
    this.profilePicPath,
    this.idCardFrontPath,
    this.idCardBackPath,
    this.isActive,
    this.salary,
  });

  factory UsersModel.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
    SnapshotOptions? options,
  ) {
    final data = snapshot.data();
    return UsersModel(
      firebaseUserId: data?['firebaseUserId'],
      userId: data?['userId'],
      name: data?['name'],
      userType: UserType.values.byName(data!['userType'].split('.').last),
      phoneNum: data['phoneNum'],
      organizationId: data['organizationId'],
      profilePicPath: data['profilePicPath'],
      idCardFrontPath: data['idCardFrontPath'],
      idCardBackPath: data['idCardBackPath'],
      isActive: (data['isActive']),
      salary: (data['salary']),
    );
  }

  UsersModel.fromJson(Map<String, dynamic> json)
      : firebaseUserId = json['firebaseUserId'].toString() == ''
            ? ''
            : json['firebaseUserId'].toString(),
        userId =
            json['userId'].toString() == '' ? '' : json['userId'].toString(),
        name =
            json['name'].toString() == '' ? 'Guest' : json['name'].toString(),
        //json returns "UserType.admin" hence splitting the string to get the exact enum
        userType = UserType.values.byName(json['userType'].split('.').last),
        phoneNum = json['phoneNum'].toString() == ''
            ? ''
            : json['phoneNum'].toString(),
        organizationId = json['organizationId'].toString() == ''
            ? ''
            : json['organizationId'].toString(),
        profilePicPath = json['profilePicPath'].toString() == ''
            ? ''
            : json['profilePicPath'].toString(),
        idCardFrontPath = json['idCardFrontPath'].toString() == ''
            ? ''
            : json['idCardFrontPath'].toString(),
        idCardBackPath = json['idCardBackPath'].toString() == ''
            ? ''
            : json['idCardBackPath'].toString(),
        isActive =
            json['isActive'].toString() == '' ? true : (json['isActive']),
        salary = json['salary'].toString() == '' ? 0 : (json['salary']);

  Map<String, dynamic> toJson() => {
        'firebaseUserId': firebaseUserId ?? 'null',
        'userId': userId ?? 'null',
        'userType': userType.toString(),
        'name': name,
        'phoneNum': phoneNum,
        'organizationId': organizationId ?? '',
        'profilePicPath': profilePicPath ?? '',
        'idCardFrontPath': idCardFrontPath ?? '',
        'idCardBackPath': idCardBackPath ?? '',
        'isActive': isActive ?? true,
        'salary': salary ?? 0
      };

  /*void setUid(String id) {
    firebaseUserId = id;
  }*/

  @override
  String toString() {
    // TODO: implement toString
    return toJson().toString();
  }
}
