import 'package:get/get.dart';
import 'package:stationeryhub_attendance/translations/en.dart';
import 'package:stationeryhub_attendance/translations/hi.dart';

class Languages extends Translations {
  @override
  Map<String, Map<String, String>> get keys => {
        'en': En().en,
        'hi': Hi().hi,
      };
}
