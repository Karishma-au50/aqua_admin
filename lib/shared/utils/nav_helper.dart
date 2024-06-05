import 'package:admin/routes/app_pages.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';

class NavHelper {
  static BuildContext context = rootNavigatorKey.currentContext!;
  static void popLastScreens<T>({
    int popCount = 1,
    T? result,
  }) {
    int count = 0;
    while (count < popCount) {
      Get.back(result: result);
      count++;
    }
  }

  static void popToRoot() {
    Get.offAllNamed('/');
  }

  static void popOffScreen(String routeName) {
    Get.offAllNamed(routeName);
  }

  static void pushToNamed(String routeName) {
    context.push(routeName);
  }

  static void offAllToNamed(String routeName) {
    // Get.offAllNamed(routeName);
    rootNavigatorKey.currentContext!.go(routeName);
  }

  static void pushToScreenWithArguments(String routeName, dynamic arguments) {
    Get.toNamed(routeName, arguments: arguments);
  }

  static void pushToScreenWithReplacement(String routeName) {
    Get.offNamed(routeName);
  }
}
