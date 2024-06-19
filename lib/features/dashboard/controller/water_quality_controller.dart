import 'package:admin/shared/widgets/toast/my_toast.dart';
import 'package:get/get.dart';

import '../../../model/farmer_pond_info_model.dart';
import '../../../model/waterquality/water_qualiity_chart_model.dart';
import '../api/water_quality_service.dart';

class WaterQualityController extends GetxController {
  final WaterQualityService _api = WaterQualityService();
  RxList<WaterQualityChartModel> waterQualityChartModel =
      <WaterQualityChartModel>[].obs;
  FarmerPondInfoModel farmerPondInfoModel = FarmerPondInfoModel();

  Future<FarmerPondInfoModel?> getfarmerpondinfo() async {
    try {
      final res = await _api.getfarmerpondinfo();
      if (!res.error) {
        return farmerPondInfoModel = res.result!;
      } else {
        MyToasts.toastError(res.message ?? "Error");
        return null;
      }
    } catch (e) {
      MyToasts.toastError(e.toString());
      return null;
    }
  }

  Future getWaterQualityChartData(List<int> pondIds, List<String> sensors,
      DateTime startTime, DateTime endTime) async {
    try {
      var res = await _api.getWaterQualityChartData(
          pondIds, sensors, startTime, endTime);
      if (!res.error) {
        waterQualityChartModel.value = res.result!;
      } else {
        MyToasts.toastError(res.message ?? "Error");
      }
    } catch (e) {
      print(e);
      MyToasts.toastError(e.toString());
    }
  }
}
