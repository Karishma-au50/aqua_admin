import 'dart:convert';
import 'dart:html';
import 'dart:ui' as ui;

import 'package:admin/model/waterquality/water_qualiity_chart_model.dart';
import 'package:admin/shared/widgets/buttons/my_button.dart';
import 'package:admin/shared/widgets/toast/my_toast.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';

import '../../../../shared/constant/font_helper.dart';
import '../../controller/water_quality_controller.dart';

class LineChart extends StatefulWidget {
  const LineChart({super.key});

  @override
  State<LineChart> createState() => _LineChartState();
}

class _LineChartState extends State<LineChart> {
  final WaterQualityController controller = Get.find();
  final GlobalKey<SfCartesianChartState> _chartKey = GlobalKey();
  String selectedFrequency = '5 mins';

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20),
          child: SizedBox(
            height: 300,
            child: Obx(() {
              if (controller.waterQualityChartModel.isEmpty) {
                return const Center(
                  child: Text("No Data Found"),
                );
              }
              return SfCartesianChart(
                key: _chartKey,
                primaryXAxis: DateTimeAxis(
                  majorGridLines: const MajorGridLines(width: 0),
                  edgeLabelPlacement: EdgeLabelPlacement.shift,
                  intervalType: DateTimeIntervalType.auto,
                  dateFormat: DateFormat("dd MMM yy\nHH:mm:ss"),
                ),
                tooltipBehavior: TooltipBehavior(enable: true),
                series: _buildLineSeries(),
                trackballBehavior: TrackballBehavior(
                  enable: true,
                  activationMode: ActivationMode.none,
                  tooltipSettings: const InteractiveTooltip(
                    enable: true,
                    color: Colors.black,
                    textStyle: TextStyle(color: Colors.white),
                  ),
                ),
              );
            }),
          ),
        ),
        Container(
            padding: const EdgeInsets.fromLTRB(5, 3, 5, 3),
            decoration: BoxDecoration(
              color: const Color(0xFFF3F5F7),
              borderRadius: BorderRadius.circular(10.0),
            ),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  '5 mins',
                  '10 mins',
                  '15 mins',
                  '30 mins',
                  '45 mins',
                  '60 mins'
                ].map((item) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4.0),
                    child: TextButton(
                      style: TextButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        padding: const EdgeInsets.fromLTRB(2, 2, 2, 2),
                        backgroundColor: Colors.white,
                      ),
                      onPressed: () {
                        setState(() {
                          selectedFrequency = item;
                        });
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: Text(
                          item,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Color(0xff767B84),
                            shadows: [
                              Shadow(
                                color: Color(0xFFD6D6D6),
                                offset: Offset(0, 3),
                                blurRadius: 4,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            )),
        Align(
          alignment: Alignment.topRight,
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: MyButton(
              width: 100,
              textStyle: GlobalFonts.ts14px600w,
              text: "EXPORT PDF",
              onPressed: _renderPdf,
            ),
          ),
        ),
      ],
    );
  }

  List<LineSeries<SensorChartModel, DateTime>> _buildLineSeries() {
    List<Color> colors = [
      Colors.orange,
      Colors.green,
      Colors.blue,
      Colors.red,
      Colors.purple,
      Colors.cyan
    ];

    // Filter data based on selected frequency
    // List<SensorChartModel> filteredData = ;

    return controller.waterQualityChartModel
        .map(
          (element) => LineSeries<SensorChartModel, DateTime>(
            dataSource: _filterDataByFrequency(element.data),
//             .where(
//                      (element) => element.value != 0 && element.derivedTime != 0),
// //
            //     (data) => data.sensor == element.sensor && data.pondId == element.pondId)
            // .toList(),
            xValueMapper: (data, _) => data.dateTime,
            yValueMapper: (data, _) => data.value,
            markerSettings: const MarkerSettings(isVisible: false),
            color: colors[controller.waterQualityChartModel.indexOf(element) %
                colors.length],
            name: "${element.sensor} (${element.pondId})",
            emptyPointSettings: const EmptyPointSettings(
              mode: EmptyPointMode.gap,
              color: Colors.transparent,
              borderColor: Colors.transparent,
            ),
          ),
        )
        .toList();
  }

  List<SensorChartModel> _filterDataByFrequency(List<SensorChartModel> data) {
    int intervalMinutes;
    switch (selectedFrequency) {
      case '5 mins':
        intervalMinutes = 5;
        break;
      case '10 mins':
        intervalMinutes = 10;
        break;
      case '15 mins':
        intervalMinutes = 15;
        break;
      case '30 mins':
        intervalMinutes = 30;
        break;
      case '45 mins':
        intervalMinutes = 45;
        break;
      case '60 mins':
        intervalMinutes = 60;
        break;
      default:
        intervalMinutes = 5;
    }

    DateTime startTime = data.first.dateTime;
    var d = data
        .where((data) =>
            data.dateTime.difference(startTime).inMinutes % intervalMinutes ==
            0)
        .toList();
    return d;
  }
// }

