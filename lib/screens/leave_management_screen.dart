import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stationeryhub_attendance/controllers/leave_management_screen_controller.dart';
import 'package:stationeryhub_attendance/scaffold/scaffold_dashboard.dart';

enum LeaveApplicationType { requests, approved, rejected }

class LeaveManagementScreen extends StatelessWidget {
  const LeaveManagementScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final leaveManagementScreenController =
        Get.put(LeaveManagementScreenController());
    return ScaffoldDashboard(
        pageTitle: Text(
          'Leave requests',
          style: Get.textTheme.displaySmall?.copyWith(color: Colors.white),
        ),
        bodyWidget: Container());
  }
}
