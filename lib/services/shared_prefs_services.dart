import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stationeryhub_attendance/albums/album_organizations.dart';

import '../albums/album_users.dart';

class SharedPrefsServices {
  SharedPrefsServices._privateConstructor();
  static final SharedPrefsServices sharedPrefsInstance =
      SharedPrefsServices._privateConstructor();

  Future<void> storeUserToSharedPrefs({required AlbumUsers user}) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    /*String user =
        jsonEncode(AlbumUsers.fromJson(user));*/
    bool result = await prefs.setString('user', jsonEncode(user));
    if (result) {
      if (kDebugMode) {
        print("current user stored in shared preference");
      }
    }
  }

  Future<AlbumUsers> getUserFromSharedPrefs() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    /*String user =
        jsonEncode(AlbumUsers.fromJson(user));*/
    var fetchedUser = prefs.getString('user');
    return AlbumUsers.fromJson(jsonDecode(fetchedUser!));
  }

  Future<void> storeOrganizationToSharedPrefs(
      {required AlbumOrganization organization}) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    /*String user =
        jsonEncode(AlbumUsers.fromJson(user));*/
    bool result =
        await prefs.setString('organization', jsonEncode(organization));
    if (result) {
      if (kDebugMode) {
        print("current organization stored in shared preference");
      }
    }
  }

  Future<AlbumOrganization> getOrganizationFromSharedPrefs() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    /*String user =
        jsonEncode(AlbumUsers.fromJson(user));*/
    var fetchedOrganization = prefs.getString('organization');
    return AlbumOrganization.fromJson(jsonDecode(fetchedOrganization!));
  }
}