import 'package:flutter/material.dart';
import 'package:stationeryhub_attendance/scaffold/scaffold_home.dart';

class MarkAttendanceScreen extends StatefulWidget {
  const MarkAttendanceScreen({super.key});

  @override
  State<MarkAttendanceScreen> createState() => _MarkAttendanceScreenState();
}

class _MarkAttendanceScreenState extends State<MarkAttendanceScreen> {
  @override
  Widget build(BuildContext context) {
    return const ScaffoldHome(
        bodyWidget: Text('mark attendance'),
        isLoading: false,
        pageTitle: 'mark attendance');
  }
}
