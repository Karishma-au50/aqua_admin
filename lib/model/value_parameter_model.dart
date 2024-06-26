import 'pond_model.dart';
import 'farm_model.dart';

class ValueParameterModel {
  List<PondModel>? ponds;
  List<FarmModel>? farms;
  String? sensor;
  DateTime? startDate;
  DateTime? endDate;
  bool isComb;

  ValueParameterModel(
      {this.ponds,
      this.farms,
      this.sensor,
      this.startDate,
      this.endDate,
      this.isComb = false});

  factory ValueParameterModel.fromJson(Map<String, dynamic> json) {
    return ValueParameterModel(
        farms: json['farms'] == null
            ? []
            : List.from(
                json['farms'].map((e) => FarmModel.fromMap(e)).toList()),
        ponds: json['ponds'] == null
            ? []
            : List.from(
                json['ponds'].map((e) => PondModel.fromMap(e)).toList()),
        sensor: json['sensor'],
        startDate: json['startDate'],
        endDate: json['endDate']);
  }
  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {
      'pondId': ponds,
      'farmId': farms,
      'sensor': sensor,
      'startDate': startDate,
      'endDate': endDate
    };
    return json;
  }

  ValueParameterModel copyWith({
    final List<PondModel>? ponds,
    final List<FarmModel>? farms,
    final String? sensor,
    DateTime? startDate,
    DateTime? endDate,
  }) {
    return ValueParameterModel(
        ponds: ponds ?? this.ponds,
        farms: farms ?? this.farms,
        sensor: sensor ?? this.sensor,
        startDate: startDate ?? this.startDate,
        endDate: endDate ?? this.endDate);
  }
}
