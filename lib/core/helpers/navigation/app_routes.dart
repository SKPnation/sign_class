import 'package:get/get.dart';
import 'package:sign_class/features/root_page.dart';
import 'package:sign_class/features/user_types.dart';

abstract class AppPages {
  AppPages._();

  static final String initial = Routes.rootRoute;

  static final pages = [
    GetPage(name: Routes.rootRoute, page: () => RootPage()),
    // GetPage(name: Routes.userTypeRoute, page: () => UserTypesPage()),
  ];
}

abstract class Routes {
  Routes._();

  static const rootRoute = "/root";
  // static const userTypeRoute = "/user-type";
}
