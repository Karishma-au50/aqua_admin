import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../model/calibration_values.dart';
import '../../../../shared/constant/font_helper.dart';
import '../../../../shared/constant/global_variables.dart';
import '../../../../shared/widgets/buttons/my_button.dart';
import '../../../../shared/widgets/inputs/my_text_field.dart';
import '../../controller/sensor_controller.dart';

class SensorCalibration extends StatefulWidget {
  const SensorCalibration({
    super.key,
  });

  @override
  State<SensorCalibration> createState() => _SensorCalibrationState();
}

class _SensorCalibrationState extends State<SensorCalibration> {
  List<CalibrationValues> calibrationValues = [];
  bool isLoad = false;

  final SensorController controller = Get.put(SensorController());
  TextEditingController doMvInAirController = TextEditingController();
  TextEditingController phBuffer4Controller = TextEditingController();
  TextEditingController phBuffer7Controller = TextEditingController();
  TextEditingController phBuffer9Controller = TextEditingController();
  TextEditingController lowNH4Controller = TextEditingController();
  TextEditingController highNH4Controller = TextEditingController();
  TextEditingController lowNo3Controller = TextEditingController();
  TextEditingController highN03Controller = TextEditingController();
  TextEditingController ecController = TextEditingController();

  TextEditingController nh4LowSensorController = TextEditingController();
  TextEditingController nh4HighSensorController = TextEditingController();

  TextEditingController no3LowSensorController = TextEditingController();
  TextEditingController no3HighSensorController = TextEditingController();

  TextEditingController ecSensorController = TextEditingController();
  bool isSubmit = false;
  Future fetchCalibrationValues() async {
    setState(() {
      isLoad = true;
    });
    calibrationValues =
        await controller.fetchCalibrationValues(Get.parameters['pondId']!);

    _setCalibrationValues();

    setState(() {
      isLoad = false;
    });
  }

  void _setCalibrationValues() {
    if (calibrationValues.isEmpty) return;
    try {
      doMvInAirController.text = calibrationValues
          .firstWhere((element) =>
              element.sensorType == "DO" && element.subSensorItem == "mvInAir")
          .sensorRecordedValue
          .toString();
    } catch (e) {}

    try {
      phBuffer4Controller.text = calibrationValues
          .firstWhere((element) =>
              element.sensorType == "PH" && element.subSensorItem == "buffer4")
          .sensorRecordedValue
          .toString();
    } catch (e) {}

    try {
      phBuffer7Controller.text = calibrationValues
          .firstWhere((element) =>
              element.sensorType == "PH" && element.subSensorItem == "buffer7")
          .sensorRecordedValue
          .toString();
    } catch (e) {}

    try {
      phBuffer9Controller.text = calibrationValues
          .firstWhere((element) =>
              element.sensorType == "PH" && element.subSensorItem == "buffer9")
          .sensorRecordedValue
          .toString();
    } catch (e) {}
    try {
      var val = calibrationValues.firstWhere((element) =>
          element.sensorType == "NH4" && element.subSensorItem == "mgPerLow");
      lowNH4Controller.text = val.sensorRecordedValue.toString();
      nh4LowSensorController.text = val.subSensorItemValue ?? "0.1";
    } catch (e) {}
    try {
      var val = calibrationValues.firstWhere((element) =>
          element.sensorType == "NH4" && element.subSensorItem == "mgPerHigh");
      highNH4Controller.text = val.sensorRecordedValue.toString();
      nh4HighSensorController.text = val.subSensorItemValue ?? "1";
    } catch (e) {}
    try {
      var val = calibrationValues.firstWhere((element) =>
          element.sensorType == "NO3" && element.subSensorItem == "mgPerLow");
      lowNo3Controller.text = val.sensorRecordedValue.toString();
      no3LowSensorController.text = val.subSensorItemValue ?? "0.1";
    } catch (e) {}
    try {
      var val = calibrationValues.firstWhere((element) =>
          element.sensorType == "NO3" && element.subSensorItem == "mgPerHigh");
      highN03Controller.text = val.sensorRecordedValue.toString();
      no3HighSensorController.text = val.subSensorItemValue ?? "1";
    } catch (e) {}
    try {
      var val = calibrationValues.firstWhere((element) =>
          element.sensorType == "EC" && element.subSensorItem == "muPerCM");
      ecController.text = val.sensorRecordedValue.toString();
      ecSensorController.text = val.subSensorItemValue ?? "84";
    } catch (e) {}
  }

