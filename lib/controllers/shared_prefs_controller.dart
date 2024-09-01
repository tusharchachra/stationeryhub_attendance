import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/organizations_model.dart';
import '../models/users_model.dart';

class SharedPrefsController extends GetxController {
  static SharedPrefsController sharedPrefsController = Get.find();

  //clear the shared prefs data
  Future<void> clearSharedPrefs() async {
    if (kDebugMode) {
      print('Clearing shared preferences...');
    }
    final prefs = await SharedPreferences.getInstance();
    prefs.clear();
  }

  //Check if shared preferences has the 'key'
  Future<bool> isKeyExists({required key}) async {
    if (kDebugMode) {
      print('Searching shared preference $key...');
    }
    final prefs = await SharedPreferences.getInstance();
    if (kDebugMode) {
      if (prefs.containsKey(key)) {
        print('$key found');
      } else {
        print('$key not found');
      }
    }
    return prefs.containsKey(key);
  }

  Future<void> storeUserToSharedPrefs({required AlbumUsers? user}) async {
    if (kDebugMode) {
      debugPrint('Storing registered user to Shared Prefs...');
    }
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    bool result = await prefs.setString('user', jsonEncode(user));
    if (result && kDebugMode) {
      debugPrint("Current user stored in shared preference");
    }
  }

  Future<AlbumUsers> getUserFromSharedPrefs() async {
    if (kDebugMode) {
      debugPrint('Fetching registered user from Shared Prefs...');
    }
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    /*String user =
        jsonEncode(AlbumUsers.fromJson(user));*/
    var fetchedUser = prefs.getString('user');
    return AlbumUsers.fromJson(jsonDecode(fetchedUser!));
  }

  Future<void> storeOrganizationToSharedPrefs(
      {required AlbumOrganization organization}) async {
    if (kDebugMode) {
      debugPrint('Storing organization to Shared Prefs...');
    }
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    bool result =
        await prefs.setString('organization', jsonEncode(organization));
    if (result) {
      if (kDebugMode) {
        print("current organization stored in shared preference");
      }
    }
  }

  Future<AlbumOrganization> getOrganizationFromSharedPrefs() async {
    if (kDebugMode) {
      debugPrint('Fetching organization from Shared Prefs...');
    }
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    /*String user =
        jsonEncode(AlbumUsers.fromJson(user));*/
    var fetchedOrganization = prefs.getString('organization');
    return AlbumOrganization.fromJson(jsonDecode(fetchedOrganization!));
  }
}
