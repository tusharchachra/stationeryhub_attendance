import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CheckeredBoxPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    /*   double sh = size.height; // for convenient shortage
    double sw = size.width; // for convenient shortage
    double cornerSide = 0.5.w; // desirable value for corners side*/
    double boxHeight = 0.12.sh;
    double boxWidth = 0.25.sw;

    Paint paintBorder = Paint()
      ..color = Colors.white
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    for (int i = 0; i < 3; i++) {
      for (int j = 0; j < 3; j++) {
        canvas.drawRect(
            Rect.fromLTWH(i * boxWidth, j * boxHeight, boxWidth, boxHeight),
            paintBorder);
      }
    }
  }

  @override
  bool shouldRepaint(CheckeredBoxPainter oldDelegate) => false;

  @override
  bool shouldRebuildSemantics(CheckeredBoxPainter oldDelegate) => false;
}
