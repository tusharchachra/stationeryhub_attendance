import 'package:flutter/material.dart';
import 'package:loading_overlay/loading_overlay.dart';

import '../helpers/size_config.dart';

class ScaffoldHome extends StatelessWidget {
  final Widget bodyWidget;
  final List<Widget>? appBarActions;
  final bool isLoading;
  final String pageTitle;
  final Widget? bottomNavigationBar;
  final BoxDecoration? scaffoldDecoration;
  final TextStyle? appBarTextStyle;
  const ScaffoldHome({
    super.key,
    required this.bodyWidget,
    this.appBarActions,
    required this.isLoading,
    required this.pageTitle,
    this.bottomNavigationBar,
    this.scaffoldDecoration,
    this.appBarTextStyle,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Text(
          pageTitle,
          style: appBarTextStyle,
        ),
        centerTitle: true,
        actions: appBarActions ?? [],
        backgroundColor: Colors.transparent,
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
    );
  }
}
