import 'package:flutter/cupertino.dart';
import 'package:geolocator/geolocator.dart';

class LocationHandler {
  LocationHandler._privateConstructor();

  static final LocationHandler locationHandlerInstance =
      LocationHandler._privateConstructor();

  Future<bool> _handleLocationPermission() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return false;
    }
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return false;
      }
    }
    if (permission == LocationPermission.deniedForever) {
      return false;
    }
    return true;
  }

  Future<Position?> getCurrentPosition() async {
    Position? tempPos;
    final hasPermission = await _handleLocationPermission();
    if (hasPermission) {
      await Geolocator.getCurrentPosition(
              desiredAccuracy: LocationAccuracy.high)
          .then((Position position) {
        tempPos = position;
      }).catchError((e) {
        debugPrint(e);
      });
    }
    return tempPos;
  }
}
