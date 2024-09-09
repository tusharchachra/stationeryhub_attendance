import 'package:flutter/cupertino.dart';

import 'line_painter.dart';

class LineAnimationView extends StatefulWidget {
  final Size size;

  const LineAnimationView({super.key, required this.size});

  @override
  _LineAnimationViewState createState() => _LineAnimationViewState();
}

class _LineAnimationViewState extends State<LineAnimationView>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this, // Synchronize animation with this widget
      duration: Duration(seconds: 2), // Animation duration
    )..repeat(reverse: true); // Repeat the animation back and forth
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return CustomPaint(
          size: widget.size,
          painter: LinePainter(_controller.value), //
          // Use LinePainter to draw the line
        );
      },
    );
  }

  @override
  void dispose() {
    _controller.dispose(); // Dispose of the animation controller
    super.dispose();
  }
}
