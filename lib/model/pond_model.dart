class PondModel {
  final String? id;
  final int? pondId;
  final int? farmId;
  final String? name;
  final String? pondStatus;
  final bool? isDeleted;

  PondModel({
    this.id,
    this.pondId,
    this.farmId,
    this.name,
    this.pondStatus,
    this.isDeleted,
  });

  factory PondModel.fromMap(Map<String, dynamic> json) {
    return PondModel(
      id: json['_id'],
      pondId: json['pondId'],
      farmId: json['farmId'],
      name: json['name'],
      pondStatus: json['pondStatus'],
      isDeleted: json['isDeleted'],
    );
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {
      'id': id,
      'pondId': pondId,
      'farmId': farmId,
      'name': name,
      'pondStatus': pondStatus,
      'isDeleted': isDeleted,
    };
    return json;
  }

  // copyWith
  PondModel copyWith({
    String? id,
    int? pondId,
    int? farmId,
    String? name,
    String? pondStatus,
    bool? isDeleted,
  }) {
    return PondModel(
      id: id ?? this.id,
      pondId: pondId ?? this.pondId,
      farmId: farmId ?? this.farmId,
      name: name ?? this.name,
      pondStatus: pondStatus ?? this.pondStatus,
      isDeleted: isDeleted ?? this.isDeleted,
    );
  }

}
