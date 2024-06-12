import 'package:admin/core/model/response_model.dart';
import 'package:admin/model/conclusive_Raw_data_model.dart';
import 'package:admin/model/farmer_pond_info_model.dart';
import 'package:dio/dio.dart';

import '../../../core/local_data_helper.dart';
import '../../../core/network/base_api_service.dart';
import '../../../model/calibration_values.dart';
import '../../../model/farm_model.dart';
import '../../../model/pond_model.dart';
import '../../../shared/constant/app_constants.dart';

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
  // get live data

  Future<ResponseModel> conclusiveOrRawLiveData(String typeId, String dlNo,
      String networkNo, String collectionType, String count) async {
    String token = await LocalDataHelper.getUserToken();

    var res = await get(
      "https://api-dev.aquagenixpro.com/admin/getLiveData?typeId=$typeId&dlno=$dlNo&networkNo=$networkNo&collectionType=$collectionType&count=$count",
      options: Options(
        headers: {"authorization": token},
      ),
    );

    ResponseModel resModel = ResponseModel<List<ConclusiveOrRawDataModel>>(
      message: res.data["message"],
      error: res.data["error"],
      result: res.data["result"]
          .map<ConclusiveOrRawDataModel>(
              (e) => ConclusiveOrRawDataModel.fromMap(e))
          .toList(),
    );
    return resModel;
  }

  Future<ResponseModel> getfarmerpondinfo() async {
    String token = await LocalDataHelper.getUserToken();

    var res = await get(
      "${AppConstants.baseUrl}/admin/getfarmerpondinfo",
      options: Options(
        headers: {"authorization": token},
      ),
    );

    ResponseModel resModel = ResponseModel<FarmerPondInfoModel>(
      message: res.data["message"],
      error: res.data["error"],
      result: FarmerPondInfoModel.fromMap(res.data["result"]),
    );
    return resModel;
  }
}
