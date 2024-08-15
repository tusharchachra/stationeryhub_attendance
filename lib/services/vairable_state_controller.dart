import 'package:get/get.dart';

class VariableStateController extends GetxController {
  var isPhoneNumValid = false.obs;

  setValidity() => isPhoneNumValid.toggle();
}
