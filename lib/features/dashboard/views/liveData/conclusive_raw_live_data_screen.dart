import 'dart:convert';
import 'dart:html';
import 'package:flutter/cupertino.dart';
import 'package:flutter/widgets.dart';
import 'package:pdf/widgets.dart' as pw;
// import 'dart:io';

import 'package:admin/model/conclusive_Raw_data_model.dart';
import 'package:admin/shared/widgets/toast/my_toast.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../../shared/constant/font_helper.dart';
import '../../../../shared/widgets/buttons/my_button.dart';
import '../../../../shared/widgets/inputs/my_text_field.dart';
import '../../../../shared/widgets/pdf_service.dart';
import '../../controller/sensor_controller.dart';

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

  TextEditingController countValueController = TextEditingController();

  String countValue = "10";
  String typeValue = "ConclusiveData";
  RxList<ConclusiveOrRawDataModel> conclusiveOrRawData =
      <ConclusiveOrRawDataModel>[].obs;
  final _formKey = GlobalKey<FormState>();
  // create a method to create a file and return a file
  static Future<void> createFileOfPdfUrl(
      pw.Document document, String name) async {
    // final Directory dir = await getTemporaryDirectory();
    try {
      final List<int> bytesList = await document.save();

      AnchorElement(
        href:
            "data:application/octet-stream;charset=utf-16le;base64,${base64.encode(bytesList)}",
      )
        ..setAttribute("download", "output.pdf")
        ..click();
    } catch (ex) {
      print(ex);
    }
  }

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
              ],
            ),
          ),

          // dropdowns and submit button
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            child: Row(
              // crossAxisAlignment: CrossAxisAlignment.start,
              // mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                  width: 22,
                ),
                Expanded(
                  child: MyTextField(
                    controller: countValueController,
                    hintText: "Count",
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
                            countValueController.text,
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
            height: 10,
          ),

          Obx(() {
            return !conclusiveOrRawData.isNotEmpty
                ? SizedBox()
                : Align(
                    alignment: Alignment.centerRight,
                    child: Padding(
                      padding: const EdgeInsets.only(right: 10.0),
                      child: MyButton(
                          width: 180,
                          text: "Export PDF",
                          color: Color(0xFFFFFFF),
                          textColor: Color(0xFF000000),
                          onPressed: () =>
                              PDFService.generate15DaysDataTablePDF(
                                      conclusiveOrRawData)
                                  .then((value) async {
                                String fileName = "testing";
                                return await createFileOfPdfUrl(
                                    value, fileName);
                              }).catchError((e) {
                                print(e);
                              })),
                    ),
                  );
          }),
          const SizedBox(
            height: 10,
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
                        // DataColumn(
                        //   label: SizedBox(
                        //     width: 100,
                        //     child: Center(
                        //       child: Text(
                        //         "Sequence No",
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
                              // DataCell(
                              //   Center(
                              //     child: Text(
                              //       data.seqNo != null
                              //           ? data.seqNo.toString()
                              //           : '-',
                              //       style: GlobalFonts.ts14px500w,
                              //       textAlign: TextAlign.center,
                              //     ),
                              //   ),
                              // ),
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
                              // DataCell(
                              //   Center(
                              //     child: Text(
                              //         data.locationNo != null
                              //             ? data.locationNo.toString()
                              //             : '-',
                              //         style: GlobalFonts.ts14px500w),
                              //   ),
                              // ),
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
                                          ? DateFormat('dd MMM yy\nHH:mm:ss')
                                              .format(DateTime.parse(
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
    );
  }
}

// edrftghjkll;
// Future<void> generatePDF(BuildContext context,
//     List<ConclusiveOrRawDataModel> conclusiveOrRawData) async {
//   try {
//     // Create PDF document
//     final PdfDocument document = PdfDocument();

//     // Draw top-center text
//     final PdfPage page = document.pages.add();
//     final Size pageSize = page.getClientSize();

//     // Assuming we show the details of the first item in the list
//     final ConclusiveOrRawDataModel firstData = conclusiveOrRawData.isNotEmpty
//         ? conclusiveOrRawData[0]
//         : ConclusiveOrRawDataModel();

//     String topCenterText = "Network No: ${firstData.networkNo ?? '-'}, "
//         "Device ID: ${firstData.dlNo ?? '-'}, "
//         "Type ID: ${firstData.typeId ?? '-'}";
//     // 'nmdl live data'

//     page.graphics.drawString(
//       topCenterText,
//       PdfStandardFont(PdfFontFamily.helvetica, 12),
//       bounds: Rect.fromLTWH(0, 20, pageSize.width, 20),
//       format: PdfStringFormat(
//         alignment: PdfTextAlignment.center,
//         lineAlignment: PdfVerticalAlignment.middle,
//       ),
//     );

//     // Draw table with actual data
//     final PdfGrid grid = PdfGrid();
//     grid.columns.add(count: 8); // Only 7 columns now
//     grid.headers.add(1);

//     // Add header row
//     final PdfGridRow headerRow = grid.headers[0];
//     headerRow.cells[0].value = 'Analog ID';
//     headerRow.cells[1].value = 'Byte 1';
//     headerRow.cells[2].value = 'Byte 2';
//     headerRow.cells[3].value = 'Byte 3';
//     headerRow.cells[4].value = 'Year';
//     headerRow.cells[5].value = 'Latitude Time';
//     headerRow.cells[6].value = 'Voltage Status';
//     headerRow.cells[7].value = 'Received Time';

//     // Define header style
//     final PdfGridCellStyle headerStyle = PdfGridCellStyle(
//       backgroundBrush: PdfBrushes.chocolate, // Color #edf4d6
//       textBrush: PdfBrushes.black,
//       font: PdfStandardFont(PdfFontFamily.helvetica, 12,
//           style: PdfFontStyle.regular),
//       cellPadding: PdfPaddings(left: 5, top: 5, right: 5, bottom: 5),
//       borders: PdfBorders(
//         left: PdfPens.black,
//         top: PdfPens.black,
//         right: PdfPens.black,
//         bottom: PdfPens.black,
//       ),
//     );

//     // Apply header style
//     for (int i = 0; i < headerRow.cells.count; i++) {
//       headerRow.cells[i].style = headerStyle;
//     }

//     // Define row style
//     final PdfGridCellStyle rowStyle = PdfGridCellStyle(
//       textBrush: PdfBrushes.black,
//       font: PdfStandardFont(PdfFontFamily.helvetica, 10),
//       cellPadding: PdfPaddings(left: 5, top: 5, right: 5, bottom: 5),
//       borders: PdfBorders(
//         left: PdfPens.black,
//         top: PdfPens.black,
//         right: PdfPens.black,
//         bottom: PdfPens.black,
//       ),
//     );

//     // Add rows with actual data
//     for (var data in conclusiveOrRawData) {
//       final PdfGridRow row = grid.rows.add();
//       row.cells[0].value = data.analogId ?? '-';
//       row.cells[1].value = data.byte1 ?? '-';
//       row.cells[2].value = data.byte2 ?? '-';
//       row.cells[3].value = data.byte3 ?? '-';
//       row.cells[4].value = data.year ?? '-';
//       row.cells[5].value = data.lTime ?? '-';
//       row.cells[6].value = data.voltageStatus?.toStringAsFixed(2) ?? '-';
//       row.cells[7].value = data.receivedTime != null
//           ? DateFormat('dd MMM yy\nHH:mm:ss')
//               .format(DateTime.parse(data.receivedTime ?? ''))
//           : '-';

//       // Apply row style
//       for (int j = 0; j < row.cells.count; j++) {
//         row.cells[j].style = rowStyle;
//       }
//     }

//     // Draw the grid and let it handle pagination
//     grid.draw(page: page, bounds: const Rect.fromLTWH(0, 50, 0, 0));

//     // Save PDF and initiate download
//     final List<int> bytesList = await document.save();
//     document.dispose();

//     AnchorElement(
//       href:
//           "data:application/octet-stream;charset=utf-16le;base64,${base64.encode(bytesList)}",
//     )
//       ..setAttribute("download", "output.pdf")
//       ..click();

//     MyToasts.toastSuccess("Chart has been exported as PDF document.");
//   } catch (e) {
//     MyToasts.toastError("Error exporting chart as PDF document.");
//   }
// }
