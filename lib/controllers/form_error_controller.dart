import 'package:get/get.dart';

class FormErrorController extends GetxController {
  RxList errors = [].obs;

  @override
  void onReady() {
    // TODO: implement onReady
    resetErrors();
    super.onReady();
  }

  @override
  void onClose() {
    // TODO: implement onClose
    resetErrors();
    super.onClose();
  }

  void resetErrors() {
    errors.clear();
  }
}
