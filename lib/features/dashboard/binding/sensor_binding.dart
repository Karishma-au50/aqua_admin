import 'package:admin/features/dashboard/controller/dashboard_controller.dart';
import 'package:get/get.dart';

class AuthBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SensorController>(() => SensorController());
  }
}
