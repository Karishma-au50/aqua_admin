import 'dart:math';

import 'package:admin/model/conclusive_Raw_data_model.dart';
import 'package:admin/shared/utils/extensions.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

class PDFService {
  static Future<pw.Document> generate15DaysDataTablePDF(
      List<ConclusiveOrRawDataModel> data) async {
    final pdf = pw.Document();
    // final PondController controller = Get.put(PondController());
    ByteData img = await rootBundle.load("assets/images/logo.png");
    int start = 0;
    int end = data.length > 180 ? 180 : data.length;
    int listcount = data.length;
    double c = listcount / 20;
    int maxPages = c.toInt() > 0 ? c.toInt() : 1;
    while (start < data.length) {
      pdf.addPage(
        pw.MultiPage(
          maxPages: maxPages,
          pageTheme: pw.PageTheme(
            pageFormat: PdfPageFormat.a4,
            margin: const pw.EdgeInsets.all(20),
            theme: pw.ThemeData.withFont(
              base: await PdfGoogleFonts.openSansRegular(),
              bold: await PdfGoogleFonts.openSansBold(),
              icons: await PdfGoogleFonts.materialIcons(),
            ),
          ),
          header: (context) {
            return pw.Column(
              children: [
                pw.Align(
                  alignment: pw.Alignment.centerRight,
                  child: pw.Text(context.pageNumber.toString()),
                ),
                pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceAround,
                  children: [
                    pw.Image(
                      pw.MemoryImage(img.buffer.asUint8List()),
                      height: 25,
                    ),
                    pw.SizedBox(width: 20),
                    pw.Text(
                      "Pond Report",
                      style: pw.TextStyle(
                        fontSize: 12,
                        fontWeight: pw.FontWeight.bold,
                      ),
                    ),
                    pw.Text(
                      "Reported on: ${DateFormat('dd.MM.yyyy HH:mm').format(DateTime.now())}",
                      style: const pw.TextStyle(
                        fontSize: 11,
                      ),
                    ),
                  ],
                ),
                pw.SizedBox(height: 5),
                pw.Table(
                  border: pw.TableBorder.all(width: 1),
                  columnWidths: {
                    0: const pw.FlexColumnWidth(1),
                    1: const pw.FlexColumnWidth(1),
                    2: const pw.FlexColumnWidth(1),
                    3: const pw.FlexColumnWidth(1),
                    4: const pw.FlexColumnWidth(1),
                    5: const pw.FlexColumnWidth(1),
                    6: const pw.FlexColumnWidth(1),
                    7: const pw.FlexColumnWidth(1),
                    8: const pw.FlexColumnWidth(1),
                    9: const pw.FlexColumnWidth(1),
                  },
                  // defaultColumnWidth: const pw.FlexColumnWidth(3),
                  children: [
                    pw.TableRow(
                      children: [
                        pw.Container(
                          height: 35, // Set a fixed height for each row
                          decoration: pw.BoxDecoration(
                            color: PdfColor.fromHex("#edf4d6"),
                          ),
                          child: pw.Center(
                            child: pw.Padding(
                              padding:
                                  const pw.EdgeInsets.symmetric(vertical: 2),
                              child: pw.Text(
                                "Network No",
                                style: pw.TextStyle(
                                  fontSize: 10,
                                  fontWeight: pw.FontWeight.bold,
                                ),
                                textAlign: pw.TextAlign.center,
                              ),
                            ),
                          ),
                        ),
                        pw.Container(
                          height: 35, // Set a fixed height for each row
                          decoration: pw.BoxDecoration(
                            color: PdfColor.fromHex("#edf4d6"),
                          ),
                          child: pw.Center(
                            child: pw.Padding(
                              padding:
                                  const pw.EdgeInsets.symmetric(vertical: 2),
                              child: pw.Text(
                                "Dl No",
                                style: pw.TextStyle(
                                  fontSize: 10,
                                  fontWeight: pw.FontWeight.bold,
                                ),
                                textAlign: pw.TextAlign.center,
                              ),
                            ),
                          ),
                        ),
                        pw.Container(
                          height: 35, // Set a fixed height for each row
                          decoration: pw.BoxDecoration(
                            color: PdfColor.fromHex("#edf4d6"),
                          ),
                          child: pw.Center(
                            child: pw.Padding(
                              padding:
                                  const pw.EdgeInsets.symmetric(vertical: 2),
                              child: pw.Text(
                                "Analog Id",
                                style: pw.TextStyle(
                                  fontSize: 10,
                                  fontWeight: pw.FontWeight.bold,
                                ),
                                textAlign: pw.TextAlign.center,
                              ),
                            ),
                          ),
                        ),
                        pw.Container(
                          height: 35, // Set a fixed height for each row
                          decoration: pw.BoxDecoration(
                            color: PdfColor.fromHex("#edf4d6"),
                          ),
                          child: pw.Center(
                            child: pw.Padding(
                              padding:
                                  const pw.EdgeInsets.symmetric(vertical: 2),
                              child: pw.Text(
                                "Type Id",
                                style: pw.TextStyle(
                                  fontSize: 10,
                                  fontWeight: pw.FontWeight.bold,
                                ),
                                textAlign: pw.TextAlign.center,
                              ),
                            ),
                          ),
                        ),
                        pw.Container(
                          height: 35, // Set a fixed height for each row
                          decoration: pw.BoxDecoration(
                            color: PdfColor.fromHex("#edf4d6"),
                          ),
                          child: pw.Center(
                            child: pw.Padding(
                              padding:
                                  const pw.EdgeInsets.symmetric(vertical: 2),
                              child: pw.Text(
                                "Byte 1",
                                style: pw.TextStyle(
                                  fontSize: 10,
                                  fontWeight: pw.FontWeight.bold,
                                ),
                                textAlign: pw.TextAlign.center,
                              ),
                            ),
                          ),
                        ),
                        pw.Container(
                          height: 35, // Set a fixed height for each row
                          decoration: pw.BoxDecoration(
                            color: PdfColor.fromHex("#edf4d6"),
                          ),
                          child: pw.Center(
                            child: pw.Padding(
                              padding:
                                  const pw.EdgeInsets.symmetric(vertical: 2),
                              child: pw.Text(
                                "Byte 2",
                                style: pw.TextStyle(
                                  fontSize: 10,
                                  fontWeight: pw.FontWeight.bold,
                                ),
                                textAlign: pw.TextAlign.center,
                              ),
                            ),
                          ),
                        ),
                        pw.Container(
                          height: 35, // Set a fixed height for each row
                          decoration: pw.BoxDecoration(
                            color: PdfColor.fromHex("#edf4d6"),
                          ),
                          child: pw.Center(
                            child: pw.Padding(
                              padding:
                                  const pw.EdgeInsets.symmetric(vertical: 2),
                              child: pw.Text(
                                "Byte 3",
                                style: pw.TextStyle(
                                  fontSize: 10,
                                  fontWeight: pw.FontWeight.bold,
                                ),
                                textAlign: pw.TextAlign.center,
                              ),
                            ),
                          ),
                        ),
                        pw.Container(
                          height: 35, // Set a fixed height for each row
                          decoration: pw.BoxDecoration(
                            color: PdfColor.fromHex("#edf4d6"),
                          ),
                          child: pw.Center(
                            child: pw.Padding(
                              padding:
                                  const pw.EdgeInsets.symmetric(vertical: 2),
                              child: pw.Text(
                                "Latitude",
                                style: pw.TextStyle(
                                  fontSize: 10,
                                  fontWeight: pw.FontWeight.bold,
                                ),
                                textAlign: pw.TextAlign.center,
                              ),
                            ),
                          ),
                        ),
                        pw.Container(
                          height: 35, // Set a fixed height for each row
                          decoration: pw.BoxDecoration(
                            color: PdfColor.fromHex("#edf4d6"),
                          ),
                          child: pw.Center(
                            child: pw.Padding(
                              padding:
                                  const pw.EdgeInsets.symmetric(vertical: 2),
                              child: pw.Text(
                                "Voltage Status",
                                style: pw.TextStyle(
                                  fontSize: 10,
                                  fontWeight: pw.FontWeight.bold,
                                ),
                                textAlign: pw.TextAlign.center,
                              ),
                            ),
                          ),
                        ),
                        pw.Container(
                          height: 35, // Set a fixed height for each row
                          decoration: pw.BoxDecoration(
                            color: PdfColor.fromHex("#edf4d6"),
                          ),
                          child: pw.Center(
                            child: pw.Padding(
                              padding:
                                  const pw.EdgeInsets.symmetric(vertical: 2),
                              child: pw.Text(
                                "Received Time",
                                style: pw.TextStyle(
                                  fontSize: 10,
                                  fontWeight: pw.FontWeight.bold,
                                ),
                                textAlign: pw.TextAlign.center,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),

                    // pw.TableRow(
                    //   children: [
                    //     pw.Container(
                    //       // width: 60,
                    //       color: PdfColor.fromHex("#edf4d6"),
                    //       child: pw.Center(
                    //           child: pw.Padding(
                    //         padding: const pw.EdgeInsets.symmetric(vertical: 2),
                    //         child: pw.Text(
                    //           "Network No",
                    //           style: pw.TextStyle(
                    //             fontSize: 10,
                    //             fontWeight: pw.FontWeight.bold,
                    //           ),
                    //           textAlign: pw.TextAlign.center,
                    //         ),
                    //       )),
                    //     ),
                    //     pw.Container(
                    //       // width: 60,
                    //       color: PdfColor.fromHex("#edf4d6"),
                    //       child: pw.Center(
                    //         child: pw.Padding(
                    //           padding:
                    //               const pw.EdgeInsets.symmetric(vertical: 2),
                    //           child: pw.Text(
                    //             "Analog Id",
                    //             style: pw.TextStyle(
                    //               fontSize: 10,
                    //               fontWeight: pw.FontWeight.bold,
                    //             ),
                    //             textAlign: pw.TextAlign.center,
                    //           ),
                    //         ),
                    //       ),
                    //     ),
                    //     pw.Container(
                    //       // width: 60,
                    //       color: PdfColor.fromHex("#edf4d6"),
                    //       child: pw.Center(
                    //         child: pw.Padding(
                    //           padding:
                    //               const pw.EdgeInsets.symmetric(vertical: 2),
                    //           child: pw.Text(
                    //             "Type Id",
                    //             style: pw.TextStyle(
                    //               fontSize: 10,
                    //               fontWeight: pw.FontWeight.bold,
                    //             ),
                    //             textAlign: pw.TextAlign.center,
                    //           ),
                    //         ),
                    //       ),
                    //     ),
                    //     pw.Container(
                    //       // width: 60,
                    //       color: PdfColor.fromHex("#edf4d6"),
                    //       child: pw.Center(
                    //         child: pw.Padding(
                    //           padding:
                    //               const pw.EdgeInsets.symmetric(vertical: 2),
                    //           child: pw.Text(
                    //             "Byte 1",
                    //             style: pw.TextStyle(
                    //               fontSize: 10,
                    //               fontWeight: pw.FontWeight.bold,
                    //             ),
                    //             textAlign: pw.TextAlign.center,
                    //           ),
                    //         ),
                    //       ),
                    //     ),
                    //     pw.Container(
                    //       // width: 60,
                    //       color: PdfColor.fromHex("#edf4d6"),
                    //       child: pw.Center(
                    //         child: pw.Padding(
                    //           padding:
                    //               const pw.EdgeInsets.symmetric(vertical: 2),
                    //           child: pw.Text(
                    //             "Byte 2",
                    //             style: pw.TextStyle(
                    //               fontSize: 10,
                    //               fontWeight: pw.FontWeight.bold,
                    //             ),
                    //             textAlign: pw.TextAlign.center,
                    //           ),
                    //         ),
                    //       ),
                    //     ),
                    //     pw.Container(
                    //       color: PdfColor.fromHex("#edf4d6"),
                    //       child: pw.Center(
                    //         child: pw.Padding(
                    //           padding:
                    //               const pw.EdgeInsets.symmetric(vertical: 2),
                    //           child: pw.Text(
                    //             "Byte 3",
                    //             style: pw.TextStyle(
                    //               fontSize: 10,
                    //               fontWeight: pw.FontWeight.bold,
                    //             ),
                    //             textAlign: pw.TextAlign.center,
                    //           ),
                    //         ),
                    //       ),
                    //     ),
                    //     pw.Container(
                    //       color: PdfColor.fromHex("#edf4d6"),
                    //       child: pw.Center(
                    //         child: pw.Padding(
                    //           padding:
                    //               const pw.EdgeInsets.symmetric(vertical: 2),
                    //           child: pw.Text(
                    //             "Latitude",
                    //             style: pw.TextStyle(
                    //               fontSize: 10,
                    //               fontWeight: pw.FontWeight.bold,
                    //             ),
                    //             textAlign: pw.TextAlign.center,
                    //           ),
                    //         ),
                    //       ),
                    //     ),
                    //     pw.Container(
                    //       color: PdfColor.fromHex("#edf4d6"),
                    //       child: pw.Center(
                    //         child: pw.Padding(
                    //           padding:
                    //               const pw.EdgeInsets.symmetric(vertical: 2),
                    //           child: pw.Text(
                    //             "Voltage Status",
                    //             style: pw.TextStyle(
                    //               fontSize: 10,
                    //               fontWeight: pw.FontWeight.bold,
                    //             ),
                    //             textAlign: pw.TextAlign.center,
                    //           ),
                    //         ),
                    //       ),
                    //     ),
                    //     pw.Container(
                    //       color: PdfColor.fromHex("#edf4d6"),
                    //       child: pw.Center(
                    //         child: pw.Padding(
                    //           padding:
                    //               const pw.EdgeInsets.symmetric(vertical: 2),
                    //           child: pw.Text(
                    //             "Recieved Time",
                    //             style: pw.TextStyle(
                    //               fontSize: 10,
                    //               fontWeight: pw.FontWeight.bold,
                    //             ),
                    //             textAlign: pw.TextAlign.center,
                    //           ),
                    //         ),
                    //       ),
                    //     ),
                    //   ],
                    // ),
                  ],
                )
              ],
            );
          },
          build: (context) {
            return [
              pw.Table(
                border: pw.TableBorder.all(width: 1),
                defaultColumnWidth: const pw.FlexColumnWidth(1),
                children: [
                  ...data.getRange(start, end).map((e) {
                    return pw.TableRow(
                      children: [
                        pw.Container(
                          width: 0,
                          padding: const pw.EdgeInsets.all(5),
                          child: pw.Text(
                            e.networkNo?.toString() ?? "-",
                            // DateFormat("dd.MM.yy ").format(e.derivedDateTime),
                            style: const pw.TextStyle(
                              fontSize: 10,
                              // fontWeight: pw.FontWeight.bold,
                            ),
                            textAlign: pw.TextAlign.center,
                          ),
                        ),
                        pw.Container(
                          width: 0,
                          padding: const pw.EdgeInsets.all(5),
                          child: pw.Text(
                            e.dlNo?.toString() ?? "-",
                            // DateFormat("HH:mm").format(e.derivedDateTime),
                            style: const pw.TextStyle(
                              fontSize: 10,
                              // fontWeight: pw.FontWeight.bold,
                            ),
                            textAlign: pw.TextAlign.center,
                          ),
                        ),
                        pw.Container(
                          // height: 50,
                          width: 0,
                          padding: const pw.EdgeInsets.all(5),
                          child: pw.Text(
                            e.analogId?.toString() ?? "-",
                            // DateFormat("HH:mm").format(e.derivedDateTime),
                            style: const pw.TextStyle(
                              fontSize: 10,
                              // fontWeight: pw.FontWeight.bold,
                            ),
                            textAlign: pw.TextAlign.center,
                          ),
                        ),
                        pw.Container(
                          // height: 50,
                          width: 0,
                          padding: const pw.EdgeInsets.all(5),
                          child: pw.Text(
                            e.typeId?.toString() ?? "-",
                            // DateFormat("HH:mm").format(e.derivedDateTime),
                            style: const pw.TextStyle(
                              fontSize: 10,
                              // fontWeight: pw.FontWeight.bold,
                            ),
                            textAlign: pw.TextAlign.center,
                          ),
                        ),
                        pw.Container(
                          // height: 50,
                          width: 0,
                          padding: const pw.EdgeInsets.all(5),
                          child: pw.Text(
                            e.byte1?.toString() ?? "-",
                            // DateFormat("HH:mm").format(e.derivedDateTime),
                            style: const pw.TextStyle(
                              fontSize: 10,
                              // fontWeight: pw.FontWeight.bold,
                            ),
                            textAlign: pw.TextAlign.center,
                          ),
                        ),
                        pw.Container(
                          // height: 50,
                          width: 40,
                          padding: const pw.EdgeInsets.all(5),
                          child: pw.Text(
                            e.byte2?.toString() ?? "-",
                            // DateFormat("HH:mm").format(e.derivedDateTime),
                            style: const pw.TextStyle(
                              fontSize: 10,
                              // fontWeight: pw.FontWeight.bold,
                            ),
                            textAlign: pw.TextAlign.center,
                          ),
                        ),
                        pw.Container(
                          // height: 50,
                          width: 0,
                          padding: const pw.EdgeInsets.all(5),
                          child: pw.Text(
                            e.byte3?.toString() ?? "-",
                            // DateFormat("HH:mm").format(e.derivedDateTime),
                            style: const pw.TextStyle(
                              fontSize: 10,
                              // fontWeight: pw.FontWeight.bold,
                            ),
                            textAlign: pw.TextAlign.center,
                          ),
                        ),
                        pw.Container(
                          // height: 50,
                          width: 0,
                          padding: const pw.EdgeInsets.all(5),
                          child: pw.Text(
                            e.lTime?.toString() ?? "-",
                            // DateFormat("HH:mm").format(e.derivedDateTime),
                            style: const pw.TextStyle(
                              fontSize: 10,
                              // fontWeight: pw.FontWeight.bold,
                            ),
                            textAlign: pw.TextAlign.center,
                          ),
                        ),
                        pw.Container(
                          // height: 50,
                          width: 0,
                          padding: const pw.EdgeInsets.all(5),
                          child: pw.Text(
                            e.voltageStatus?.toString() ?? "-",
                            // DateFormat("HH:mm").format(e.derivedDateTime),
                            style: const pw.TextStyle(
                              fontSize: 10,
                              // fontWeight: pw.FontWeight.bold,
                            ),
                            textAlign: pw.TextAlign.center,
                          ),
                        ),
                        pw.Container(
                          // height: 50,
                          width: 0,
                          padding: const pw.EdgeInsets.all(5),
                          child: pw.Text(
                            e.receivedTime != null
                                ? DateFormat('dd MMM yy\nHH:mm:ss').format(
                                    DateTime.parse(e.receivedTime ?? ''))
                                : '-',
                            style: const pw.TextStyle(
                              fontSize: 10,
                              // fontWeight: pw.FontWeight.bold,
                            ),
                            textAlign: pw.TextAlign.center,
                          ),
                        ),
                      ],
                    );
                  }),
                ],
              ),
            ];
          },
        ),
      );
      start = min(start + 180, data.length);
      end = min(end + 180, data.length);
    }

    return pdf;
  }

  static pw.Widget _buildText(
    double? value,
  ) {
    return pw.Center(
      child: pw.Text(
        value?.toStringWithMaxPrecision(maxDigits: 3) ?? "-",
        style: pw.TextStyle(
          fontSize: 10,
          color: PdfColors.black,
        ),
        textAlign: pw.TextAlign.center,
      ),
    );
  }
}
