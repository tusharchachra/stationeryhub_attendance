class AlbumUsers {
  String uid;
  final String category;
  final String name;
  final String phoneNum;

  AlbumUsers({
    required this.uid,
    required this.category,
    required this.name,
    required this.phoneNum,
  });

  Map<String, dynamic> toJson() => {
        'uid': uid,
        'category': category,
        'name': name,
        'phoneNum': phoneNum,
      };

  AlbumUsers.fromJson(Map<String, dynamic> json)
      : uid = json['uid'].toString(),
        name = json['name'].toString(),
        category = json['category'].toString(),
        phoneNum = json['phone_num'];

  /*AlbumUsers.fromJsonNoId(Map<String, dynamic> json)
      : name = json['name'].toString(),
        category = json['category'].toString(),
        phoneNum = json['phone_num'];*/

  void setUid(String id) {
    uid = id;
  }

  @override
  String toString() {
    // TODO: implement toString
    return toJson().toString();
  }
}
