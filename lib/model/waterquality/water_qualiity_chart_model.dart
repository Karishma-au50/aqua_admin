class WaterQualityChartModel {
  final int pondId;
  final String sensor;
  final List<SensorChartModel> data;

  WaterQualityChartModel({
    required this.pondId,
    required this.sensor,
    required this.data,
  });

  factory WaterQualityChartModel.fromJson(Map<String, dynamic> json) {
    return WaterQualityChartModel(
      pondId: json["pondId"],
      sensor: json["sensor"],
      data: json["data"]
          .map<SensorChartModel>((ele) => SensorChartModel.fromJson(ele))
          .toList(),
    );
  }
}

class SensorChartModel {
  final int derivedTime;
  final num value;

  SensorChartModel({required this.derivedTime, required this.value});

  DateTime get dateTime => DateTime.fromMillisecondsSinceEpoch(derivedTime);

  factory SensorChartModel.fromJson(Map<String, dynamic> json) {
    return SensorChartModel(
      derivedTime: json["derivedTime"] ?? 0,
      value: json["value"] ?? 0,
    );
  }

  // copy with
  SensorChartModel copyWith({int? derivedTime, num? value}) {
    return SensorChartModel(
      derivedTime: derivedTime ?? this.derivedTime,
      value: value ?? this.value,
    );
  }
}
