import 'dart:convert';

import 'package:http/http.dart' as http;

import '../models/user_attendance_model.dart';

class ApiService {
  Future<List<AttendanceModel>> fetchAttendance(
      {int? empId, DateTime? startDate, String? endDate}) async {
    /* final employeeAttendanceCardController =
        Get.put(EmployeeAttendanceCardController());*/
    /*Database db = await instance.database;
    String query = 'SELECT * FROM employeeattendance WHERE empid = $id';
    return await db.rawQuery(query);*/
    String url = 'https://www.aayaam3d.com/api/viewAttendance';
    try {
      /*if (empId != null || startDate != null || endDate != null) {
        url += '?';
        if (empId != null) url += 'empId=$empId&';
        if (startDate != null) url += 'startDate=$startDate&';
        if (endDate != null) url += 'endDate=$endDate';
      }*/
      var response;

      if (empId != null) {
        response = await http.get(Uri.parse('$url?empId=$empId'));
      } else if (startDate != null) {
        print(startDate.toString());
        response =
            await http.get(Uri.parse('$url?date=${(startDate).toString()}'));
      }
      print(response.statusCode);
      print(response.body);
      if (response.statusCode == 200) {
        List<dynamic> jsonData = json.decode(response.body);
        var attendanceRecord =
            jsonData.map((json) => AttendanceModel.fromJson(json)).toList();

        /*  for (var temp in attendanceRecord) {
        */ /*  print(temp.empId);
          var userRecord =
              await .getUser(temp.empId!);*/ /*
          //print(userRecord?.name);

          attendanceViewList
              .add(AttendanceViewModel(attendance: temp, user: userRecord!));
        }*/
        return attendanceRecord;
      } else {
        //throw Exception('Failed to load attendance');
      }
    } on Exception catch (e) {
      // TODO
      print('Exception: $e');
    }
    return [];
  }

  /*Future<bool> createAttendance(Attendance attendance) async {
    final response = await http.post(
      Uri.parse('$baseUrl/attendance'),
      headers: <String, String>{
        'Content-Type': 'application/json',
      },
      body: json.encode(attendance.toJson()),
    );

    return response.statusCode == 200;
  }*/
}