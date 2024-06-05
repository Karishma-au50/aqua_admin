class CalibrationValues {
  String? id;
  int? pondId;
  String? edgeDeviceId;
  String? sensorType;
  String? subSensorItem;
  String? subSensorItemValue;
  double? sensorRecordedValue;
  int? recordedTime;

  CalibrationValues({
    this.id,
    this.pondId,
    this.edgeDeviceId,
    this.sensorType,
    this.subSensorItem,
    this.subSensorItemValue,
    this.sensorRecordedValue,
    this.recordedTime,
  });

  factory CalibrationValues.fromMap(Map<String, dynamic> json) =>
      CalibrationValues(
        id: json["_id"],
        pondId: json["pondId"],
        edgeDeviceId: json["edgeDeviceId"],
        sensorType: json["sensorType"],
        subSensorItem: json["subSensorItem"],
        subSensorItemValue: "${json["subSensorItemValue"]}",
        sensorRecordedValue: json["sensorRecordedValue"] != null
            ? double.parse(json["sensorRecordedValue"].toString())
            : null,
        recordedTime: json["recordedTime"],
      );

  CalibrationValues copyWith({
    String? id,
    int? pondId,
    String? edgeDeviceId,
    String? sensorType,
    String? subSensorItem,
    String? subSensorItemValue,
    double? sensorRecordedValue,
    int? recordedTime,
  }) =>
      CalibrationValues(
        id: id ?? this.id,
        pondId: pondId ?? this.pondId,
        edgeDeviceId: edgeDeviceId ?? this.edgeDeviceId,
        sensorType: sensorType ?? this.sensorType,
        subSensorItem: subSensorItem ?? this.subSensorItem,
        subSensorItemValue: subSensorItemValue ?? this.subSensorItemValue,
        sensorRecordedValue: sensorRecordedValue ?? this.sensorRecordedValue,
        recordedTime: recordedTime ?? this.recordedTime,
      );
}
