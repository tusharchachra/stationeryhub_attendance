import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:stationeryhub_attendance/form_fields/form_field_button.dart';
import 'package:stationeryhub_attendance/scaffold/scaffold_home.dart';

class NewOrganizationScreen extends StatefulWidget {
  const NewOrganizationScreen({super.key});

  @override
  State<NewOrganizationScreen> createState() => _NewOrganizationScreenState();
}

class _NewOrganizationScreenState extends State<NewOrganizationScreen> {
  bool isLoading = false;
  TextEditingController nameController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController geoLocationController = TextEditingController();
  Position? _currentPosition;
  @override
  Widget build(BuildContext context) {
    return ScaffoldHome(
      isLoading: isLoading,
      pageTitle: 'New',
      bodyWidget: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          TextFormField(
            controller: nameController,
            decoration: InputDecoration(
              label: Text('Organization Name'),
            ),
          ),
          TextFormField(
            controller: addressController,
            decoration: InputDecoration(
              label: Text('Address'),
            ),
          ),
          TextFormField(
            controller: geoLocationController,
            decoration: InputDecoration(
              label: Text('Geo location'),
            ),
          ),
          FormFieldButton(
              width: 30,
              height: 10,
              buttonText: 'Fetch location',
              onTapAction: () async {
                await _getCurrentPosition();
                print(_currentPosition);
              },
              buttonDecoration: BoxDecoration(),
              textStyle: TextStyle())
        ],
      ),
    );
  }

  Future<bool> _handleLocationPermission() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text(
              'Location services are disabled. Please enable the services')));
      return false;
    }
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Location permissions are denied')));
        return false;
      }
    }
    if (permission == LocationPermission.deniedForever) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text(
              'Location permissions are permanently denied, we cannot request permissions.')));
      return false;
    }
    return true;
  }

  Future<void> _getCurrentPosition() async {
    final hasPermission = await _handleLocationPermission();
    if (!hasPermission) return;
    await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high)
        .then((Position position) {
      setState(() => _currentPosition = position);
    }).catchError((e) {
      debugPrint(e);
    });
  }
}
