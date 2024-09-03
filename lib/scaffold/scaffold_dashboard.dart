import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loading_overlay/loading_overlay.dart';
import 'package:stationeryhub_attendance/helpers/constants.dart';

import '../helpers/size_config.dart';

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
    return SafeArea(
      child: Scaffold(
        extendBodyBehindAppBar: true,
        backgroundColor: colourScaffoldBackground,
        appBar: AppBar(
          systemOverlayStyle: Get.theme.appBarTheme.systemOverlayStyle,
          backgroundColor: colourPrimary,
          leading: leadingWidget,
          title: title,
          actions: appBarActions ?? [],
        ),
        body: Container(
          width: SizeConfig.screenWidth,
          height: SizeConfig.screenHeight,
          decoration: scaffoldDecoration,
          child: LoadingOverlay(
            progressIndicator: const Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircularProgressIndicator(),
                Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text(
                    'Loading...',
                  ),
                )
              ],
            ),
            isLoading: isLoading,
            child: bodyWidget,
          ),
        ),
        bottomNavigationBar: bottomNavigationBar,
      ),
    );
  }
}
