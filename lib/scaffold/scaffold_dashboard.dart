import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stationeryhub_attendance/helpers/constants.dart';

class ScaffoldDashboard extends StatelessWidget {
  final Widget? leadingWidget;
  final List<Widget>? appBarActions;
  final bool? isLoading;
  final String pageTitle;
  final String? pageSubtitle;
  final Widget bodyWidget;
  final Widget? bottomNavigationBar;
  final BoxDecoration? scaffoldDecoration;
  final TextStyle? appBarTextStyle;
  const ScaffoldDashboard({
    super.key,
    this.appBarActions,
    this.isLoading,
    required this.pageTitle,
    this.pageSubtitle,
    required this.bodyWidget,
    this.bottomNavigationBar,
    this.scaffoldDecoration,
    this.appBarTextStyle,
    this.leadingWidget,
  });

  @override
  Widget build(BuildContext context) {
    var title = RichText(
      textAlign: TextAlign.start,
      text: TextSpan(
          text: pageTitle,
          style: Get.textTheme.bodyLarge,
          children: <TextSpan>[
            TextSpan(
              text: pageSubtitle,
              style: Get.textTheme.bodySmall,
            ),
          ]),
    );

    return Scaffold(
      backgroundColor: Constants.colourScaffoldBackground,
      appBar: AppBar(
        backgroundColor: Constants.colourPrimary,
        leading: leadingWidget,
        title: title,
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
