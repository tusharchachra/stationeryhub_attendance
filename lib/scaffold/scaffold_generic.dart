import 'package:flutter/material.dart';

import '../helpers/constants.dart';

class ScaffoldGeneric extends StatelessWidget {
  const ScaffoldGeneric(
      {super.key, this.backgroundColour, required this.bodyWidget});

  final Color? backgroundColour;
  final Widget bodyWidget;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColour ?? Constants.colourScaffoldBackground,
      body: bodyWidget,
    );
  }
}
