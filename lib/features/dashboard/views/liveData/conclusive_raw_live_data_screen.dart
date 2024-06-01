import 'package:admin/model/conclusive_Raw_data_model.dart';
import 'package:admin/shared/widgets/toast/my_toast.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../../shared/constant/font_helper.dart';
import '../../../../shared/widgets/buttons/my_button.dart';
import '../../../../shared/widgets/inputs/my_text_field.dart';
import '../../controller/dashboard_controller.dart';

class ConclusiveOrRawLiveDataScreen extends StatefulWidget {
  const ConclusiveOrRawLiveDataScreen({super.key, this.id});
  final String? id;

  @override
  State<ConclusiveOrRawLiveDataScreen> createState() =>
      _ConclusiveOrRawLiveDataScreenState();
}

class _ConclusiveOrRawLiveDataScreenState
    extends State<ConclusiveOrRawLiveDataScreen> {
  final SensorController controller = Get.put(SensorController());
  TextEditingController typeIdController = TextEditingController();
  TextEditingController dlNoController = TextEditingController();
  TextEditingController networkNoController = TextEditingController();

  TextEditingController countController = TextEditingController();
  String countValue = "10";
  String typeValue = "ConclusiveData";
  RxList<ConclusiveOrRawDataModel> conclusiveOrRawData =
      <ConclusiveOrRawDataModel>[].obs;
  final _formKey = GlobalKey<FormState>();
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // hideBack: true,
      body: Column(
        children: [
          const SizedBox(
            height: 40,
          ),
          Form(
            key: _formKey,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: MyTextField(
                    controller: typeIdController,
                    hintText: "Type ID",
                    textStyle: GlobalFonts.ts20px500w(),
                    labelText: "TypeID",
                    isValidate: true,
                    validator: (value) {
                      if (value.isEmpty) {
                        return "required";
                      }
                      return "";
                    },
                  ),
                ),
                Expanded(
                  child: MyTextField(
                    controller: dlNoController,
                    hintText: "dlno",
                    textStyle: GlobalFonts.ts20px500w(),
                    labelText: "dlno",
                    isValidate: true,
                    validator: (value) {
                      if (value.isEmpty) {
                        return "required";
                      }
                      return "";
                    },
                  ),
                ),
                Expanded(
                  child: MyTextField(
                    controller: networkNoController,
                    hintText: "Network No",
                    textStyle: GlobalFonts.ts20px500w(),
                    labelText: "Network Number",
                    isValidate: true,
                    validator: (value) {
                      if (value.isEmpty) {
                        return "required";
                      }
                      return "";
                    },
                  ),
                ),
                Expanded(
                  child: MyTextField(
                    controller: countController,
                    hintText: "count",
                    textStyle: GlobalFonts.ts20px500w(),
                    labelText: "Count",
                    isValidate: true,
                    validator: (value) {
                      if (value.isEmpty) {
                        return "required";
                      }
                      return "";
                    },
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          // dropdowns and submit button
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: DropdownFormField(
                    hintText: "Collection Type",
                    value: typeValue,
                    dropDownItems: const ['ConclusiveData', 'RawData'],
                    onChange: (value) {
                      typeValue = value;
                    },
                  ),
                ),
                const SizedBox(
                  width: 22,
                ),
                Expanded(
                  child: MyButton(
                    text: "Submit",
                    height: 47,
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        try {
                          final finalCollectionType =
                              typeValue == 'ConclusiveData' ? 1 : 2;
                          controller
                              .conclusiveOrRawLiveData(
                            typeIdController.text,
                            dlNoController.text,
                            networkNoController.text,
                            finalCollectionType.toString(),
                            countController.text,
                          )
                              .then((value) {
                            if (value != null) {
                              conclusiveOrRawData(value);
                            }
                          });
                        } catch (e) {
                          MyToasts.toastError("Not Able To Fetch The Data");
                        }
                      }
                    },
                  ),
                )
              ],
            ),
          ),
          const SizedBox(
            height: 14,
          ),
          // conclusive data table
          Obx(() {
            return conclusiveOrRawData.isEmpty
                ? const Center(child: Text("No Data Found"))
                : Expanded(
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: SingleChildScrollView(
                        scrollDirection: Axis.vertical,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10.0),
                          child: DataTable(
                            headingRowColor: MaterialStateColor.resolveWith(
                              (states) {
                                return const Color.fromARGB(255, 237, 244, 214);
                              },
                            ),
                            horizontalMargin: 0,
                            columnSpacing: 1.2,
                            border: TableBorder.all(),
                            columns: typeValue == "ConclusiveData"
                                ? [
                                    DataColumn(
                                      label: SizedBox(
                                        width: 100,
                                        child: Center(
                                          child: Text(
                                            "Network No",
                                            style: GlobalFonts.ts14px600w,
                                            textAlign: TextAlign.center,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                      ),
                                      // fixedWidth: 80,
                                    ),
                                    DataColumn(
                                      label: SizedBox(
                                        width: 100,
                                        child: Center(
                                          child: Text(
                                            "dlNo",
                                            style: GlobalFonts.ts14px600w,
                                            textAlign: TextAlign.center,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                      ),
                                      // fixedWidth: 80,
                                    ),
                                    DataColumn(
                                      label: SizedBox(
                                        width: 100,
                                        child: Center(
                                          child: Text(
                                            "SeqNo",
                                            style: GlobalFonts.ts14px600w,
                                            textAlign: TextAlign.center,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                      ),
                                      // fixedWidth: 80,
                                    ),
                                    DataColumn(
                                      label: SizedBox(
                                        width: 100,
                                        child: Center(
                                          child: Text(
                                            "Analog ID",
                                            style: GlobalFonts.ts14px600w,
                                            textAlign: TextAlign.center,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                      ),
                                      // fixedWidth: 80,
                                    ),
                                    DataColumn(
                                      label: SizedBox(
                                        width: 100,
                                        child: Center(
                                          child: Text(
                                            "Type ID",
                                            style: GlobalFonts.ts14px600w,
                                            textAlign: TextAlign.center,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                      ),
                                      // fixedWidth: 80,
                                    ),
                                    DataColumn(
                                      label: SizedBox(
                                        width: 100,
                                        child: Center(
                                          child: Text(
                                            "LocationNo",
                                            style: GlobalFonts.ts14px600w,
                                            textAlign: TextAlign.center,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                      ),
                                      // fixedWidth: 80,
                                    ),
                                    DataColumn(
                                      label: SizedBox(
                                        width: 100,
                                        child: Center(
                                          child: Text(
                                            "Year",
                                            style: GlobalFonts.ts14px600w,
                                            textAlign: TextAlign.center,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                      ),
                                      // fixedWidth: 80,
                                    ),
                                    DataColumn(
                                      label: SizedBox(
                                        width: 100,
                                        child: Center(
                                          child: Text(
                                            "lTime",
                                            style: GlobalFonts.ts14px600w,
                                            textAlign: TextAlign.center,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                      ),
                                      // fixedWidth: 80,
                                    ),
                                    DataColumn(
                                      label: SizedBox(
                                        width: 120,
                                        child: Center(
                                          child: Text(
                                            "Voltage Status",
                                            style: GlobalFonts.ts14px600w,
                                            textAlign: TextAlign.center,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                      ),
                                      // fixedWidth: 80,
                                    ),
                                    DataColumn(
                                      label: SizedBox(
                                        width: 150,
                                        child: Center(
                                          child: Text(
                                            "Recieved Time",
                                            style: GlobalFonts.ts14px600w,
                                            textAlign: TextAlign.center,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                      ),
                                      // fixedWidth: 80,
                                    ),
                                  ]
                                :
                                // raw data column
                                [
                                    DataColumn(
                                      label: SizedBox(
                                        width: 100,
                                        child: Center(
                                          child: Text(
                                            "Network No",
                                            style: GlobalFonts.ts14px600w,
                                            textAlign: TextAlign.center,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                      ),
                                      // fixedWidth: 80,
                                    ),
                                    DataColumn(
                                      label: SizedBox(
                                        width: 100,
                                        child: Center(
                                          child: Text(
                                            "dlNo",
                                            style: GlobalFonts.ts14px600w,
                                            textAlign: TextAlign.center,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                      ),
                                      // fixedWidth: 80,
                                    ),
                                    DataColumn(
                                      label: SizedBox(
                                        width: 100,
                                        child: Center(
                                          child: Text(
                                            "SeqNo",
                                            style: GlobalFonts.ts14px600w,
                                            textAlign: TextAlign.center,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                      ),
                                      // fixedWidth: 80,
                                    ),

                                    DataColumn(
                                      label: SizedBox(
                                        width: 100,
                                        child: Center(
                                          child: Text(
                                            "Type ID",
                                            style: GlobalFonts.ts14px600w,
                                            textAlign: TextAlign.center,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                      ),
                                      // fixedWidth: 80,
                                    ),
                                    DataColumn(
                                      label: SizedBox(
                                        width: 100,
                                        child: Center(
                                          child: Text(
                                            "Byte 1",
                                            style: GlobalFonts.ts14px600w,
                                            textAlign: TextAlign.center,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                      ),
                                      // fixedWidth: 80,
                                    ),
                                    DataColumn(
                                      label: SizedBox(
                                        width: 100,
                                        child: Center(
                                          child: Text(
                                            "Byte 2",
                                            style: GlobalFonts.ts14px600w,
                                            textAlign: TextAlign.center,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                      ),
                                      // fixedWidth: 80,
                                    ),
                                    DataColumn(
                                      label: SizedBox(
                                        width: 100,
                                        child: Center(
                                          child: Text(
                                            "Byte 3",
                                            style: GlobalFonts.ts14px600w,
                                            textAlign: TextAlign.center,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                      ),
                                      // fixedWidth: 80,
                                    ),
                                    // DataColumn(
                                    //   label: SizedBox(
                                    //     width: 100,
                                    //     child: Center(
                                    //       child: Text(
                                    //         "Location No",
                                    //         style: GlobalFonts.ts14px600w,
                                    //         textAlign: TextAlign.center,
                                    //         overflow: TextOverflow.ellipsis,
                                    //       ),
                                    //     ),
                                    //   ),
                                    //   // fixedWidth: 80,
                                    // ),
                                    DataColumn(
                                      label: SizedBox(
                                        width: 100,
                                        child: Center(
                                          child: Text(
                                            "Year",
                                            style: GlobalFonts.ts14px600w,
                                            textAlign: TextAlign.center,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                      ),
                                      // fixedWidth: 80,
                                    ),
                                    DataColumn(
                                      label: SizedBox(
                                        width: 100,
                                        child: Center(
                                          child: Text(
                                            "lTime",
                                            style: GlobalFonts.ts14px600w,
                                            textAlign: TextAlign.center,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                      ),
                                      // fixedWidth: 80,
                                    ),

                                    DataColumn(
                                      label: SizedBox(
                                        width: 150,
                                        child: Center(
                                          child: Text(
                                            "Recieved Time",
                                            style: GlobalFonts.ts14px600w,
                                            textAlign: TextAlign.center,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                      ),
                                      // fixedWidth: 80,
                                    ),
                                  ],
                            rows: conclusiveOrRawData.map(
                              (data) {
                                return DataRow(
                                  cells: typeValue == 'ConclusiveData'
                                      ? <DataCell>[
                                          DataCell(
                                            Center(
                                              child: Text(
                                                  data.networkNo != null
                                                      ? data.networkNo
                                                          .toString()
                                                      : '-',
                                                  style:
                                                      GlobalFonts.ts14px500w),
                                            ),
                                          ),
                                          DataCell(
                                            Center(
                                              child: Text(
                                                  data.dlNo != null
                                                      ? data.dlNo.toString()
                                                      : "-",
                                                  style:
                                                      GlobalFonts.ts14px500w),
                                            ),
                                          ),
                                          DataCell(
                                            Center(
                                              child: Text(
                                                  data.seqNo != null
                                                      ? data.analogId.toString()
                                                      : '-',
                                                  style:
                                                      GlobalFonts.ts14px500w),
                                            ),
                                          ),
                                          DataCell(
                                            Center(
                                              child: Text(
                                                  data.analogId != null
                                                      ? data.analogId.toString()
                                                      : '-',
                                                  style:
                                                      GlobalFonts.ts14px500w),
                                            ),
                                          ),
                                          DataCell(
                                            Center(
                                              child: Text(
                                                  data.typeId != null
                                                      ? data.typeId.toString()
                                                      : '-',
                                                  style:
                                                      GlobalFonts.ts14px500w),
                                            ),
                                          ),
                                          DataCell(
                                            Center(
                                              child: Text(
                                                  data.locationNo != null
                                                      ? data.analogId.toString()
                                                      : '-',
                                                  style:
                                                      GlobalFonts.ts14px500w),
                                            ),
                                          ),
                                          DataCell(
                                            Center(
                                              child: Text(
                                                  data.year != null
                                                      ? data.year.toString()
                                                      : '-',
                                                  style:
                                                      GlobalFonts.ts14px500w),
                                            ),
                                          ),
                                          DataCell(
                                            Center(
                                              child: Text(
                                                  data.lTime != null
                                                      ? data.lTime.toString()
                                                      : '-',
                                                  style:
                                                      GlobalFonts.ts14px500w),
                                            ),
                                          ),
                                          DataCell(
                                            Center(
                                              child: Text(
                                                  data.voltageStatus != null
                                                      ? data.voltageStatus!
                                                          .toStringAsFixed(2)
                                                      : '-',
                                                  style:
                                                      GlobalFonts.ts14px500w),
                                            ),
                                          ),
                                          DataCell(
                                            Center(
                                              child: Text(
                                                  data.receivedTime != null
                                                      ? DateFormat(
                                                              'dd-MMM-yy HH:mm:ss')
                                                          .format(DateTime.parse(
                                                              data.receivedTime ??
                                                                  ''))
                                                      : '-',
                                                  style:
                                                      GlobalFonts.ts14px500w),
                                            ),
                                          )
                                        ]
                                      : <DataCell>[
                                          DataCell(
                                            Center(
                                              child: Text(
                                                  data.networkNo != null
                                                      ? data.networkNo
                                                          .toString()
                                                      : '-',
                                                  style:
                                                      GlobalFonts.ts14px500w),
                                            ),
                                          ),
                                          DataCell(
                                            Center(
                                              child: Text(
                                                  data.dlNo != null
                                                      ? data.dlNo.toString()
                                                      : "-",
                                                  style:
                                                      GlobalFonts.ts14px500w),
                                            ),
                                          ),
                                          DataCell(
                                            Center(
                                              child: Text(
                                                  data.seqNo != null
                                                      ? data.typeId.toString()
                                                      : '-',
                                                  style:
                                                      GlobalFonts.ts14px500w),
                                            ),
                                          ),
                                          DataCell(
                                            Center(
                                              child: Text(
                                                  data.typeId != null
                                                      ? data.typeId.toString()
                                                      : '-',
                                                  style:
                                                      GlobalFonts.ts14px500w),
                                            ),
                                          ),
                                          DataCell(
                                            Center(
                                              child: Text(
                                                  data.byte1 != null
                                                      ? data.byte1.toString()
                                                      : '-',
                                                  style:
                                                      GlobalFonts.ts14px500w),
                                            ),
                                          ),
                                          DataCell(
                                            Center(
                                              child: Text(
                                                  data.byte2 != null
                                                      ? data.byte2.toString()
                                                      : '-',
                                                  style:
                                                      GlobalFonts.ts14px500w),
                                            ),
                                          ),
                                          DataCell(
                                            Center(
                                              child: Text(
                                                  data.byte3 != null
                                                      ? data.byte3.toString()
                                                      : '-',
                                                  style:
                                                      GlobalFonts.ts14px500w),
                                            ),
                                          ),
                                          DataCell(
                                            Center(
                                              child: Text(
                                                  data.year != null
                                                      ? data.year.toString()
                                                      : '-',
                                                  style:
                                                      GlobalFonts.ts14px500w),
                                            ),
                                          ),
                                          DataCell(
                                            Center(
                                              child: Text(
                                                  data.lTime != null
                                                      ? data.lTime.toString()
                                                      : '-',
                                                  style:
                                                      GlobalFonts.ts14px500w),
                                            ),
                                          ),
                                          DataCell(
                                            Center(
                                              child: Text(
                                                  data.receivedTime != null
                                                      ? DateFormat(
                                                              'dd-MMM-yy HH:mm:ss')
                                                          .format(DateTime.parse(
                                                              data.receivedTime ??
                                                                  ''))
                                                      : '-',
                                                  style:
                                                      GlobalFonts.ts14px500w),
                                            ),
                                          )
                                        ],
                                );
                              },
                            ).toList(),
                          ),
                        ),
                      ),
                    ),
                  );
          }),
        ],
      ),
    );
  }
}
