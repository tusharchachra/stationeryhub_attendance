import 'dart:io';

import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:stationeryhub_attendance/models/user_attendance_model.dart';

import 'constants.dart';

class DBHelper {
  DBHelper._privateConstructor();
  static final DBHelper instance = DBHelper._privateConstructor();
  late Database _database;

  Future<Database> get database async {
    /*  if (_database != null) {
      return _database;
    }*/
    _database = await _initiateDB();
    return _database;
  }

  Future<Database> _initiateDB() async {
    //Database d;

    Directory directory = await getApplicationDocumentsDirectory();
    String path = join(directory.path, Constants.dbName);
    return await openDatabase(
      path,
      version: Constants.dbVersion, /* onCreate: _onCreate*/
    );
    //return d;
  }

  Future<List<UserAttendanceModel>> fetchAttendanceByUser() {}
  /*Future<List<AlbumEmployeeAttendanceUsers>> fetchUserList() {

  }*/
}
