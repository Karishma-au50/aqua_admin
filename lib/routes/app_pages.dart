import 'package:admin/features/dashboard/views/dashboardScreen/dashboard_screen.dart';
import 'package:admin/features/dashboard/views/sensorCaliberation/sensor_caliberation_screen.dart';
import 'package:get/get.dart';

import '../features/auth/binding/auth_binding.dart';
import '../features/auth/views/login_screen.dart';
import '../features/dashboard/views/liveData/conclusive_raw_live_data_screen.dart';
import 'app_routes.dart';

class AppPages {
  static final List<GetPage> routes = [
    GetPage(
      name: AppRoutes.login,
      page: () => LoginScreen(),
      binding: AuthBinding(),
    ),
    GetPage(
      name: AppRoutes.sensorCaliberation,
      page: () => const SensorCalibration(),
      binding: AuthBinding(),
    ),
    GetPage(
      name: AppRoutes.dashboard,
      page: () => const DashBoardScreen(),
      binding: AuthBinding(),
    ),
    GetPage(
      name: AppRoutes.conclusiveOrRawLiveData,
      page: () => const ConclusiveOrRawLiveDataScreen(),
      binding: AuthBinding(),
    ),
  ];
}
