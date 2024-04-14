import 'package:flutter/material.dart';
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
          )
        ],
      ),
    );
  }
}
