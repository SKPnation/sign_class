import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sign_class/features/home/presentation/pages/home.dart';

class NavigationController extends GetxController{
  static NavigationController instance = Get.find();
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey();

  Future<dynamic> navigateTo(String routeName){
    return navigatorKey.currentState!.pushNamed(routeName);
  }

  goBack() => navigatorKey.currentState!.pop();
  void goToHome(Widget homePage) {
    navigatorKey.currentState!.pushAndRemoveUntil(
      MaterialPageRoute(builder: (_) => Home()),
          (route) => false, // remove all previous routes
    );
  }
}