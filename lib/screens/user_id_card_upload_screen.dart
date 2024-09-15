import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:stationeryhub_attendance/controllers/id_card_capture_controller.dart';
import 'package:stationeryhub_attendance/helpers/constants.dart';
import 'package:stationeryhub_attendance/scaffold/scaffold_dashboard.dart';

class UserIdCardUploadScreen extends StatelessWidget {
  const UserIdCardUploadScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final cardController = Get.put(IdCardCaptureController());

    return ScaffoldDashboard(
      isLoading: false,
      pageTitle: 'Upload ID',
      bodyWidget: SizedBox.expand(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            buildCardBox(cardController: cardController, text: 'Front'),
            buildCardBox(cardController: cardController, text: 'Back'),
          ],
        ),
      ),
    );
  }

  Stack buildCardBox(
      {required IdCardCaptureController cardController, required String text}) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          width: 366.w,
          height: 247.h,
          color: Constants.colourIdCardBackground,
          child: Center(
            child: Text(
              text,
              style: Get.textTheme.displaySmall
                  ?.copyWith(color: Constants.colourTextLight),
            ),
          ),
        ),
        Positioned(
          right: -10,
          top: -10,
          child: GestureDetector(
            onTap: () {
              cardController.scan();
            },
            child: Container(
              width: 32.w,
              height: 32.h,
              // alignment: Alignment.centerRight,
              padding: EdgeInsets.all(5.w),
              decoration: const BoxDecoration(
                color: Constants.colourPrimary,
                shape: BoxShape.circle,
              ),
              child: const FittedBox(
                fit: BoxFit.fill,
                child: Icon(
                  Icons.delete,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        )
      ],
    );
  }
}
