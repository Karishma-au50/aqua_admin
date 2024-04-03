import 'package:admin/features/dashboard/api/sensor_services.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';

import '../../../model/calibration_values.dart';

class SensorController extends GetxController {
  final _api = SensorService();
  Future<List<CalibrationValues>> fetchCalibrationValues(String pondId) async {
    var res = await _api.fetchCalibrationValues(pondId);
    return res;
  }

  Future updateSensorCaliberation(
      String id, String sensorRecordedValue, String subSensorItemValue) async {
    var res = await _api.updateSensorCaliberation(
        id, sensorRecordedValue, subSensorItemValue);
    return res;
  }
}
