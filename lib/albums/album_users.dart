import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:stationeryhub_attendance/albums/enum_user_type.dart';

class AlbumUsers {
  String? uid;
  final UserType? userType;
  final String name;
  final String phoneNum;
  final String? organizationId;

  AlbumUsers({
    this.uid,
    this.userType,
    required this.name,
    required this.phoneNum,
    this.organizationId,
  });

  factory AlbumUsers.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
    SnapshotOptions? options,
  ) {
    final data = snapshot.data();
    return AlbumUsers(
        uid: data?['uid'],
        name: data?['name'],
        userType: UserType.values.byName(data?['userType']),
        phoneNum: data?['phoneNum'],
        organizationId: data?['organizationId']);
  }
  AlbumUsers.fromJson(Map<String, dynamic> json)
      : uid = json['uid'].toString() == '' ? '' : json['uid'].toString(),
        name = json['name'].toString() == '' ? '' : json['name'].toString(),
        userType = UserType.values.byName(json['userType']),
        phoneNum = json['phoneNum'].toString() == ''
            ? ''
            : json['phoneNum'].toString(),
        organizationId = json['organizationId'].toString() == ''
            ? ''
            : json['organizationId'].toString();

  Map<String, dynamic> toJson() => {
        'uid': uid ?? 'null',
        'userType': userType.toString(),
        'name': name,
        'phoneNum': phoneNum,
        'organizationId': organizationId ?? 'null',
      };

  void setUid(String id) {
    uid = id;
  }

  @override
  String toString() {
    // TODO: implement toString
    return toJson().toString();
  }
}
