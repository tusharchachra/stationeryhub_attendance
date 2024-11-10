import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stationeryhub_attendance/scaffold/scaffold_dashboard.dart';

class SalaryManagementScreen extends StatelessWidget {
  const SalaryManagementScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ScaffoldDashboard(
      pageTitle: Text(
        'Manage Salary',
        style: Get.textTheme.displaySmall?.copyWith(color: Colors.white),
      ),
      bodyWidget: Container(),
    );
  }
}
