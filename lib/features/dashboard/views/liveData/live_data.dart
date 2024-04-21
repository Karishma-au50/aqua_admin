import 'package:admin/model/conclusive_Raw_data_model.dart';
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
  String countValue = "10";
  String typeValue = "ConclusiveData";
  RxList<ConclusiveOrRawDataModel> conclusiveOrRawData =
      <ConclusiveOrRawDataModel>[].obs;
  final _formKey = GlobalKey<FormState>();
  @override
  void initState() {
    // controller
    //     .conclusiveOrRawLiveData(typeIdController.text, dlNoController.text,
    //         networkNoController.text, typeValue, countValue)
    //     .then((value) {
    //   if (value != null) {
    //     conclusiveOrRawData.addAll(value);
    //   }
    // });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // hideBack: true,
      body: Form(
        key: _formKey,
        child: Column(
          children: [
            const SizedBox(
              height: 40,
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: MyTextField(
                    controller: typeIdController,
                    hintText: "Type ID",
                    textStyle: GlobalFonts.ts20px500w(),
                    labelText: "TypeID",
                  ),
                ),
                Expanded(
                  child: MyTextField(
                    controller: dlNoController,
                    hintText: "dlno",
                    textStyle: GlobalFonts.ts20px500w(),
                    labelText: "dlno",
                  ),
                ),
                Expanded(
                  child: MyTextField(
                    controller: networkNoController,
                    hintText: "Network No",
                    textStyle: GlobalFonts.ts20px500w(),
                    labelText: "Network Number",
                  ),
                ),
              ],
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
                        setState(() {
                          typeValue = value;
                        });
                      },
                    ),
                  ),
                  const SizedBox(
                    width: 6,
                  ),
                  Expanded(
                    child: DropdownFormField(
                      hintText: "Count",
                      value: countValue,
                      dropDownItems: const [
                        "10",
                        "20",
                        "30",
                        "40",
                        "50",
                      ],
                      onChange: (value) {
                        setState(() {
                          countValue = value;
                        });
                      },
                    ),
                  ),
                  const SizedBox(
                    width: 6,
                  ),
                  Expanded(
                    child: MyButton(
                      text: "Submit",
                      height: 47,
                      onPressed: () async {
                        // final finalCollectionType =
                        //     typeValue == 'ConclusiveData' ? 1 : 2;
                        // await controller
                        //     .conclusiveOrRawLiveData(
                        //         typeIdController.text,
                        //         dlNoController.text,
                        //         networkNoController.text,
                        //         finalCollectionType.toString(),
                        //         countValue)
                        //     .then((value) {
                        //   if (value != null) {
                        //     conclusiveOrRawData(value);

                        //   }
                        // });
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
                              countValue,
                            )
                                .then((value) {
                              if (value != null) {
                                conclusiveOrRawData(value);
                              }
                            });
                          } catch (e) {}
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
              return Expanded(
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
                        columns: [
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
                                  "Device ID",
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
                                  "Sequence No",
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
                          DataColumn(
                            label: SizedBox(
                              width: 100,
                              child: Center(
                                child: Text(
                                  "Location No",
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
                                  "Latitude Time",
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
                              width: 100,
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
                              cells: <DataCell>[
                                DataCell(
                                  Center(
                                    child: Text(
                                        data.networkNo != null
                                            ? data.networkNo.toString()
                                            : '-',
                                        style: GlobalFonts.ts14px500w),
                                  ),
                                ),
                                DataCell(
                                  Center(
                                    child: Text(
                                        data.dlNo != null
                                            ? data.dlNo.toString()
                                            : "-",
                                        style: GlobalFonts.ts14px500w),
                                  ),
                                ),
                                DataCell(
                                  Center(
                                    child: Text(
                                      data.seqNo != null
                                          ? data.seqNo.toString()
                                          : '-',
                                      style: GlobalFonts.ts14px500w,
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                ),
                                DataCell(
                                  Center(
                                    child: Text(
                                        data.analogId != null
                                            ? data.analogId.toString()
                                            : '-',
                                        style: GlobalFonts.ts14px500w),
                                  ),
                                ),
                                DataCell(
                                  Center(
                                    child: Text(
                                        data.typeId != null
                                            ? data.typeId.toString()
                                            : '-',
                                        style: GlobalFonts.ts14px500w),
                                  ),
                                ),
                                DataCell(
                                  Center(
                                    child: Text(
                                        data.byte1 != null
                                            ? data.byte1.toString()
                                            : '-',
                                        style: GlobalFonts.ts14px500w),
                                  ),
                                ),
                                DataCell(
                                  Center(
                                    child: Text(
                                        data.byte2 != null
                                            ? data.byte2.toString()
                                            : '-',
                                        style: GlobalFonts.ts14px500w),
                                  ),
                                ),
                                DataCell(
                                  Center(
                                    child: Text(
                                        data.byte3 != null
                                            ? data.byte3.toString()
                                            : '-',
                                        style: GlobalFonts.ts14px500w),
                                  ),
                                ),
                                DataCell(
                                  Center(
                                    child: Text(
                                        data.locationNo != null
                                            ? data.locationNo.toString()
                                            : '-',
                                        style: GlobalFonts.ts14px500w),
                                  ),
                                ),
                                DataCell(
                                  Center(
                                    child: Text(
                                        data.year != null
                                            ? data.year.toString()
                                            : '-',
                                        style: GlobalFonts.ts14px500w),
                                  ),
                                ),
                                DataCell(
                                  Center(
                                    child: Text(
                                        data.lTime != null
                                            ? data.lTime.toString()
                                            : '-',
                                        style: GlobalFonts.ts14px500w),
                                  ),
                                ),
                                DataCell(
                                  Center(
                                    child: Text(
                                        data.voltageStatus != null
                                            ? data.voltageStatus!
                                                .toStringAsFixed(2)
                                            : '-',
                                        style: GlobalFonts.ts14px500w),
                                  ),
                                ),
                                DataCell(
                                  Center(
                                    child: Text(
                                        data.receivedTime != null
                                            ? DateFormat('dd MMM yy').format(
                                                DateTime.parse(
                                                    data.receivedTime ?? ''))
                                            : '-',
                                        style: GlobalFonts.ts14px500w),
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
      ),
    );
  }
}