// class _LineChartState extends State<LineChart> {
//   final WaterQualityController controller = Get.find();
//   final GlobalKey<SfCartesianChartState> _chartKey = GlobalKey();
//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       children: [
//         Padding(
//           padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20),
//           child: SizedBox(
//             height: 300,
//             child: Obx(() {
//               if (controller.waterQualityChartModel.isEmpty) {
//                 return const Center(
//                   child: Text("No Data Found"),
//                   // child: CircularProgressIndicator(),
//                 );
//               }
//               return SfCartesianChart(
//                 key: _chartKey,
//                 primaryXAxis: DateTimeAxis(
//                   majorGridLines: const MajorGridLines(width: 0),
//                   edgeLabelPlacement: EdgeLabelPlacement.shift,
//                   intervalType: DateTimeIntervalType.auto,
//                   dateFormat: DateFormat.yMd(),
//                   // labelIntersectAction: AxisLabelIntersectAction.rotate45,
//                 ),
//                 tooltipBehavior: TooltipBehavior(enable: true),
//                 series: _buildLineSeries(),
//                 trackballBehavior: TrackballBehavior(
//                   enable: true,
//                   activationMode: ActivationMode.none,
//                   tooltipSettings: const InteractiveTooltip(
//                     enable: true,
//                     color: Colors.black,
//                     textStyle: TextStyle(color: Colors.white),
//                   ),
//                 ),
//               );
//             }),
//           ),
//         ),
//         Container(
//             padding: const EdgeInsets.fromLTRB(5, 3, 5, 3),
//             decoration: BoxDecoration(
//               color: const Color(0xFFF3F5F7),
//               borderRadius: BorderRadius.circular(10.0),
//             ),
//             child: SingleChildScrollView(
//               scrollDirection: Axis.horizontal,
//               child: Row(
//                 children: [
//                   '5 mins',
//                   '10 mins',
//                   '15 mins',
//                   '30 mins',
//                   '45 mins',
//                   '60 mins'
//                 ].map((item) {
//                   return Padding(
//                     padding: const EdgeInsets.symmetric(horizontal: 4.0),
//                     child: TextButton(
//                       style: TextButton.styleFrom(
//                         shape: RoundedRectangleBorder(
//                           borderRadius: BorderRadius.circular(10.0),
//                         ),
//                         padding: const EdgeInsets.fromLTRB(2, 2, 2, 2),
//                         backgroundColor: Colors.white,
//                       ),
//                       onPressed: () {},
//                       child: Padding(
//                         padding: const EdgeInsets.symmetric(horizontal: 8.0),
//                         child: Text(
//                           item,
//                           style: const TextStyle(
//                             fontWeight: FontWeight.bold,
//                             color: Color(0xff767B84),
//                             shadows: [
//                               Shadow(
//                                 color: Color(0xFFD6D6D6),
//                                 offset: Offset(0, 3),
//                                 blurRadius: 4,
//                               ),
//                             ],
//                           ),
//                         ),
//                       ),
//                     ),
//                   );
//                 }).toList(),
//               ),
//             )),
//         Align(
//           alignment: Alignment.topRight,
//           child: Padding(
//             padding: const EdgeInsets.all(12.0),
//             child: MyButton(
//               width: 100,
//               textStyle: GlobalFonts.ts14px600w,
//               text: "EXPORT PDF",
//               onPressed: _renderPdf,
//             ),
//           ),
//         ),
//       ],
//     );
//   }

//   List<LineSeries<SensorChartModel, DateTime>> _buildLineSeries() {
//     List<Color> colors = [
//       Colors.orange,
//       Colors.green,
//       Colors.blue,
//       Colors.red,
//       Colors.purple,
//       Colors.cyan
//     ];

