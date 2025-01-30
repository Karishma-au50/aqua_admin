class CloudManagementModel {
  final String id;
  final int dlNo;
  final String dlName;
  final int updatedAt;
  final String? simNumber;

  CloudManagementModel({
    required this.id,
    required this.dlNo,
    required this.dlName,
    required this.updatedAt,
    this.simNumber,
  });

  factory CloudManagementModel.fromMap(Map<String, dynamic> json) {
    return CloudManagementModel(
      id: json['_id'],
      dlNo: json['DLNO'],
      dlName: json['DLNAME'],
      updatedAt: json['updatedAt'] ?? "",
      simNumber: json['SIMNUMBER'],
    );
  }
  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {
      '_id': id,
      'DLNO': dlNo,
      'DLNAME': dlName,
      'updatedAt': updatedAt,
      'SIMNUMBER': simNumber,
    };
    return json;
  }
}
