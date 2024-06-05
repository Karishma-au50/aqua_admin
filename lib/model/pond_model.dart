import 'dart:io';

import 'package:admin/shared/utils/extensions.dart';
import 'package:dio/dio.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';


class PondModel {
  final String? id;
  final int? pondId;
  final int? farmId;
  final String? name;
  final String? imageUrl;
  final int? area;
  final String? units;
  final int? salinity;
  final String? deviceId;
  final String? cultureType;
  final int? daysOfCulture;
  final int? totalSeed;
  final File? image;
  final List<ContactNumbers>? contactNumber;
  final SerialNo? serialNo;
  final String? aeratorPlan;
  final List<String>? pondAeratorIds;
  final String? pondStatus;
  final List<FarmYieldState>? yieldState;
  final bool? sensorLiveStatus;
  Rx<DerivedValues?>? derivedValues;
  final bool watchList;
  final int? createdOn;
  final double? ratePerKG;

  final double? survivalPercent;

  PondModel(
      {this.id,
      this.pondId,
      this.farmId,
      this.name,
      this.imageUrl,
      this.area,
      this.units,
      this.salinity,
      this.deviceId,
      this.cultureType,
      this.daysOfCulture,
      this.totalSeed,
      this.image,
      this.contactNumber,
      this.serialNo,
      this.aeratorPlan,
      this.pondAeratorIds,
      this.pondStatus,
      this.yieldState,
      this.derivedValues,
      this.sensorLiveStatus,
      this.watchList = false,
      this.createdOn,
      this.ratePerKG,
      this.survivalPercent});

  DateTime get createdDateTime {
    return DateTime.fromMillisecondsSinceEpoch(createdOn!);
  }

  DateTime get startingTime {
    return DateTime.now()
        .addDate(-1 * (yieldState?.first.pondCulturedDays ?? 0));
  }

  int calculatedDoc(DateTime date) {
    return date.difference(startingTime).inDays;
  }

  factory PondModel.fromMap(Map<String, dynamic> json) {
    return PondModel(
        id: json['_id'],
        pondId: json['pondId'],
        farmId: json['farmId'],
        name: json['name'],
        imageUrl: json['imageUrl'],
        area: json['area'],
        units: json['units'],
        salinity: json['salinity'],
        deviceId: json['deviceId'],
        cultureType: json['cultureType'],
        daysOfCulture: json['daysOfCulture'],
        sensorLiveStatus: json['sensorLiveStatus'],
        totalSeed: json['totalSeed'],
        contactNumber: json['contactNumbers'] == null
            ? []
            : List.from(json['contactNumbers']
                .map((e) => ContactNumbers.fromMap(e))
                .toList()),
        serialNo: json['serialNo'] != null
            ? SerialNo.fromJson(json['serialNo'])
            : null,
        aeratorPlan: json['aeratorPlan'],
        pondAeratorIds: json['pondAeratorIds'] == null
            ? []
            : List<String>.from(json['pondAeratorIds']),
        pondStatus: json['pondStatus'],
        yieldState: json['yieldState'] == null
            ? []
            : List<FarmYieldState>.from(
                json['yieldState'].map((e) => FarmYieldState.fromMap(e))),
        derivedValues: json['derivedValues'] != null
            ? DerivedValues.fromJson(json['derivedValues']).obs
            : DerivedValues().obs,
        watchList: json['watchList'] ?? false,
        createdOn: json['createdOn'],
        ratePerKG: json['ratePerKG'] != null
            ? double.parse(json['ratePerKG'].toString())
            : 0,
        survivalPercent: json['survivalPercent'] != null
            ? double.tryParse(json['survivalPercent'].toString())
            : 0);
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {
      'id': id,
      // 'pondId': pondId,
      'farmId': farmId,
      'name': name,
      'imageUrl': imageUrl,
      'area': area,
      'units': units,
      'salinity': salinity,
      'deviceId': deviceId,
      'cultureType': cultureType,
      'daysOfCulture': daysOfCulture,
      'totalSeed': totalSeed,
      'serialNo': serialNo?.toJson(),
      'aeratorPlan': aeratorPlan,
      'pondAeratorIds': pondAeratorIds,
      'pondStatus': pondStatus,
      'yieldState': yieldState?.map((e) => e.toJson()).toList(),
      'derivedValues': derivedValues?.toJson(),
      'sensorLiveStatus': sensorLiveStatus,
      'watchList': watchList,
    };
    // add contact number as list in formdata
    if (contactNumber != null) {
      for (var i = 0; i < contactNumber!.length; i++) {
        json.addAll({
          'contactNumbers[$i]': contactNumber![i].toJson(),
        });
      }
    }
    return json;
  }

