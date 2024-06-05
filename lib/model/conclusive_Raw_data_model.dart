class ConclusiveOrRawDataModel {
  String? id;
  int? networkNo;
  int? dlNo;
  int? seqNo;
  int? analogId;
  int? typeId;
  int? byte1;
  int? byte2;
  int? byte3;
  int? locationNo;
  int? year;
  int? lTime;
  double? voltageStatus;
  String? receivedTime;

  ConclusiveOrRawDataModel({
    this.id,
    this.networkNo,
    this.dlNo,
    this.seqNo,
    this.analogId,
    this.typeId,
    this.byte1,
    this.byte2,
    this.byte3,
    this.locationNo,
    this.year,
    this.lTime,
    this.voltageStatus,
    this.receivedTime,
  });

  factory ConclusiveOrRawDataModel.fromMap(Map<String, dynamic> json) {
    return ConclusiveOrRawDataModel(
      id: json['_id'],
      networkNo: json['networkno'],
      dlNo: json['dlno'],
      seqNo: json['seqno'],
      analogId: json['analogid'],
      typeId: json['typeid'],
      byte1: json['byte1'],
      byte2: json['byte2'],
      byte3: json['byte3'],
      locationNo: json['locationno'],
      year: json['year'],
      lTime: json['ltime'],
      voltageStatus: json['voltage_status'],
      receivedTime: json['receivedtime'],
    );
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {
      'id': id,
      'networkNo': networkNo,
      'dlNo': dlNo,
      'seqNo': seqNo,
      'analogId': analogId,
      'typeId': typeId,
      'byte1': byte1,
      'byte2': byte2,
      'byte3': byte3,
      'locationNo': locationNo,
      'year': year,
      'lTime': lTime,
      'voltageStatus': voltageStatus,
      'receivedTime': receivedTime,
    };
    return json;
  }
// copy with

  ConclusiveOrRawDataModel copyWith({
    String? id,
    int? networkNo,
    int? dlNo,
    int? seqNo,
    int? analogId,
    int? typeId,
    int? byte1,
    int? byte2,
    int? byte3,
    int? locationNo,
    int? year,
    int? lTime,
    double? voltageStatus,
    String? receivedTime,
  }) {
    return ConclusiveOrRawDataModel(
      id: id ?? this.id,
      networkNo: networkNo ?? this.networkNo,
      dlNo: dlNo ?? this.dlNo,
      seqNo: seqNo ?? this.seqNo,
      analogId: analogId ?? this.analogId,
      typeId: typeId ?? this.typeId,
      byte1: byte1 ?? this.byte1,
      byte2: byte2 ?? this.byte2,
      byte3: byte3 ?? this.byte3,
      locationNo: locationNo ?? this.locationNo,
      year: year ?? this.year,
      lTime: lTime ?? this.lTime,
      voltageStatus: voltageStatus ?? this.voltageStatus,
      receivedTime: receivedTime ?? this.receivedTime,
    );
  }
}
