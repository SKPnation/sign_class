import 'package:flutter/material.dart';
import 'package:sign_class/core/constants/app_strings.dart';
import 'package:sign_class/core/helpers/navigation/app_routes.dart';
import 'package:sign_class/core/helpers/navigation/navigation_controller.dart';

NavigationController navigationController = NavigationController.instance;

Navigator localNavigator() => Navigator(
  key: navigationController.navigatorKey,
  onGenerateRoute: generateRoute,
  initialRoute: AppStrings.homeTitle,
  //Routes.dashboardRoute
);