  FormData toFormData() {
    FormData formData = FormData();

    // add string fields to form data
    formData.fields.addAll([
      MapEntry('id', id ?? ''),
      MapEntry('farmId', farmId.toString()),
      MapEntry('name', name ?? ''),
      MapEntry('area', area.toString()),
      MapEntry('units', units ?? ''),
      MapEntry('salinity', salinity.toString()),
      MapEntry('deviceId', deviceId ?? ''),
      MapEntry('cultureType', cultureType ?? ''),
      MapEntry("pondStatus", pondStatus ?? 'Active'),
      MapEntry('daysOfCulture', daysOfCulture.toString()),
      MapEntry('totalSeed', totalSeed.toString()),
      MapEntry('watchList', watchList.toString()),
      MapEntry('serialNo.PH', serialNo?.pH ?? ''),
      MapEntry('serialNo.DO', serialNo?.dO ?? ''),
      if (serialNo?.eC != null) MapEntry('serialNo.EC', serialNo?.eC ?? ''),
      if (serialNo?.nH4 != null) MapEntry('serialNo.NH4', serialNo?.nH4 ?? ''),
      if (serialNo?.nO3 != null) MapEntry('serialNo.NO3', serialNo?.nO3 ?? ''),
    ]);

    // add contact numbers to form data
    if (contactNumber != null) {
      for (int i = 0; i < contactNumber!.length; i++) {
        formData.fields.addAll([
          MapEntry(
              'contactNumbers[$i][mobile]', contactNumber![i].number ?? ''),
          MapEntry(
              'contactNumbers[$i][role]', contactNumber![i].pondRole ?? ''),
        ]);
      }
    }
    return formData;
  }

  // copyWith
  PondModel copyWith({
    String? id,
    int? pondId,
    int? farmId,
    String? name,
    String? imageUrl,
    int? area,
    String? units,
    int? salinity,
    String? deviceId,
    String? cultureType,
    int? daysOfCulture,
    int? totalSeed,
    int? status,
    File? image,
    List<ContactNumbers>? contactNumber,
    SerialNo? serialNo,
    String? aeratorPlan,
    List<String>? pondAeratorIds,
    String? pondStatus,
    List<FarmYieldState>? yieldState,
    DerivedValues? derivedValues,
    bool? watchList,
    int? createdOn,
  }) {
    return PondModel(
      id: id ?? this.id,
      pondId: pondId ?? this.pondId,
      farmId: farmId ?? this.farmId,
      name: name ?? this.name,
      imageUrl: imageUrl ?? this.imageUrl,
      area: area ?? this.area,
      units: units ?? this.units,
      salinity: salinity ?? this.salinity,
      deviceId: deviceId ?? this.deviceId,
      cultureType: cultureType ?? this.cultureType,
      daysOfCulture: daysOfCulture ?? this.daysOfCulture,
      totalSeed: totalSeed ?? this.totalSeed,
      image: image ?? this.image,
      contactNumber: contactNumber ?? this.contactNumber,
      serialNo: serialNo ?? this.serialNo,
      aeratorPlan: aeratorPlan ?? this.aeratorPlan,
      pondAeratorIds: pondAeratorIds ?? this.pondAeratorIds,
      pondStatus: pondStatus ?? this.pondStatus,
      yieldState: yieldState ?? this.yieldState,
      derivedValues: derivedValues?.obs ?? this.derivedValues,
      watchList: watchList ?? this.watchList,
      createdOn: createdOn ?? this.createdOn,
    );
  }

}

