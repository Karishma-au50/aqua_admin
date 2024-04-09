import 'package:admin/core/model/response_model.dart';
import 'package:dio/dio.dart';

import '../../../core/local_data_helper.dart';
import '../../../core/network/base_api_service.dart';
import '../../../model/calibration_values.dart';

class SensorEndpoint {
  static const sensorCaliberation = '/sensorCalibration/';
}

class SensorService extends BaseApiService {
  Future<List<CalibrationValues>> fetchCalibrationValues(String pondId) async {
    String token = await LocalDataHelper.getUserToken();
    final response = await get(
      "https://api-dev.aquagenixpro.com/admin/calibration?pondId=$pondId",
      options: Options(
        headers: {"authorization": token},
      ),
    );

    if (response.data['error'] == true) {
      print('errr-----${response.data}');
    }

    List<CalibrationValues> calibrationValues = [];

    for (var i in response.data['result']) {
      calibrationValues.add(CalibrationValues.fromMap(i));
    }

    return calibrationValues;
  }

  Future<ResponseModel> updateSensorCaliberation(
      String id, String sensorRecordedValue, String? subSensorItemValue) async {
    String token = await LocalDataHelper.getUserToken();
    final res = await put(
      "https://api-dev.aquagenixpro.com/admin/calibration/$id",
      data: {
        "sensorRecordedValue": sensorRecordedValue,
        "subSensorItemValue": subSensorItemValue
      },
      options: Options(
        headers: {"authorization": token},
      ),
    );

    return ResponseModel.empty().fromJson(res.data);
  }

  // clean inventory
  Future<ResponseModel> cleanInventory(
    String id,
  ) async {
    String token = await LocalDataHelper.getUserToken();
    final res = await delete(
      "https://api-dev.aquagenixpro.com/admin/inventory/?deviceId=$id",
      options: Options(
        headers: {"authorization": token},
      ),
    );

    return ResponseModel.empty().fromJson(res.data);
  }
}
