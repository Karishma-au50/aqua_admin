import 'package:admin/core/model/response_model.dart';
import 'package:admin/model/waterquality/water_qualiity_chart_model.dart';
import 'package:dio/dio.dart';

import '../../../core/local_data_helper.dart';
import '../../../core/network/base_api_service.dart';
import '../../../model/farmer_pond_info_model.dart';

class WaterQualityService extends BaseApiService {
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

  Future<ResponseModel<List<WaterQualityChartModel>>> getWaterQualityChartData(
      List<int> pondIds,
      List<String> sensors,
      DateTime startTime,
      DateTime endTime) async {
    final response = await post(
      "/admin/comobograph",
      data: {
        "pondIds": pondIds,
        "sensors": {for (var item in sensors) item: 1},
        "startTime": startTime.millisecondsSinceEpoch,
        "endTime": endTime.millisecondsSinceEpoch,
      },
      options: Options(
        headers: {"authorization": await LocalDataHelper.getUserToken()},
      ),
    );

    if (response.data['error'] == true) {
      // print('errr-----${response.data}');
      return ResponseModel<List<WaterQualityChartModel>>(
        message: response.data['message'],
        error: response.data['error'],
        result: [],
      );
    }
    ResponseModel<List<WaterQualityChartModel>> res =
        ResponseModel<List<WaterQualityChartModel>>(
      message: response.data['message'],
      error: response.data['error'],
      result: response.data['result']
          .map<WaterQualityChartModel>(
              (x) => WaterQualityChartModel.fromJson(x))
          .toList(),
    );

    return res;
  }
}
