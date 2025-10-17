import 'package:get/get.dart';
import 'package:sign_class/features/user_types.dart';

abstract class AppPages{
  AppPages._();

  static final String initial = Routes.userTypeRoute;

  static final pages = [
    // GetPage(name: Routes.onboardingRoute, page: () => OnboardingPage()),
    GetPage(name: Routes.userTypeRoute, page: () => UserTypesPage()),
    // GetPage(name: Routes.detailsPageRoute, page: () => const DetailsPage()),
  ];
}

abstract class Routes{

  Routes._();

  // static const homeDisplayName = AppStrings.homeTitle;
  // static const onboardingRoute = "/home";
  //
  // static const userTypeDisplayName = AppStrings.homeTitle;
  static const userTypeRoute = "/user-type";

  // static var authenticationDisplayName = StudentController.instance.authPageTitle.value;
  // static const authenticationPageRoute = "/auth";

  // static var tutorAuthDisplayName = StudentController.instance.authPageTitle.value;
  // static const tutorAuthPageRoute = "/tutor-auth";
  //
  // static const detailsDisplayName = AppStrings.detailsPageTitle;
  // static const detailsPageRoute = "/details";

  // static const rootRoute = "/";
}

