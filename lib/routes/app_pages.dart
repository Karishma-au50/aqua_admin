import 'package:admin/features/dashboard/views/WaterQualityGraph/water_quality_screen.dart';
import 'package:admin/features/dashboard/views/sensorCaliberation/sensor_caliberation_screen.dart';
import 'package:admin/model/conclusive_Raw_data_model.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../features/auth/views/login_screen.dart';
import '../features/dashboard/views/dashboardScreen/dashboard_screen.dart';
import '../features/dashboard/views/liveData/conclusive_raw_live_data_screen.dart';
import '../main_screen.dart';
import 'app_routes.dart';

final rootNavigatorKey = GlobalKey<NavigatorState>();
final _shellNavigatorKey = GlobalKey<NavigatorState>();
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
      navigatorKey: _shellNavigatorKey,
      builder: (context, state, child) {
        return MainScreen(
          shellContext: _shellNavigatorKey.currentContext,
          child: child,
        );
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
          path: AppRoutes.sensorCaliberation,
          builder: (context, state) => const SensorCalibration(),
        ),
        GoRoute(
          path: AppRoutes.conclusiveOrRawLiveData,
          builder: (context, state) => const ConclusiveOrRawLiveDataScreen(),
        ),
      ],
    ),
  ],
);
