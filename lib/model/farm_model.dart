class FarmModel {
  String? id;
  String name;
  String? ownerId;
  int? farmId;
  String? ownerName;
  bool? isDeleted;

  FarmModel({
    this.id,
    required this.name,
    this.ownerId,
    this.farmId,
    this.ownerName,
    this.isDeleted,
  });

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'name': name,
      'ownerId': ownerId,
      'farmId': farmId,
      'ownerName': ownerName,
      'isDeleted': isDeleted,
    };
  }

  factory FarmModel.fromMap(Map<String, dynamic> json) {
    return FarmModel(
      id: json['_id'],
      name: json['name'],
      ownerId: json['ownerId'],
      farmId: json["farmId"],
      ownerName: json['ownerName'],
      isDeleted: json['isDeleted'],
    );
  }

  // copyWith
  FarmModel copyWith({
    String? id,
    String? name,
    String? ownerId,
    int? farmId,
    String? ownerName,
    bool? isDeleted,
  }) {
    return FarmModel(
      id: id ?? this.id,
      name: name ?? this.name,
      ownerId: ownerId ?? this.ownerId,
      farmId: farmId ?? this.farmId,
      ownerName: ownerName ?? this.ownerName,
      isDeleted: isDeleted ?? this.isDeleted,
    );
  }
}
