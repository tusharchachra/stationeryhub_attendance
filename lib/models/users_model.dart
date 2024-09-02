import 'package:cloud_firestore/cloud_firestore.dart';

import './user_type_enum.dart';

class AlbumUsers {
  String? firebaseUserId;
  UserType? userType;
  String? name;
  String? phoneNum;
  String? organizationId;
  String? userId;

  AlbumUsers({
    this.firebaseUserId,
    this.userId,
    this.userType,
    this.name,
    this.phoneNum,
    this.organizationId,
  });

  factory AlbumUsers.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
    SnapshotOptions? options,
  ) {
    final data = snapshot.data();
    return AlbumUsers(
        firebaseUserId: data?['firebaseUserId'],
        userId: data?['userId'],
        name: data?['name'],
        userType: UserType.values.byName(data!['userType']),
        phoneNum: data['phoneNum'],
        organizationId: data['organizationId']);
  }

  AlbumUsers.fromJson(Map<String, dynamic> json)
      : firebaseUserId = json['firebaseUserId'].toString() == ''
            ? ''
            : json['firebaseUserId'].toString(),
        userId =
            json['userId'].toString() == '' ? '' : json['userId'].toString(),
        name =
            json['name'].toString() == '' ? 'Guest' : json['name'].toString(),
        //json returns "UserType.admin" hence splitting the string to get the exact enum
        userType = UserType.values.byName(json['userType']),
        phoneNum = json['phoneNum'].toString() == ''
            ? ''
            : json['phoneNum'].toString(),
        organizationId = json['organizationId'].toString() == ''
            ? ''
            : json['organizationId'].toString();

  Map<String, dynamic> toJson() => {
        'firebaseUserId': firebaseUserId ?? 'null',
        'userId': userId ?? 'null',
        'userType': userType?.name,
        'name': name,
        'phoneNum': phoneNum,
        'organizationId': organizationId ?? 'null',
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
