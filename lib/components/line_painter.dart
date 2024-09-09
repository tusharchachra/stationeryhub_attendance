import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../helpers/constants.dart';

class LinePainter extends CustomPainter {
  final double animationValue; // Animation value to control line position

  LinePainter(this.animationValue);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Constants.colourPrimary // Line color
      ..style = PaintingStyle.stroke // Stroke style
      ..strokeWidth = 6.0; // Stroke width

    const double startY = 0;
    final double endY = size.height;
    const double startX = 0;
    final double endX = size.width;

    final double currentY = startY + (endY - startY) * animationValue;

    // Draw the line
    canvas.drawLine(Offset(startX, currentY), Offset(endX, currentY), paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true; // Repaint the line continuously
  }
}