//     return controller.waterQualityChartModel
//         .map(
//           (element) => LineSeries<SensorChartModel, DateTime>(
//             dataSource: element.data
//                 .where(
//                     (element) => element.value != 0 && element.derivedTime != 0)
//                 .toList(),
//             xValueMapper: (data, _) => data.dateTime,
//             yValueMapper: (data, _) => data.value,
//             markerSettings: const MarkerSettings(isVisible: false),
//             color: colors[controller.waterQualityChartModel.indexOf(element) %
//                 colors.length],
//             name: "${element.sensor} (${element.pondId})",
//             emptyPointSettings: const EmptyPointSettings(
//               mode: EmptyPointMode.gap,
//               color: Colors.transparent,
//               borderColor: Colors.transparent,
//             ),
//           ),
//         )
//         .toList();
//   }

  Future<void> _renderPdf() async {
    try {
      // Capture chart image
      final ui.Image? chartImage =
          await _chartKey.currentState!.toImage(pixelRatio: 3.0);
      final ByteData? chartBytes =
          await chartImage?.toByteData(format: ui.ImageByteFormat.png);
      final Uint8List chartImageBytes = chartBytes!.buffer
          .asUint8List(chartBytes.offsetInBytes, chartBytes.lengthInBytes);
      final PdfBitmap chartBitmap = PdfBitmap(chartImageBytes);

      // Load company logo image
      final ByteData logoBytes =
          await rootBundle.load('assets/images/logo.png');
      final Uint8List logoImageBytes = logoBytes.buffer.asUint8List();
      final PdfBitmap logoBitmap = PdfBitmap(logoImageBytes);

      // Create PDF document
      final PdfDocument document = PdfDocument();
      final PdfPage page = document.pages.add();
      final Size pageSize = page.getClientSize();

      // Set the size of the page to fit the content
      document.pageSettings.size = Size(pageSize.width, pageSize.height + 400);

      // Draw chart heading at the top-center
      const String chartHeading = 'Water Quality Parameters Report';
      page.graphics.drawString(
          chartHeading, PdfStandardFont(PdfFontFamily.helvetica, 20),
          bounds: Rect.fromLTWH(0, 10, pageSize.width, 30),
          format: PdfStringFormat(
              alignment: PdfTextAlignment.center,
              lineAlignment: PdfVerticalAlignment.middle));

      // Draw table with dummy data
      final PdfGrid grid = PdfGrid();
      grid.columns.add(count: 5);
      grid.headers.add(1);

      // Add header row
      final PdfGridRow headerRow = grid.headers[0];
      headerRow.cells[0].value = 'Pond ID';
      headerRow.cells[1].value = 'Farm ID';
      headerRow.cells[2].value = 'Pond Name';
      headerRow.cells[3].value = 'Farm Name';
      headerRow.cells[4].value = 'Owner Name';

      // Define header style with blue background and borders
      final PdfGridCellStyle headerStyle = PdfGridCellStyle(
        backgroundBrush: PdfBrushes.gray,
        textBrush: PdfBrushes.white,
        font: PdfStandardFont(PdfFontFamily.helvetica, 12,
            style: PdfFontStyle.bold),
        cellPadding: PdfPaddings(left: 5, top: 5, right: 5, bottom: 5),
        borders: PdfBorders(
          left: PdfPen(PdfColor(0, 0, 0)),
          top: PdfPen(PdfColor(0, 0, 0)),
          right: PdfPen(PdfColor(0, 0, 0)),
          bottom: PdfPen(PdfColor(0, 0, 0)),
        ),
      );

      // Apply header style
      for (int i = 0; i < headerRow.cells.count; i++) {
        headerRow.cells[i].style = headerStyle;
      }

      // Define row style with reduced font size and no background color
      final PdfGridCellStyle rowStyle = PdfGridCellStyle(
        textBrush: PdfBrushes.black,
        font: PdfStandardFont(PdfFontFamily.helvetica, 10), // Reduced font size
        cellPadding: PdfPaddings(left: 5, top: 5, right: 5, bottom: 5),
      );

      // Add rows with dummy data
      for (int i = 1; i <= 7; i++) {
        final PdfGridRow row = grid.rows.add();
        row.cells[0].value = 'Pond ID $i';
        row.cells[1].value = 'Farm ID $i';
        row.cells[2].value = 'Pond Name $i';
        row.cells[3].value = 'Farm Name $i';
        row.cells[4].value = 'Owner Name $i';

        // Apply row style
        for (int j = 0; j < row.cells.count; j++) {
          row.cells[j].style = rowStyle;
        }
      }

      // Draw the grid at the specified location on the page
      grid.draw(
          page: page,
          bounds: Rect.fromLTWH(0, 60, pageSize.width, pageSize.height - 60));

      // Adjust the position and height of the chart
      const double chartTopMargin = 300; // Increased top margin
      const double chartHeight = 170; // Reduced height for the chart
      page.graphics.drawImage(chartBitmap,
          Rect.fromLTWH(0, chartTopMargin, pageSize.width, chartHeight));

      // Add comments section below the chart
      const double commentsTopMargin = chartTopMargin + chartHeight + 20;
      const String comments = 'Comments: This is for testing purpose';
      page.graphics.drawString(
          comments, PdfStandardFont(PdfFontFamily.helvetica, 12),
          bounds: Rect.fromLTWH(0, commentsTopMargin, pageSize.width, 30),
          format: PdfStringFormat(
              alignment: PdfTextAlignment.left,
              lineAlignment: PdfVerticalAlignment.top));

      // Draw company logo at the bottom-right
      const double logoWidth = 85;
      const double logoHeight = 45;
      const double logoBottomMargin = 10;
      page.graphics.drawImage(
          logoBitmap,
          Rect.fromLTWH(
              pageSize.width - logoWidth - 10,
              pageSize.height + 290, // Adjusted position
              logoWidth,
              logoHeight));

      // Save PDF and initiate download
      final List<int> bytesList = document.saveSync();
      document.dispose();

      AnchorElement(
          href:
              "data:application/octet-stream;charset=utf-16le;base64,${base64.encode(bytesList)}")
        ..setAttribute("download", "output.pdf")
        ..click();

      MyToasts.toastSuccess("Chart has been exported as PDF document.");
    } catch (e) {
      print("error----$e");
    }
  }
}
