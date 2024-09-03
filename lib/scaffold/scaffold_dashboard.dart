import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stationeryhub_attendance/helpers/constants.dart';

class ScaffoldDashboard extends StatelessWidget {
  final Widget bodyWidget;
  final Widget? leadingWidget;
  final List<Widget>? appBarActions;
  final bool isLoading;
  final String pageTitle;
  final String? pageSubtitle;
  final Widget? bottomNavigationBar;
  final BoxDecoration? scaffoldDecoration;
  final TextStyle? appBarTextStyle;
  const ScaffoldDashboard({
    super.key,
    required this.bodyWidget,
    this.appBarActions,
    required this.isLoading,
    required this.pageTitle,
    this.bottomNavigationBar,
    this.scaffoldDecoration,
    this.appBarTextStyle,
    this.pageSubtitle,
    this.leadingWidget,
  });

  @override
  Widget build(BuildContext context) {
    var title = RichText(
      textAlign: TextAlign.start,
      text: TextSpan(
          text: pageTitle,
          style: Get.textTheme.bodyMedium,
          children: <TextSpan>[
            TextSpan(
              text: pageSubtitle,
              style: Get.textTheme.bodySmall,
            ),
          ]),
    );

    return Scaffold(
      backgroundColor: colourScaffoldBackground,
      appBar: AppBar(
        backgroundColor: colourPrimary,
        leading: leadingWidget,
        title: title,
        actions: appBarActions ?? [],
      ),
      body: bodyWidget,
      bottomNavigationBar: bottomNavigationBar,
    );
  }
}
