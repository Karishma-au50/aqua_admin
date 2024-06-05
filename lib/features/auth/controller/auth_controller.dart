import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';

import '../../../core/local_data_helper.dart';
import '../../../routes/app_routes.dart';
import '../../../shared/utils/nav_helper.dart';
import '../../../shared/widgets/toast/my_toast.dart';
import '../api/api_services.dart';

class AuthController extends GetxController {
  final _api = AuthService();

  Future<void> login({required String mobile, required String password}) async {
    try {
      final res = await _api.login(mobile, password);
      if (!res.error!) {
        MyToasts.toastSuccess(res.message ?? "Success");
        LocalDataHelper.setUserToken(res.result);
        NavHelper.offAllToNamed(AppRoutes.dashboard);
      } else {
        MyToasts.toastError(res.message ?? "Error");
      }

      // Get.toNamed(AppRoutes.dashboard);
    } catch (e) {
      MyToasts.toastError(e.toString());
    }
  }
}
