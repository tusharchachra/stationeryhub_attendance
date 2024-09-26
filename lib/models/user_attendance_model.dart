class UserAttendanceModel {
  String? empId;
  DateTime? date;
  int? action;

  UserAttendanceModel({
    this.empId,
    this.action,
    this.date,
  });

  Map<String, dynamic> toJson() => {
        'empId': empId,
        'dateTime': date,
        'action': action,
      };

  UserAttendanceModel.fromJson(Map<String, dynamic> json)
      : empId = (json['empId']),
        action = int.parse(json['action']),
        date = DateTime.parse(json['date']);
}
