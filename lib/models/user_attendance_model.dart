class AttendanceModel {
  String? empId;
  DateTime? date;
  int? action;

  AttendanceModel({
    this.empId,
    this.action,
    this.date,
  });

  Map<String, dynamic> toJson() => {
        'empId': empId,
        'dateTime': date,
        'action': action,
      };

  AttendanceModel.fromJson(Map<String, dynamic> json)
      : empId = (json['empId']),
        action = int.parse(json['action']),
        date = DateTime.parse(json['date']);

  @override
  String toString() {
    // TODO: implement toString
    return toJson().toString();
  }
}
