import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:stationeryhub_attendance/albums/enum_user_type.dart';

class AlbumUsers {
  String? firebaseId;
  UserType? userType;
  String? name;
  String? phoneNum;
  String? organizationId;

  AlbumUsers({
    this.firebaseId,
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
        firebaseId: data?['firebaseId'],
        name: data?['name'],
        userType: UserType.values.byName(data!['userType']),
        phoneNum: data['phoneNum'],
        organizationId: data['organizationId']);
  }

  AlbumUsers.fromJson(Map<String, dynamic> json)
      : firebaseId = json['firebaseId'].toString() == ''
            ? ''
            : json['firebaseId'].toString(),
        name = json['name'].toString() == '' ? '' : json['name'].toString(),
        //json returns "UserType.admin" hence splitting the string to get the exact enum
        userType = UserType.values.byName(json['userType']),
        phoneNum = json['phoneNum'].toString() == ''
            ? ''
            : json['phoneNum'].toString(),
        organizationId = json['organizationId'].toString() == ''
            ? ''
            : json['organizationId'].toString();

  Map<String, dynamic> toJson() => {
        'firebaseId': firebaseId ?? 'null',
        'userType': userType?.name,
        'name': name,
        'phoneNum': phoneNum,
        'organizationId': organizationId ?? 'null',
      };

  /*void setUid(String id) {
    firebaseId = id;
  }*/

  @override
  String toString() {
    // TODO: implement toString
    return toJson().toString();
  }
}
