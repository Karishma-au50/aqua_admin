import 'package:admin/model/farm_model.dart';
import 'package:admin/model/pond_model.dart';

class FarmerPondInfoModel {
  final List<PondModel>? ponds;
  final List<FarmModel>? farms;

  FarmerPondInfoModel({
    this.ponds,
    this.farms,
  });

  Map<String, dynamic> toJson() {
    return {'farms': farms, 'ponds': ponds};
  }

  factory FarmerPondInfoModel.fromMap(Map<String, dynamic> json) {
    return FarmerPondInfoModel(
      farms: json['farms'] == null
          ? []
          : List.from(json['farms'].map((e) => FarmModel.fromMap(e)).toList()),
      ponds: json['ponds'] == null
          ? []
          : List.from(json['ponds'].map((e) => PondModel.fromMap(e)).toList()),
    );
  }

  FarmerPondInfoModel copyWith({
    final List<PondModel>? ponds,
    final List<FarmModel>? farms,
  }) {
    return FarmerPondInfoModel(
      ponds: ponds ?? this.ponds,
      farms: farms ?? this.farms,
    );
  }
}
