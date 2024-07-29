import 'package:admin/model/activeUsers.dart';
import 'package:dio/dio.dart';

import '../../../core/local_data_helper.dart';
import '../../../core/model/response_model.dart';
import '../../../core/network/base_api_service.dart';
import '../../../model/calibration_values.dart';
import '../../../model/conclusive_Raw_data_model.dart';
import '../../../model/farmer_pond_info_model.dart';

class SensorEndpoint {
  static const sensorCaliberation = '/sensorCalibration/';
}

class SensorService extends BaseApiService {
  Future<List<CalibrationValues>> fetchCalibrationValues(String pondId) async {
    String token = await LocalDataHelper.getUserToken();
    final response = await get(
      "/admin/calibration?pondId=$pondId",
      options: Options(
        headers: {"authorization": token},
      ),
    );

    if (response.data['error'] == true) {
      // print('errr-----${response.data}');
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
      "/admin/calibration/$id",
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
      "/admin/inventory/?deviceId=$id",
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
      "/admin/getLiveData?typeId=$typeId&dlno=$dlNo&networkNo=$networkNo&collectionType=$collectionType&count=$count",
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
      "/admin/getfarmerpondinfo",
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

  Future<ResponseModel> farmCleanUp(
    String id,
  ) async {
    String token = await LocalDataHelper.getUserToken();
    final res = await delete(
      "/admin/deletefarmPond?deviceId=$id",
      options: Options(
        headers: {"authorization": token},
      ),
    );

    return ResponseModel.empty().fromJson(res.data);
  }

  // get active useers..
  Future<ResponseModel> getActiveUsers() async {
    String token = await LocalDataHelper.getUserToken();

    var res = await get(
      '/users/',
      options: Options(
        headers: {"authorization": token},
      ),
    );

    ResponseModel resModel = ResponseModel<List<ActiveUsersModel>>(
      message: res.data["message"],
      error: res.data["error"],
      result: res.data["result"]
          .map<ActiveUsersModel>((e) => ActiveUsersModel.fromMap(e))
          .toList(),
    );
    return resModel;
  }
}
