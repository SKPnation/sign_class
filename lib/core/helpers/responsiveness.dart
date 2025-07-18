import 'package:flutter/material.dart';
import 'package:sign_class/core/helpers/size_helpers.dart';

const int largeScreenSize = 1366;
const int mediumScreenSize = 768;
const int smallScreenSize = 360;
const int customScreenSize = 1100;

class ResponsiveWidget extends StatelessWidget {

  final Widget? largeScreen;
  final Widget? mediumScreen;
  final Widget? smallScreen;
  //final Widget? customScreen;

  const ResponsiveWidget(
      {super.key,
        this.largeScreen,
        this.mediumScreen,
        this.smallScreen});

  static bool isSmallScreen(BuildContext context)=>
      displayWidth(context) < mediumScreenSize;

  static bool isMediumScreen(BuildContext context)=>
      displayWidth(context) >= mediumScreenSize &&
          displayWidth(context) < largeScreenSize;

  static bool isLargeScreen(BuildContext context)=>
      displayWidth(context) >= largeScreenSize;

  static bool isCustomScreen(BuildContext context)=>
      displayWidth(context) >= mediumScreenSize &&
          displayWidth(context) <= customScreenSize;


  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints){
      double width = constraints.maxWidth;
      if(width >= largeScreenSize){
        return largeScreen!;
      }
      else if (width < largeScreenSize && width >= mediumScreenSize){
        return mediumScreen ?? largeScreen!;
      }
      else {
        return smallScreen ?? largeScreen!;
      }
    });
  }
}