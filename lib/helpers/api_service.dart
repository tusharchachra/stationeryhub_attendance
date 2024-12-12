import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:stationeryhub_attendance/models/attendance_count_model.dart';

import '../models/attendance_model_old.dart';

class ApiService {
  Future<List<AttendanceModelOld>> fetchAttendance(
      {String? empId,
      DateTime? startDate,
      DateTime? endDate,
      bool? getCount}) async {
    ///Fetches attendance based on the arguments
    ///
    /// fetch by employee Id -> pass only `empId`
    /// fetch for all on one date -> pass only `startDate`
    /// fetch by employee Id for one date -> pass `empId` and `startDate`
    /// fetch by employee Id for between dates -> pass `empId`, `startDate` and `endDate`
    /// fetch attendance count for empId between dates pass `empId`, `startDate`, `endDate` and `getCount=true`
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

      //by empId
      if (empId != null &&
          startDate == null &&
          endDate == null &&
          getCount == null) {
        response = await http.get(Uri.parse('$url?empId=$empId'));
      }
      //all for one date
      else if (empId == null &&
          startDate != null &&
          endDate == null &&
          getCount == null) {
        print(startDate.toString());
        response =
            await http.get(Uri.parse('$url?date=${(startDate).toString()}'));
      }
      //for one employee on one date
      else if (empId != null &&
          startDate != null &&
          endDate == null &&
          getCount == null) {
        /*response =
            await http.get(Uri.parse('$url?empId=$empId&date=${(startDate)}'));*/
        var temp = {
          'empId': empId,
          'startDate': DateFormat('y-MM-dd').format(startDate)
        };
        //print(startDate.toString());
        var body = jsonEncode(temp);
        print('body=$body');
        response = await http.post(Uri.parse(url),
            headers: {
              "Content-Type": "application/json",
            },
            body: body);
      }
      //for one employee between start and end date
      else if (empId != null &&
          startDate != null &&
          endDate != null &&
          getCount == false) {
        /*response =
            await http.get(Uri.parse('$url?empId=$empId&date=${(startDate)}'));*/
        var temp = {
          'empId': empId,
          'startDate': DateFormat('y-MM-dd').format(startDate),
          'endDate': DateFormat('y-MM-dd').format(endDate)
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

      //get count for one employee between start and end date
      else if (empId != null &&
          startDate != null &&
          endDate != null &&
          getCount == true) {
        /*response =
            await http.get(Uri.parse('$url?empId=$empId&date=${(startDate)}'));*/
        var temp = {
          'empId': empId,
          'startDate': DateFormat('y-MM-dd').format(startDate),
          'endDate': DateFormat('y-MM-dd').format(endDate),
          'getCount': true,
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

      print('responseCode=${response.statusCode}');
      print('responseBody=${response.body}');
      if (response.statusCode == 200) {
        var jsonData = json.decode(response.body);
        List<AttendanceModelOld> attendanceRecord = [];
        for (var data in jsonData) {
          attendanceRecord.add(AttendanceModelOld.fromJson(data));
        }

        print('attendanceRecord=$attendanceRecord');
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

  Future<List<AttendanceCountModel>> fetchAttendanceCount(
      {String? empId,
      DateTime? startDate,
      DateTime? endDate,
      bool? getCount}) async {
    /// fetch attendance count for empId between dates pass `empId`, `startDate`, `endDate` and `getCount=true`
    String url = 'https://www.aayaam3d.com/api/viewAttendance/';
    try {
      var response;

      //get count for one employee between start and end date
      if (empId != null &&
          startDate != null &&
          endDate != null &&
          getCount == true) {
        /*response =
            await http.get(Uri.parse('$url?empId=$empId&date=${(startDate)}'));*/
        var temp = {
          'empId': empId,
          'startDate': DateFormat('y-MM-dd').format(startDate),
          'endDate': DateFormat('y-MM-dd').format(endDate),
          'getCount': true,
        };
        //print(startDate.toString());
        var body = jsonEncode(temp);
        //print(body);
        response = await http.post(Uri.parse(url),
            headers: {
              "Content-Type": "application/json",
            },
            body: body);
      }

      print('responseCode=${response.statusCode}');
      print('responseBody=${response.body}');
      if (response.statusCode == 200) {
        var jsonData = json.decode(response.body);
        List<AttendanceCountModel> attendanceCount = [];
        for (var data in jsonData) {
          attendanceCount.add(AttendanceCountModel.fromJson(data));
        }
        //print('attendanceCountList=$attendanceCount');
        return attendanceCount;
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
