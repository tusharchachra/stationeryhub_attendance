import 'package:get/get.dart';
import 'package:stationeryhub_attendance/screens/leave_management_screen.dart';

class LeaveManagementScreenController extends GetxController {
  Rx<LeaveApplicationType> leaveApplicationType =
      LeaveApplicationType.requests.obs;
}
