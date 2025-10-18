import 'package:get/get.dart';
import 'package:sign_class/features/user_types.dart';

abstract class AppPages {
  AppPages._();

  static final String initial = Routes.userTypeRoute;

  static final pages = [
    GetPage(name: Routes.userTypeRoute, page: () => UserTypesPage()),
  ];
}

abstract class Routes {
  Routes._();

  static const userTypeRoute = "/user-type";
}
