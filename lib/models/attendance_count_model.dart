///Model class for att count of empId on a date
library;

class AttendanceCountModel {
  final String? empId;
  final DateTime date;
  final double count;

  AttendanceCountModel(this.date, this.count, this.empId);

  Map<String, dynamic> toJson() {
    return {
      'empId': empId,
      'date': date,
      'count': count,
    };
  }

  AttendanceCountModel.fromJson(Map<String, dynamic> json)
      : empId = json['empId'].toString(),
        date = DateTime.parse(json['date'].toString()),
        count = double.parse(json['count']);

  @override
  String toString() {
    // TODO: implement toString
    return toJson().toString();
  }
}
