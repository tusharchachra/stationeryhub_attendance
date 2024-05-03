import 'package:cloud_firestore/cloud_firestore.dart';

class AlbumEmployeeAttendanceUsers {
  final int userId;
  final String name;
  final int phoneNum;
  final bool isAuthorised;
  final String accessLevel;

  AlbumEmployeeAttendanceUsers(
      {required this.userId,
      required this.name,
      required this.phoneNum,
      required this.isAuthorised,
      required this.accessLevel});

  factory AlbumEmployeeAttendanceUsers.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
    SnapshotOptions? options,
  ) {
    final data = snapshot.data();
    return AlbumEmployeeAttendanceUsers(
        userId: data?['user_id'],
        name: data?['name'],
        phoneNum: data?['phone_num'],
        isAuthorised: data?['is_authorised'],
        accessLevel: data?['access_level']);
  }

  Map<String, dynamic> toFirestore() {
    return {
      "name": name,
      "user_id": userId,
      "phone_num": phoneNum,
      "is_authorised": isAuthorised,
      "access_level": accessLevel
    };
  }

  /*AlbumEmployeeAttendanceUsers.fromFirestore(Map<String, dynamic> json)
      : userId = int.parse(json['user_id']),
        name = json['name'].toString(),
        phoneNum = int.parse(json['phone_num']),
        isAuthorised = bool.parse(json['is_authorised']),
        accessLevel = json['access_level'].toString();*/
  @override
  String toString() {
    // TODO: implement toString
    return super.toString();
  }
}
