import 'package:flutter/material.dart';

class ScreenSplash extends StatelessWidget {
  const ScreenSplash({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Image.asset('/assets/images/map.png'),
    );
  }
}
