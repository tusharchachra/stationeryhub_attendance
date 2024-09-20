import 'dart:ui';

import 'package:flutter/material.dart';

class DottedBorderPainter extends CustomPainter {
  final double strokeWidth;
  final Color color;
  final double borderRadius;
  final int dashWidth;
  final int dashSpace;

  DottedBorderPainter({
    this.strokeWidth = 2.0,
    this.color = Colors.black,
    this.borderRadius = 8.0,
    this.dashWidth = 8,
    this.dashSpace = 4,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth;

    /* double dashWidth = 8;
    double dashSpace = 4;*/

    // Create the rounded rectangle path
    final RRect rRect = RRect.fromRectAndRadius(
      Rect.fromLTWH(0, 0, size.width, size.height),
      Radius.circular(borderRadius),
    );

    // Create path from rounded rectangle
    final Path path = Path()..addRRect(rRect);

    // Calculate the total length of the path
    PathMetrics metrics = path.computeMetrics();
    for (PathMetric metric in metrics) {
      double length = metric.length;
      for (double i = 0; i < length; i += dashWidth + dashSpace) {
        // Draw the dashes
        canvas.drawLine(
          metric.getTangentForOffset(i)!.position,
          metric.getTangentForOffset(i + dashWidth)!.position,
          paint,
        );
      }
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}
