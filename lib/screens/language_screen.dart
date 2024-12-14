import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:stationeryhub_attendance/components/form_field_button.dart';
import 'package:stationeryhub_attendance/helpers/constants.dart';
import 'package:stationeryhub_attendance/scaffold/scaffold_generic.dart';
import 'package:stationeryhub_attendance/screens/role_screen.dart';
import 'package:stationeryhub_attendance/translations/language_keys.dart';
import 'package:stationeryhub_attendance/translations/languages.dart';

class LanguageScreen extends StatefulWidget {
  const LanguageScreen({super.key});

  @override
  State<LanguageScreen> createState() => _LanguageScreenState();
}

class _LanguageScreenState extends State<LanguageScreen> {
  Locale selectedLocale = Get.deviceLocale ?? const Locale('en');
  List<String> languages = [];
  @override
  Widget build(BuildContext context) {
    languages = Languages().keys.keys.toList();
    return ScaffoldGeneric(
      bodyWidget: Padding(
        padding: EdgeInsets.symmetric(horizontal: 37.w, vertical: 35.h),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Wrap(
              crossAxisAlignment: WrapCrossAlignment.center,
              direction: Axis.vertical,
              children: [
                Image.asset('assets/images/language_screen/languageIcon.png'),
                SizedBox(height: 13.h),
                Text(
                  'Select your language',
                  style: Get.textTheme.displayMedium
                      ?.copyWith(color: Constants.colourTextDark),
                ),
              ],
            ),
            GridView.builder(
              shrinkWrap: true,
              itemCount: languages.length,
              scrollDirection: Axis.vertical,
              padding: EdgeInsets.all(10.w),
              gridDelegate:
                  SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
              itemBuilder: (context, index) => Padding(
                padding: EdgeInsets.all(10.w),
                child: buildLanguageCard(
                  localeKey: languages[index],
                ),
              ),
            ),
            FormFieldButton(
                width: 384.w,
                height: 56.h,
                buttonText: 'Continue',
                onTapAction: () {
                  Get.updateLocale(selectedLocale);
                  Get.to(() => const RoleScreen());
                })
          ],
        ),
      ),
    );
  }

  Widget buildLanguageCard({
    required String localeKey,
  }) {
    var temp = Languages()
        .keys
        .entries
        .firstWhere(
          (element) => element.key == localeKey,
        )
        .value;
    return GestureDetector(
      onTap: () {
        selectedLocale = Locale(localeKey);
        setState(() {
          selectedLocale;
        });
      },
      child: Container(
          width: 168.w,
          height: 165.h,
          decoration: BoxDecoration(
            color: selectedLocale == Locale(localeKey)
                ? Constants.colourPrimary
                : Constants.colourBorderDark,
            borderRadius: BorderRadius.circular(11.5.r),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                temp.entries
                    .firstWhere((val) => val.key == LanguageKeys.char)
                    .value,
                style: TextStyle(fontSize: 74.w, color: Colors.white),
              ),
              Text(
                temp.entries
                    .firstWhere((val) => val.key == LanguageKeys.name)
                    .value,
                style: TextStyle(fontSize: 20.w, color: Colors.white),
              ),
              /*Text(name),*/
            ],
          )),
    );
  }
}
