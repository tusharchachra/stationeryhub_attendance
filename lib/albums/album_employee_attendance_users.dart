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

  AlbumEmployeeAttendanceUsers.fromJson(Map<String, dynamic> json)
      : userId = int.parse(json['user_id']),
        name = json['name'].toString(),
        phoneNum = int.parse(json['phone_num']),
        isAuthorised = bool.parse(json['is_authorised']),
        accessLevel = json['access_level'].toString();

  @override
  String toString() {
    // TODO: implement toString
    return super.toString();
  }
}