  @override
  void initState() {
    super.initState();
    fetchCalibrationValues();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 800),
          child: ListView(
            padding: EdgeInsets.zero.copyWith(left: 40, right: 40, top: 40),
            physics: const BouncingScrollPhysics(),
            shrinkWrap: true,
            children: [
              const SizedBox(height: 30),
              Row(
                children: [
                  Expanded(
                    flex: 6,
                    child: MyTextField(
                      controller: doMvInAirController,
                      hintText: "Do mV in Air",
                      labelStyle: GlobalFonts.ts14px700w,
                      textStyle: GlobalFonts.ts20px500w(),
                      isValidate: false,
                      // onChanged: (newValue) {
                      //   doMvInAirController.text = newValue;
                      // },
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    flex: 3,
                    child: MyButton(
                        text: "UPDATE",
                        textStyle: GlobalFonts.ts14px500w,
                        height: 50,
                        textColor: greenColor,
                        color: const Color(0xFFE1F1EC).withOpacity(0.5),
                        borderColor: const Color(0xFF166351),
                        boxShadow: const [
                          BoxShadow(
                            color: Color.fromRGBO(22, 99, 81, 0.04),
                            blurRadius: 10.0,
                            spreadRadius: -2.0,
                            offset: Offset(0.0, 6.0),
                          ),
                          BoxShadow(
                            color: Color.fromRGBO(22, 99, 81, 0.02),
                            blurRadius: 4.0,
                            spreadRadius: -2.0,
                            offset: Offset(0.0, 2.0),
                          ),
                        ],
                        onPressed: () async {
                          var id = calibrationValues.isNotEmpty
                              ? calibrationValues
                                  .firstWhereOrNull((element) =>
                                      element.sensorType == 'DO' &&
                                      element.subSensorItem == 'mvInAir')
                                  ?.id
                              : null;

                          await controller.updateSensorCaliberation(
                              id.toString(), doMvInAirController.text, '');
                        }),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Text(
                "PH Sensor",
                style: GlobalFonts.ts20px700w(),
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    flex: 6,
                    child: MyTextField(
                      controller: phBuffer4Controller,
                      hintText: "Buffer 4.0",
                      labelStyle: GlobalFonts.ts12px700w,
                      textStyle: GlobalFonts.ts20px500w(),
                      isValidate: false,
                      // onChanged: (newValue) {
                      //   phBuffer4Controller.text = newValue;
                      // },
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    flex: 3,
                    child: MyButton(
                      height: 49,
                      text: "UPDATE",
                      textStyle: GlobalFonts.ts14px500w,
                      textColor: greenColor,
                      color: const Color(0xFFE1F1EC).withOpacity(0.5),
                      borderColor: const Color(0xFF166351),
                      boxShadow: const [
                        BoxShadow(
                          color: Color.fromRGBO(22, 99, 81, 0.04),
                          blurRadius: 10.0,
                          spreadRadius: -2.0,
                          offset: Offset(0.0, 6.0),
                        ),
                        BoxShadow(
                          color: Color.fromRGBO(22, 99, 81, 0.02),
                          blurRadius: 4.0,
                          spreadRadius: -2.0,
                          offset: Offset(0.0, 2.0),
                        ),
                      ],
                      onPressed: () async {
                        var id = calibrationValues.isNotEmpty
                            ? calibrationValues
                                .firstWhereOrNull((element) =>
                                    element.sensorType == 'PH' &&
                                    element.subSensorItem == 'buffer4')
                                ?.id
                            : null;

                        await controller.updateSensorCaliberation(
                            id.toString(), phBuffer4Controller.text, '');
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                    flex: 6,
                    child: MyTextField(
                      controller: phBuffer7Controller,
                      hintText: "Buffer 7.0",
                      labelStyle: GlobalFonts.ts12px700w,
                      textStyle: GlobalFonts.ts20px500w(),
                      isValidate: false,
                      // onChanged: (newValue) {
                      //   phBuffer7Controller.text = newValue;
                      // },
                      //isReadOny: true,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    flex: 3,
                    child: MyButton(
                      height: 49,
                      text: "UPDATE",
                      textStyle: GlobalFonts.ts14px500w,
                      textColor: greenColor,
                      color: const Color(0xFFE1F1EC).withOpacity(0.5),
                      borderColor: const Color(0xFF166351),
                      boxShadow: const [
                        BoxShadow(
                          color: Color.fromRGBO(22, 99, 81, 0.04),
                          blurRadius: 10.0,
                          spreadRadius: -2.0,
                          offset: Offset(0.0, 6.0),
                        ),
                        BoxShadow(
                          color: Color.fromRGBO(22, 99, 81, 0.02),
                          blurRadius: 4.0,
                          spreadRadius: -2.0,
                          offset: Offset(0.0, 2.0),
                        ),
                      ],
                      onPressed: () async {
                        var id = calibrationValues.isNotEmpty
                            ? calibrationValues
                                .firstWhereOrNull((element) =>
                                    element.sensorType == 'PH' &&
                                    element.subSensorItem == 'buffer7')
                                ?.id
                            : null;

                        await controller.updateSensorCaliberation(
                            id.toString(), phBuffer7Controller.text, '');
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                    flex: 6,
                    child: MyTextField(
                      controller: phBuffer9Controller,
                      hintText: "Buffer 9.2",
                      labelStyle: GlobalFonts.ts12px700w,
                      textStyle: GlobalFonts.ts20px500w(),
                      isValidate: false,
                      // onChanged: (newValue) {
                      //   phBuffer9Controller.text = newValue;
                      // },
                      //isReadOny: true,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    flex: 3,
                    child: MyButton(
                      height: 49,
                      text: "UPDATE",
                      textStyle: GlobalFonts.ts14px500w,
                      textColor: greenColor,
                      color: const Color(0xFFE1F1EC).withOpacity(0.5),
                      borderColor: const Color(0xFF166351),
                      boxShadow: const [
                        BoxShadow(
                          color: Color.fromRGBO(22, 99, 81, 0.04),
                          blurRadius: 10.0,
                          spreadRadius: -2.0,
                          offset: Offset(0.0, 6.0),
                        ),
                        BoxShadow(
                          color: Color.fromRGBO(22, 99, 81, 0.02),
                          blurRadius: 4.0,
                          spreadRadius: -2.0,
                          offset: Offset(0.0, 2.0),
                        ),
                      ],
                      onPressed: () async {
                        var id = calibrationValues.isNotEmpty
                            ? calibrationValues
                                .firstWhereOrNull((element) =>
                                    element.sensorType == 'PH' &&
                                    element.subSensorItem == 'buffer9')
                                ?.id
                            : null;

                        await controller.updateSensorCaliberation(
                            id.toString(), phBuffer9Controller.text, '');
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Text(
                "Ammonium Sensor (NH4+)",
                style: GlobalFonts.ts20px700w(),
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    flex: 3,
                    child: DropdownFormField(
                      controller: nh4LowSensorController,
                      hintText: "mg/L",
                      labelStyle: GlobalFonts.ts12px700w,
                      textStyle: GlobalFonts.ts20px500w(),
                      dropDownItems: nh4no3subSensorValues,
                      value: nh4no3subSensorValues[0],
                      onChange: (p0) {
                        try {
                          nh4HighSensorController.text = nh4no3subSensorValues[
                              nh4no3subSensorValues.indexOf(p0) + 1];
                        } catch (e) {}
                      },
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    flex: 3,
                    child: MyTextField(
                      controller: lowNH4Controller,
                      hintText: "Low",
                      labelStyle: GlobalFonts.ts12px700w,
                      textStyle: GlobalFonts.ts20px500w(),
                      isValidate: false,
                      // onChanged: (newValue) {
                      //   lowNH4Controller.text = newValue;
                      // },
                      //isReadOny: true,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    flex: 3,
                    child: MyButton(
                      height: 49,
                      text: "UPDATE",
                      textStyle: GlobalFonts.ts14px500w,
                      textColor: greenColor,
                      color: const Color(0xFFE1F1EC).withOpacity(0.5),
                      borderColor: const Color(0xFF166351),
                      boxShadow: const [
                        BoxShadow(
                          color: Color.fromRGBO(22, 99, 81, 0.04),
                          blurRadius: 10.0,
                          spreadRadius: -2.0,
                          offset: Offset(0.0, 6.0),
                        ),
                        BoxShadow(
                          color: Color.fromRGBO(22, 99, 81, 0.02),
                          blurRadius: 4.0,
                          spreadRadius: -2.0,
                          offset: Offset(0.0, 2.0),
                        ),
                      ],
                      onPressed: () async {
                        var id = calibrationValues.isNotEmpty
                            ? calibrationValues
                                .firstWhereOrNull((element) =>
                                    element.sensorType == 'NH4' &&
                                    element.subSensorItem == 'mgPerLow')
                                ?.id
                            : null;

                        await controller.updateSensorCaliberation(id.toString(),
                            lowNH4Controller.text, nh4LowSensorController.text);
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                    flex: 3,
                    child: DropdownFormField(
                      controller: nh4HighSensorController,
                      hintText: "mg/L",
                      labelStyle: GlobalFonts.ts12px700w,
                      textStyle: GlobalFonts.ts20px500w(),
                      dropDownItems: nh4no3subSensorValues,
                      value: nh4no3subSensorValues[1],
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    flex: 3,
                    child: MyTextField(
                      controller: highNH4Controller,
                      hintText: "High",
                      labelStyle: GlobalFonts.ts12px700w,
                      textStyle: GlobalFonts.ts20px500w(),
                      isValidate: false,
                      // onChanged: (newValue) {
                      //   highNH4Controller.text = newValue;
                      // },
                      //isReadOny: true,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    flex: 3,
                    child: MyButton(
                      height: 49,
                      text: "UPDATE",
                      textStyle: GlobalFonts.ts14px500w,
                      textColor: greenColor,
                      color: const Color(0xFFE1F1EC).withOpacity(0.5),
                      borderColor: const Color(0xFF166351),
                      boxShadow: const [
                        BoxShadow(
                          color: Color.fromRGBO(22, 99, 81, 0.04),
                          blurRadius: 10.0,
                          spreadRadius: -2.0,
                          offset: Offset(0.0, 6.0),
                        ),
                        BoxShadow(
                          color: Color.fromRGBO(22, 99, 81, 0.02),
                          blurRadius: 4.0,
                          spreadRadius: -2.0,
                          offset: Offset(0.0, 2.0),
                        ),
                      ],
                      onPressed: () async {
                        var id = calibrationValues.isNotEmpty
                            ? calibrationValues
                                .firstWhereOrNull((element) =>
                                    element.sensorType == 'NH4' &&
                                    element.subSensorItem == 'mgPerHigh')
                                ?.id
                            : null;

                        await controller.updateSensorCaliberation(
                            id.toString(),
                            highNH4Controller.text,
                            nh4HighSensorController.text);
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Text(
                "Nitrate (NO3-) Sensor",
                style: GlobalFonts.ts20px700w(),
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    flex: 3,
                    child: DropdownFormField(
                      controller: no3LowSensorController,
                      hintText: "mg/L",
                      labelStyle: GlobalFonts.ts12px700w,
                      textStyle: GlobalFonts.ts20px500w(),
                      dropDownItems: nh4no3subSensorValues,
                      value: nh4no3subSensorValues[0],
                      onChange: (p0) {
                        try {
                          no3HighSensorController.text = nh4no3subSensorValues[
                              nh4no3subSensorValues.indexOf(p0) + 1];
                        } catch (e) {}
                      },
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    flex: 3,
                    child: MyTextField(
                      controller: lowNo3Controller,
                      labelStyle: GlobalFonts.ts12px700w,
                      textStyle: GlobalFonts.ts20px500w(),
                      hintText: "Low",
                      // onChanged: (newValue) {
                      //   lowNo3Controller.text = newValue;
                      // },
                      //isReadOny: true,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    flex: 3,
                    child: MyButton(
                      height: 49,
                      text: "UPDATE",
                      textStyle: GlobalFonts.ts14px500w,
                      textColor: greenColor,
                      color: const Color(0xFFE1F1EC).withOpacity(0.5),
                      borderColor: const Color(0xFF166351),
                      boxShadow: const [
                        BoxShadow(
                          color: Color.fromRGBO(22, 99, 81, 0.04),
                          blurRadius: 10.0,
                          spreadRadius: -2.0,
                          offset: Offset(0.0, 6.0),
                        ),
                        BoxShadow(
                          color: Color.fromRGBO(22, 99, 81, 0.02),
                          blurRadius: 4.0,
                          spreadRadius: -2.0,
                          offset: Offset(0.0, 2.0),
                        ),
                      ],
                      onPressed: () async {
                        var id = calibrationValues.isNotEmpty
                            ? calibrationValues
                                .firstWhereOrNull((element) =>
                                    element.sensorType == 'NO3' &&
                                    element.subSensorItem == 'mgPerLow')
                                ?.id
                            : null;
                        await controller.updateSensorCaliberation(id.toString(),
                            lowNo3Controller.text, no3LowSensorController.text);
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                    flex: 3,
                    child: DropdownFormField(
                      controller: no3HighSensorController,
                      hintText: "mg/L",
                      labelStyle: GlobalFonts.ts12px700w,
                      textStyle: GlobalFonts.ts20px500w(),
                      dropDownItems: nh4no3subSensorValues,
                      value: nh4no3subSensorValues[1],
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    flex: 3,
                    child: MyTextField(
                      controller: highN03Controller,
                      hintText: "High",
                      labelStyle: GlobalFonts.ts12px700w,
                      textStyle: GlobalFonts.ts20px500w(),
                      isValidate: false,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    flex: 3,
                    child: MyButton(
                        height: 49,
                        text: "UPDATE",
                        textStyle: GlobalFonts.ts14px500w,
                        textColor: greenColor,
                        color: const Color(0xFFE1F1EC).withOpacity(0.5),
                        borderColor: const Color(0xFF166351),
                        boxShadow: const [
                          BoxShadow(
                            color: Color.fromRGBO(22, 99, 81, 0.04),
                            blurRadius: 10.0,
                            spreadRadius: -2.0,
                            offset: Offset(0.0, 6.0),
                          ),
                          BoxShadow(
                            color: Color.fromRGBO(22, 99, 81, 0.02),
                            blurRadius: 4.0,
                            spreadRadius: -2.0,
                            offset: Offset(0.0, 2.0),
                          ),
                        ],
                        onPressed: () async {
                          var id = calibrationValues.isNotEmpty
                              ? calibrationValues
                                  .firstWhereOrNull((element) =>
                                      element.sensorType == 'NO3' &&
                                      element.subSensorItem == 'mgPerHigh')
                                  ?.id
                              : null;

                          await controller.updateSensorCaliberation(
                              id.toString(),
                              highN03Controller.text,
                              no3HighSensorController.text);
                        }),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Text(
                "EC Sensor",
                style: GlobalFonts.ts20px700w(),
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    flex: 3,
                    child: DropdownFormField(
                      controller: ecSensorController,
                      hintText: "µS/cm",
                      labelStyle: GlobalFonts.ts12px700w,
                      textStyle: GlobalFonts.ts20px500w(),
                      dropDownItems: ecSubSesnsorValues,
                      value: ecSubSesnsorValues[0],
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    flex: 3,
                    child: MyTextField(
                      controller: ecController,
                      hintText: "Standard",
                      labelStyle: GlobalFonts.ts12px700w,
                      textStyle: GlobalFonts.ts20px500w(),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    flex: 3,
                    child: MyButton(
                      height: 49,
                      text: "UPDATE",
                      textStyle: GlobalFonts.ts14px500w,
                      textColor: greenColor,
                      color: const Color(0xFFE1F1EC).withOpacity(0.5),
                      borderColor: const Color(0xFF166351),
                      boxShadow: const [
                        BoxShadow(
                          color: Color.fromRGBO(22, 99, 81, 0.04),
                          blurRadius: 10.0,
                          spreadRadius: -2.0,
                          offset: Offset(0.0, 6.0),
                        ),
                        BoxShadow(
                          color: Color.fromRGBO(22, 99, 81, 0.02),
                          blurRadius: 4.0,
                          spreadRadius: -2.0,
                          offset: Offset(0.0, 2.0),
                        ),
                      ],
                      onPressed: () async {
                        var id = calibrationValues.isNotEmpty
                            ? calibrationValues
                                .firstWhereOrNull((element) =>
                                    element.sensorType == 'EC' &&
                                    element.subSensorItem == 'muPerCM')
                                ?.id
                            : null;

                        await controller.updateSensorCaliberation(
                            id!, ecController.text, ecSensorController.text);
                      },
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
