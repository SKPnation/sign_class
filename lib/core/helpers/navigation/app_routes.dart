import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sign_class/core/constants/app_strings.dart';
import 'package:sign_class/features/auth/presentation/controllers/student_controller.dart';
import 'package:sign_class/features/auth/presentation/pages/auth_page.dart';
import 'package:sign_class/features/details/presentation/pages/details_page.dart';
import 'package:sign_class/features/home/presentation/pages/home.dart';
import 'package:sign_class/features/site_layout/presentation/pages/site_layout.dart';

abstract class AppPages{
  AppPages._();

  static final String initial = Routes.homeRoute;

  static final pages = [
    GetPage(name: Routes.rootRoute, page: () => SiteLayout()),
    GetPage(name: Routes.authenticationPageRoute, page: () => const AuthPage()),
    GetPage(name: Routes.detailsPageRoute, page: () => const DetailsPage()),
  ];
}

abstract class Routes{

  Routes._();

  static const homeDisplayName = AppStrings.homeTitle;
  static const homeRoute = "/home";

  static var authenticationDisplayName = StudentController.instance.authPageTitle.value;
  static const authenticationPageRoute = "/auth";

  static const detailsDisplayName = AppStrings.detailsPageTitle;
  static const detailsPageRoute = "/details";

  static const rootRoute = "/";
}

Route<dynamic> generateRoute(RouteSettings settings){
  switch (settings.name) {
    case Routes.homeRoute:
      return _getPageRoute(Home());
    case Routes.authenticationPageRoute:
      return _getPageRoute(AuthPage());
    case Routes.detailsPageRoute:
      return _getPageRoute(DetailsPage());
    // case Routes.therapistsPageRoute:
    //   return _getPageRoute(TherapistsPage());
    // case Routes.settingsPageRoute:
    //   return _getPageRoute(SettingsPage());
  // case partnersPageRoute:
  //   return _getPageRoute(PartnersPage());
  // case questionnairePageRoute:
  //   return _getPageRoute(QuestionnairePage());
    default:
      return _getPageRoute(Home());

  }
}

PageRoute _getPageRoute(Widget child){
  return MaterialPageRoute(builder: (context) => child);
}
