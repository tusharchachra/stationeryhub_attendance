import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../helpers/constants.dart';

class FilterButton extends StatelessWidget {
  const FilterButton({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image.asset('assets/images/generic/filterIcon.png'),
        SizedBox(width: 10.w),
        Text(
          'Filter',
          style: Get.textTheme.headlineMedium!
              .copyWith(color: Constants.colourTextDark),
        ),
      ],
    );
  }
}
