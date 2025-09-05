import 'package:get/get.dart';
import 'package:sign_class/core/constants/app_strings.dart';
import 'package:sign_class/features/auth/presentation/controllers/student_controller.dart';
import 'package:sign_class/features/auth/presentation/pages/auth_page.dart';
import 'package:sign_class/features/details/presentation/pages/details_page.dart';
import 'package:sign_class/features/onboarding/presentation/pages/onboarding.dart';
import 'package:sign_class/features/onboarding/presentation/pages/user_type_page.dart';
import 'package:sign_class/features/site_layout/presentation/pages/site_layout.dart';

abstract class AppPages{
  AppPages._();

  static final String initial = Routes.userTypeRoute;

  static final pages = [
    GetPage(name: Routes.rootRoute, page: () => SiteLayout()),
    GetPage(name: Routes.onboardingRoute, page: () => OnboardingPage()),
    GetPage(name: Routes.userTypeRoute, page: () => UserTypePage()),
    GetPage(name: Routes.authenticationPageRoute, page: () => const AuthPage()),
    GetPage(name: Routes.detailsPageRoute, page: () => const DetailsPage()),
  ];
}

abstract class Routes{

  Routes._();

  static const homeDisplayName = AppStrings.homeTitle;
  static const onboardingRoute = "/home";

  static const userTypeDisplayName = AppStrings.homeTitle;
  static const userTypeRoute = "/user-type";

  static var authenticationDisplayName = StudentController.instance.authPageTitle.value;
  static const authenticationPageRoute = "/auth";

  static var tutorAuthDisplayName = StudentController.instance.authPageTitle.value;
  static const tutorAuthPageRoute = "/tutor-auth";

  static const detailsDisplayName = AppStrings.detailsPageTitle;
  static const detailsPageRoute = "/details";

  static const rootRoute = "/";
}

