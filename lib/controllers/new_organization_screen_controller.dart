import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

class NewOrganizationScreenController extends GetxController {
  // final formKeyNewOrganization = GlobalKey<FormState>();
  RxBool isFormValid = false.obs;
  RxBool isLoading = false.obs;

  Rx<TextEditingController> addressController = TextEditingController().obs;
  Rx<TextEditingController> nameController = TextEditingController().obs;

  validateName(String? value) {
    String? temp;
    if (value == '') {
      isFormValid.value = false;
      temp = 'Enter a name';
    } else {
      isFormValid.value = true;
    }
    // return temp;
  }

  void resetAll() {
    nameController.value.text = '';
    addressController.value.text = '';
    isLoading.value = false;
  }
}
