import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:stationeryhub_attendance/form_fields/form_field_button.dart';
import 'package:stationeryhub_attendance/scaffold/scaffold_home.dart';
import 'package:stationeryhub_attendance/services/location_handler.dart';

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
  Position? currentPosition;

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
                currentPosition = await LocationHandler.locationHandlerInstance
                    .getCurrentPosition();
                setState(() {
                  currentPosition;
                });
                if (currentPosition == null && context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                      content:
                          Text('Please check location permission and retry')));
                } else {
                  geoLocationController.text = currentPosition.toString();
                }
              },
              buttonDecoration: BoxDecoration(),
              textStyle: TextStyle()),
        ],
      ),
    );
  }
}
