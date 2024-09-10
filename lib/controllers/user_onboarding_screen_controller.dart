import 'package:flutter/material.dart';
import 'package:get/get.dart';

class UserOnboardingScreenController extends GetxController {
  Rx<TextEditingController> nameController = TextEditingController().obs;
  Rx<TextEditingController> phoneNumController = TextEditingController().obs;
  Rx<TextEditingController> userTypeController = TextEditingController().obs;
}