class DerivedValues {
  double? pH;
  double? dO;
  double? eC;
  double? nH4;
  double? nO3;
  double? temperature;
  double? nh3;
  double? no2;
  double? tan;
  int? derivedTime;
  bool sensorLiveStatus = true;
  int? pondId;
  String? pondStatus;

  DerivedValues({
    this.pH,
    this.dO,
    this.eC,
    this.nH4,
    this.nO3,
    this.temperature,
    this.nh3,
    this.no2,
    this.tan,
    this.derivedTime,
    this.sensorLiveStatus = true,
    this.pondId,
    this.pondStatus,
  });

  DateTime get derivedDateTime {
    return DateTime.fromMillisecondsSinceEpoch(derivedTime!);
  }

  DerivedValues.fromJson(Map<String, dynamic> json) {
    pH = json['PH'] != null ? double.parse(json['PH'].toString()) : null;
    dO = json['DO'] != null ? double.parse(json['DO'].toString()) : null;
    eC = json['EC'] != null ? double.parse(json['EC'].toString()) : null;
    nH4 = json['NH4'] != null ? double.parse(json['NH4'].toString()) : null;
    nO3 = json['NO3'] != null ? double.parse(json['NO3'].toString()) : null;
    temperature = json['Temperature'] != null
        ? double.parse(json['Temperature'].toString())
        : null;
    nh3 = json['NH3'] != null ? double.parse(json['NH3'].toString()) : null;
    no2 = json['NO2'] != null ? double.parse(json['NO2'].toString()) : null;
    tan = json['TAN'] != null ? double.parse(json['TAN'].toString()) : null;
    derivedTime = json['derivedTime'] != null
        ? int.parse(json['derivedTime'].toString())
        : null;
    sensorLiveStatus = json['sensorLiveStatus'] ?? true;
    pondId =
        json['pondId'] != null ? int.parse(json['pondId'].toString()) : null;
    pondStatus = json['pondStatus'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['PH'] = pH;
    data['DO'] = dO;
    data['EC'] = eC;
    data['NH4'] = nH4;
    data['NO3'] = nO3;
    data['Temperature'] = temperature;
    data['NH3'] = nh3;
    data['NO2'] = no2;
    data["TAN"] = tan;
    data['derivedTime'] = derivedTime;
    // data['sensorLiveStatus'] = sensorLiveStatus;
    data['pondId'] = pondId;
    data["pondStatus"] = pondStatus;

    return data;
  }
}

class ContactNumbers {
  String? number;
  String? pondRole;

  ContactNumbers({this.number, this.pondRole});

  factory ContactNumbers.fromMap(Map<String, dynamic> json) {
    return ContactNumbers(
      number: "${json['mobile']}",
      pondRole: json['role'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'mobile': number,
      'role': pondRole,
    };
  }
}

class SerialNo {
  String? pH;
  String? dO;
  String? eC;
  String? nH4;
  String? nO3;

  SerialNo({this.pH, this.dO, this.eC, this.nH4, this.nO3});

  SerialNo.fromJson(Map<String, dynamic> json) {
    pH = json['PH'];
    dO = json['DO'];
    eC = json['EC'];
    nH4 = json['NH4'];
    nO3 = json['NO3'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['PH'] = pH;
    data['DO'] = dO;
    data['EC'] = eC;
    data['NH4'] = nH4;
    data['NO3'] = nO3;
    return data;
  }
}

class FarmYieldState {
  int? pontId;
  int? readyToYield;
  int? pondCulturedDays;

  FarmYieldState({
    this.pontId,
    this.readyToYield,
    this.pondCulturedDays,
  });

  factory FarmYieldState.fromMap(Map<String, dynamic> json) {
    return FarmYieldState(
      pontId: json['pondId'],
      readyToYield: json['readyToYield'],
      pondCulturedDays: json['pondCulturedDays'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'pondId': pontId,
      'readyToYield': readyToYield,
      'pondCulturedDays': pondCulturedDays,
    };
  }
}
