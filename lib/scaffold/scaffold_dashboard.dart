import 'package:flutter/material.dart';
import 'package:stationeryhub_attendance/helpers/constants.dart';

class ScaffoldDashboard extends StatelessWidget {
  final Widget? leadingWidget;
  final List<Widget>? appBarActions;
  final bool? isLoading;
  final Widget? pageTitle;
  //final String? pageSubtitle;
  final Widget bodyWidget;
  final Widget? bottomNavigationBar;
  final BoxDecoration? scaffoldDecoration;
  final TextStyle? appBarTextStyle;
  final Color? backgroundColour;
  const ScaffoldDashboard({
    super.key,
    this.appBarActions,
    this.isLoading,
    required this.pageTitle,
    //this.pageSubtitle,
    required this.bodyWidget,
    this.bottomNavigationBar,
    this.scaffoldDecoration,
    this.appBarTextStyle,
    this.leadingWidget,
    this.backgroundColour,
  });

  @override
  Widget build(BuildContext context) {
    /* var title = RichText(
      textAlign: TextAlign.start,
      text: TextSpan(
          text: pageTitle,
          style: Get.textTheme.headlineLarge?.copyWith(color: Colors.white),
          children: <TextSpan>[
            TextSpan(
              text: pageSubtitle,
              style: Get.textTheme.titleMedium?.copyWith(color: Colors.white),
            ),
          ]),
    );*/

    return Scaffold(
      backgroundColor: backgroundColour ?? Constants.colourScaffoldBackground,
      appBar: AppBar(
        backgroundColor: Constants.colourPrimary,
        leading: leadingWidget,
        title: pageTitle,
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.more_vert),
            color: Colors.white,
          )
        ],
      ),
      body: bodyWidget,
      bottomNavigationBar: bottomNavigationBar,
    );
  }
}
