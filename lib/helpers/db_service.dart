import 'dart:convert';

import 'package:http/http.dart' as http;

import '../models/user_attendance_model.dart';
import 'constants.dart';

class ApiService {
  Future<List<UserAttendanceModel>> fetchAttendance(
      {int? userId, String? startDate, String? endDate}) async {
    /*Database db = await instance.database;
    String query = 'SELECT * FROM employeeattendance WHERE empid = $id';
    return await db.rawQuery(query);*/
    String url = '${Constants.webPathAtt}';
    if (userId != null || startDate != null || endDate != null) {
      url += '?';
      if (userId != null) url += 'userId=$userId&';
      if (startDate != null) url += 'startDate=$startDate&';
      if (endDate != null) url += 'endDate=$endDate';
    }
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      List<dynamic> jsonData = json.decode(response.body);
      return jsonData
          .map((json) => UserAttendanceModel.fromJson(json))
          .toList();
    } else {
      throw Exception('Failed to load attendance');
    }
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
