import 'package:admin/features/dashboard/api/sensor_services.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';

import '../../../model/calibration_values.dart';
import '../../../shared/widgets/toast/my_toast.dart';

class SensorController extends GetxController {
  final _api = SensorService();
  Future<List<CalibrationValues>> fetchCalibrationValues(String pondId) async {
    var res = await _api.fetchCalibrationValues(pondId);
    return res;
  }

  Future<void> updateSensorCaliberation(
      String id, String sensorRecordedValue, String subSensorItemValue) async {
    try {
      final res = await _api.updateSensorCaliberation(
          id, sensorRecordedValue, subSensorItemValue);
      if (!res.error) {
        MyToasts.toastSuccess(res.message ?? "Success");
      } else {
        MyToasts.toastError(res.message ?? "Error");
      }
    } catch (e) {
      MyToasts.toastError(e.toString());
    }
  }

  // delete device id
  Future<void> cleanInventory(String id) async {
    try {
      final res = await _api.cleanInventory(id);
      if (!res.error) {
        MyToasts.toastSuccess(res.message ?? "Success");
      } else {
        MyToasts.toastError(res.message ?? "Error");
      }
    } catch (e) {
      MyToasts.toastError(e.toString());
    }
  }
}
