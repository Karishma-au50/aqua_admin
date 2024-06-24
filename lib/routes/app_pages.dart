import 'package:admin/features/dashboard/views/WaterQualityGraph/water_quality_screen.dart';
import 'package:admin/features/dashboard/views/sensorCaliberation/sensor_caliberation_screen.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../core/local_data_helper.dart';
import '../features/auth/views/login_screen.dart';
import '../features/dashboard/views/dashboardScreen/dashboard_screen.dart';
import '../features/dashboard/views/liveData/conclusive_raw_live_data_screen.dart';
import '../main_screen.dart';
import 'app_routes.dart';

final rootNavigatorKey = GlobalKey<NavigatorState>();
final shellNavigatorKey = GlobalKey<NavigatorState>();
final router = GoRouter(
  navigatorKey: rootNavigatorKey,
  initialLocation: AppRoutes.login,
  routes: [
    GoRoute(
      path: '/Login',
      pageBuilder: (context, state) =>
          MaterialPage(key: state.pageKey, child: const LoginScreen()),
    ),
    ShellRoute(
      navigatorKey: shellNavigatorKey,
      builder: (context, state, child) {
        return MainScreen(
          shellContext: shellNavigatorKey.currentContext,
          child: child,
        );
      },
      redirect: (context, state) async {
        if (await LocalDataHelper.getUserToken() == "") {
          return AppRoutes.login;
        }
        // return state.fullPath;
      },
      routes: [
        GoRoute(
          path: AppRoutes.dashboard,
          builder: (context, state) => const DashBoardScreen(),
        ),
        GoRoute(
          path: AppRoutes.waterQuality,
          builder: (context, state) => const WaterQualityScreen(),
        ),
        GoRoute(
          name: AppRoutes.sensorCaliberation,
          path: "${AppRoutes.sensorCaliberation}/:pondId",
          builder: (context, state) =>
              SensorCalibration(pondId: state.pathParameters["pondId"]!),
        ),
        GoRoute(
          name: AppRoutes.conclusiveOrRawLiveData,
          path: AppRoutes.conclusiveOrRawLiveData,
          builder: (context, state) => const ConclusiveOrRawLiveDataScreen(),
        ),
      ],
    ),
  ],
);
