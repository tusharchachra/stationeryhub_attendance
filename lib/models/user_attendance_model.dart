class UserAttendanceModel {
  String? userId;
  DateTime? date;
  int? action;

  UserAttendanceModel({
    this.userId,
    this.action,
    this.date,
  });

  Map<String, dynamic> toJson() => {
        'userId': userId ?? 'null',
        'dateTime': date ?? '',
        'action': action ?? '',
      };

  UserAttendanceModel.fromJson(Map<String, dynamic> json)
      : userId =
            json['userId'].toString() == '' ? '' : json['userId'].toString(),
        action = json['action'].toString() == '' ? '' : json['action'],
        date = json['date'].toString() == '' ? '' : json['date'];
}
