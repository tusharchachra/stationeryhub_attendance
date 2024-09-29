import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

import '../models/user_attendance_model.dart';

class ApiService {
  Future<List<AttendanceModel>> fetchAttendance(
      {String? empId, DateTime? startDate, String? endDate}) async {
    ///Fetches attendance based on the arguments
    ///
    /// fetch by employee Id -> pass only `empId`
    /// fetch for one date -> pass only `startDate`
    /// fetch by employee Id for one date -> pass `empId` and `startDate`
    /* final employeeAttendanceCardController =
        Get.put(EmployeeAttendanceCardController());*/
    /*Database db = await instance.database;
    String query = 'SELECT * FROM employeeattendance WHERE empid = $id';
    return await db.rawQuery(query);*/
    String url = 'https://www.aayaam3d.com/api/viewAttendance/';
    try {
      /*if (empId != null || startDate != null || endDate != null) {
        url += '?';
        if (empId != null) url += 'empId=$empId&';
        if (startDate != null) url += 'startDate=$startDate&';
        if (endDate != null) url += 'endDate=$endDate';
      }*/
      var response;

      if (empId != null && startDate == null && endDate == null) {
        response = await http.get(Uri.parse('$url?empId=$empId'));
      } else if (empId == null && startDate != null && endDate == null) {
        print(startDate.toString());
        response =
            await http.get(Uri.parse('$url?date=${(startDate).toString()}'));
      } else if (empId != null && startDate != null && endDate == null) {
        /*response =
            await http.get(Uri.parse('$url?empId=$empId&date=${(startDate)}'));*/
        var temp = {
          'empId': empId,
          'date': DateFormat('y-MM-d').format(startDate)
        };
        //print(startDate.toString());
        var body = jsonEncode(temp);
        print(body);
        response = await http.post(Uri.parse(url),
            headers: {
              "Content-Type": "application/json",
            },
            body: body);
      }
      print(response.statusCode);
      print(response.body);
      if (response.statusCode == 200) {
        var jsonData = json.decode(response.body);
        List<AttendanceModel> attendanceRecord = [];
        for (var data in jsonData) {
          attendanceRecord.add(AttendanceModel.fromJson(data));
        }

        print(attendanceRecord);
        return attendanceRecord;
      } else {
        //throw Exception('Failed to load attendance');
      }
    } on Exception catch (e) {
      // TODO handle ui based on exception
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
