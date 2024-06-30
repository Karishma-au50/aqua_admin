import 'dart:convert';
import 'dart:html';
// import 'dart:html';
import 'dart:ui' as ui;

import 'package:admin/model/waterquality/water_qualiity_chart_model.dart';
import 'package:admin/shared/constant/global_variables.dart';
import 'package:admin/shared/widgets/buttons/my_button.dart';
import 'package:admin/shared/widgets/toast/my_toast.dart';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';

import '../../../../model/farm_model.dart';
import '../../../../model/pond_model.dart';
import '../../../../shared/constant/font_helper.dart';
import '../../../../shared/widgets/inputs/my_text_field.dart';
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
  final TextEditingController descController = TextEditingController();
  bool showAreaSeries = false;
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    bool isSinglePond = controller.waterQualityChartModel.length == 1;

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
              } else {
                bool isSinglePond =
                    controller.waterQualityChartModel.length == 1;

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (isSinglePond)
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          TextButton(
                            onPressed: () {
                              setState(() {
                                showAreaSeries = false;
                              });
                            },
                            child: Text(
                              'Line Chart',
                              style: TextStyle(
                                color:
                                    !showAreaSeries ? Colors.blue : Colors.grey,
                              ),
                            ),
                          ),
                          Switch(
                            // thumb color (round icon)
                            activeColor: Colors.white,
                            activeTrackColor: greenColor,
                            inactiveThumbColor: Colors.blueGrey.shade600,
                            inactiveTrackColor: Colors.grey.shade400,
                            splashRadius: 30.0,
                            value: showAreaSeries,
                            onChanged: (value) =>
                                setState(() => showAreaSeries = value),
                          ),
                          TextButton(
                            onPressed: () {
                              setState(() {
                                showAreaSeries = true;
                              });
                            },
                            child: Text(
                              'Area Chart',
                              style: TextStyle(
                                color:
                                    showAreaSeries ? Colors.blue : Colors.grey,
                              ),
                            ),
                          ),
                        ],
                      ),
                    Expanded(
                      child: SfCartesianChart(
                        key: ValueKey(showAreaSeries),
                        primaryXAxis: DateTimeAxis(
                          majorGridLines: const MajorGridLines(width: 0),
                          edgeLabelPlacement: EdgeLabelPlacement.shift,
                          intervalType: DateTimeIntervalType.auto,
                          dateFormat: DateFormat("dd MMM yy\nHH:mm:ss"),
                        ),
                        primaryYAxis: NumericAxis(
                          name: 'PrimaryYAxis',
                          title: AxisTitle(
                              text:
                                  '${controller.waterQualityChartModel.first.sensor} Value'),
                        ),
                        axes: controller.valueParameterModel.isComb
                            ? [
                                NumericAxis(
                                    name: 'SecondaryYAxis',
                                    opposedPosition: true,
                                    title: AxisTitle(
                                        text:
                                            '${controller.waterQualityChartModel.last.sensor}  Value')),
                              ]
                            : [],
                        series: showAreaSeries
                            ? _buildAreaSeries()
                            : _buildLineSeries(),
                        tooltipBehavior: TooltipBehavior(enable: true),
                        trackballBehavior: TrackballBehavior(
                          enable: true,
                          activationMode: ActivationMode.none,
                          tooltipSettings: const InteractiveTooltip(
                            enable: true,
                            color: Colors.black,
                            textStyle: TextStyle(color: Colors.white),
                          ),
                        ),
                        legend: const Legend(
                            isVisible: true,
                            position: LegendPosition.top,
                            overflowMode: LegendItemOverflowMode.wrap,
                            alignment: ChartAlignment.center),
                      ),
                    ),
                  ],
                );
              }
            }),
          ),
        ),

        // Padding(
        //   padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20),
        //   child: SizedBox(
        //     height: 300,
        //     child: Obx(() {
        //       if (controller.waterQualityChartModel.isEmpty) {
        //         return const Center(
        //           child: Text("No Data Found"),
        //         );
        //       } else {
        //         if (isSinglePond) {
        //           return Row(
        //             mainAxisAlignment: MainAxisAlignment.center,
        //             children: [
        //               Text('Show Area Series'),
        //               Switch(
        //                 value: showAreaSeries,
        //                 onChanged: (value) {
        //                   setState(() {
        //                     showAreaSeries = true;
        //                   });
        //                 },
        //               ),
        //             ],
        //           );
        //         }
        //         return SfCartesianChart(
        //           key: ValueKey(showAreaSeries),
        //           primaryXAxis: DateTimeAxis(
        //             majorGridLines: const MajorGridLines(width: 0),
        //             edgeLabelPlacement: EdgeLabelPlacement.shift,
        //             intervalType: DateTimeIntervalType.auto,
        //             dateFormat: DateFormat("dd MMM yy\nHH:mm:ss"),
        //           ),
        //           primaryYAxis: NumericAxis(
        //             name: 'PrimaryYAxis',
        //             title: AxisTitle(
        //                 text:
        //                     '${controller.waterQualityChartModel.first.sensor} Value'),
        //           ),
        //           axes: controller.valueParameterModel.isComb
        //               ? [
        //                   NumericAxis(
        //                       name: 'SecondaryYAxis',
        //                       opposedPosition: true,
        //                       title: AxisTitle(
        //                           text:
        //                               '${controller.waterQualityChartModel.last.sensor}  Value')),
        //                 ]
        //               : [],
        //           series:
        //               showAreaSeries ? _buildAreaSeries() : _buildLineSeries(),
        //           tooltipBehavior: TooltipBehavior(enable: true),
        //           trackballBehavior: TrackballBehavior(
        //             enable: true,
        //             activationMode: ActivationMode.none,
        //             tooltipSettings: const InteractiveTooltip(
        //               enable: true,
        //               color: Colors.black,
        //               textStyle: TextStyle(color: Colors.white),
        //             ),
        //           ),
        //           legend: const Legend(
        //               isVisible: true,
        //               position: LegendPosition.top,
        //               overflowMode: LegendItemOverflowMode.wrap,
        //               alignment: ChartAlignment.center),
        //         );
        //       }
        //       return SizedBox();
        //       // SfCartesianChart(
        //       //   key: _chartKey,
        //       //   primaryXAxis: DateTimeAxis(
        //       //     majorGridLines: const MajorGridLines(width: 0),
        //       //     edgeLabelPlacement: EdgeLabelPlacement.shift,
        //       //     intervalType: DateTimeIntervalType.auto,
        //       //     dateFormat: DateFormat("dd MMM yy\nHH:mm:ss"),
        //       //   ),
        //       //   primaryYAxis: NumericAxis(
        //       //     name: 'PrimaryYAxis',
        //       //     title: AxisTitle(
        //       //         text:
        //       //             '${controller.waterQualityChartModel.first.sensor} Value'),
        //       //   ),
        //       //   axes: controller.valueParameterModel.isComb
        //       //       ? [
        //       //           NumericAxis(
        //       //               name: 'SecondaryYAxis',
        //       //               opposedPosition: true,
        //       //               title: AxisTitle(
        //       //                   text:
        //       //                       '${controller.waterQualityChartModel.last.sensor}  Value'
        //       //                   // controller
        //       //                   //     .waterQualityChartModel.first.sensor),
        //       //                   )),
        //       //         ]
        //       //       : [],
        //       //   series: _buildLineSeries(),
        //       //   tooltipBehavior: TooltipBehavior(enable: true),
        //       //   trackballBehavior: TrackballBehavior(
        //       //     enable: true,
        //       //     activationMode: ActivationMode.none,
        //       //     tooltipSettings: const InteractiveTooltip(
        //       //       enable: true,
        //       //       color: Colors.black,
        //       //       textStyle: TextStyle(color: Colors.white),
        //       //     ),
        //       //   ),
        //       //   legend: const Legend(
        //       //       isVisible: true,
        //       //       position: LegendPosition.top,
        //       //       overflowMode: LegendItemOverflowMode.wrap,
        //       //       alignment: ChartAlignment.center),
        //       // );
        //     }),
        //   ),
        // ),

        Obx(() {
          if (controller.waterQualityChartModel.isNotEmpty) {
            return Container(
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
                    bool isSelected = item == selectedFrequency;
                    return AnimatedContainer(
                      duration: const Duration(seconds: 500),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 6.0, vertical: 6),
                      child: TextButton(
                        style: TextButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          padding: const EdgeInsets.fromLTRB(2, 2, 2, 2),
                          backgroundColor:
                              isSelected ? greenColor : Colors.white,
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
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: isSelected
                                  ? Colors.white
                                  : const Color(0xff767B84),
                            ),
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
            );
          } else {
            return const SizedBox();
          }
        }),
        Obx(() {
          if (controller.waterQualityChartModel.isNotEmpty) {
            return MyTextField(
              controller: descController,
              hintText: "",
              labelText: "Notes",
              hindStyle: GlobalFonts.ts14px500w,
              maxLines: 4,
            );
          } else {
            return const SizedBox();
          }
        }),
        Obx(() {
          if (controller.waterQualityChartModel.isNotEmpty) {
            return Align(
              alignment: Alignment.topRight,
              child: Padding(
                padding: const EdgeInsets.all(15.0),
                child: MyButton(
                  width: 100,
                  textStyle: GlobalFonts.ts14px600w,
                  text: "EXPORT PDF",
                  onPressed: _renderPdf,
                ),
              ),
            );
          } else {
            return const SizedBox();
          }
        }),
      ],
    );
  }

  List<AreaSeries<SensorChartModel, DateTime>> _buildAreaSeries() {
    List<Color> colors = [
      Colors.orange,
      Colors.green,
      Colors.blue,
      Colors.red,
      Colors.purple,
      Colors.cyan
    ];
    // final DateTime startDate = DateTime(  26,Jun,2024);
    // final DateTime endDate = DateTime(2024, 6, 27);
    DateTime startTime = DateTime(0, 1, 1, 8, 0, 0); // 8:00 AM
    DateTime endTime = DateTime(0, 1, 1, 20, 0, 0); // 8:00 PM

    return controller.waterQualityChartModel.map(
      (element) {
        final day = element.data.where((date) {
          DateTime timeOnly = DateTime(0, 1, 1, date.dateTime.hour,
              date.dateTime.minute, date.dateTime.second);
          return timeOnly.isAfter(startTime) && timeOnly.isBefore(endTime);
        }).toList();

        final night = element.data.where((date) {
          DateTime timeOnly = DateTime(0, 1, 1, date.dateTime.hour,
              date.dateTime.minute, date.dateTime.second);
          return timeOnly.isBefore(startTime) && timeOnly.isAfter(endTime);
        }).toList();

        return AreaSeries<SensorChartModel, DateTime>(
          dataSource: _filterDataByFrequency(day),
          xValueMapper: (data, _) => data.dateTime,
          yValueMapper: (data, _) => data.value,
          borderColor: colors[
              controller.waterQualityChartModel.indexOf(element) %
                  colors.length],
          borderWidth: 2,
          color: colors[controller.waterQualityChartModel.indexOf(element) %
                  colors.length]
              .withOpacity(0.5),
          name: "${element.sensor} (${element.pondId})",
          markerSettings: const MarkerSettings(isVisible: false),
          // pointColorMapper: (datum, in
          //dex) {},
          emptyPointSettings: const EmptyPointSettings(
            mode: EmptyPointMode.gap,
            color: Colors.transparent,
            borderColor: Colors.transparent,
          ),
        );
      },
    ).toList();
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

    return controller.waterQualityChartModel
        .map(
          (element) => LineSeries<SensorChartModel, DateTime>(
            dataSource: _filterDataByFrequency(element.data),
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

  // List<AreaSeries<SensorChartModel, DateTime>> _buildLineSeries() {
  //   List<Color> colors = [
  //     Colors.orange,
  //     Colors.green,
  //     Colors.blue,
  //     Colors.red,
  //     Colors.purple,
  //     Colors.cyan
  //   ];

  //   // Filter data based on selected frequency
  //   return controller.waterQualityChartModel
  //       .map(
  //         (element) => AreaSeries<SensorChartModel, DateTime>(
  //           dataSource: _filterDataByFrequency(element.data),
  //           xValueMapper: (data, _) => data.dateTime,
  //           yValueMapper: (data, _) => data.value,
  //           borderColor: colors[
  //               controller.waterQualityChartModel.indexOf(element) %
  //                   colors.length],
  //           borderWidth: 2,
  //           color: colors[controller.waterQualityChartModel.indexOf(element) %
  //                   colors.length]
  //               .withOpacity(0.5),
  //           name: "${element.sensor} (${element.pondId})",
  //           markerSettings: const MarkerSettings(isVisible: false),
  //           emptyPointSettings: const EmptyPointSettings(
  //             mode: EmptyPointMode.gap,
  //             color: Colors.transparent,
  //             borderColor: Colors.transparent,
  //           ),
  //         ),
  //       )
  //       .toList();
  //   // return controller.waterQualityChartModel
  //   //     .map(
  //   //       (element) => LineSeries<SensorChartModel, DateTime>(
  //   //         dataSource: _filterDataByFrequency(element.data),
  //   //         xValueMapper: (data, _) => data.dateTime,
  //   //         yValueMapper: (data, _) => data.value,
  //   //         markerSettings: const MarkerSettings(isVisible: false),
  //   //         color: colors[controller.waterQualityChartModel.indexOf(element) %
  //   //             colors.length],
  //   //         name: "${element.sensor} (${element.pondId})",
  //   //         emptyPointSettings: const EmptyPointSettings(
  //   //           mode: EmptyPointMode.gap,
  //   //           color: Colors.transparent,
  //   //           borderColor: Colors.transparent,
  //   //         ),
  //   //         // yAxisName:
  //   //         //     element.sensor == 'DO' ? 'SecondaryYAxis' : 'PrimaryYAxis',
  //   //       ),
  //   //     )
  //   //     .toList();
  // }

  Widget buildChart() {
    return SfCartesianChart(
      legend: const Legend(isVisible: true, position: LegendPosition.top),
      series: _buildLineSeries(),
      primaryXAxis: const DateTimeAxis(),
      primaryYAxis: const NumericAxis(),
    );
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

  Future<void> _renderPdf() async {
    try {
      final value = controller.valueParameterModel;
      // Capture chart image
      final RenderRepaintBoundary boundary =
          _chartKey.currentContext!.findRenderObject() as RenderRepaintBoundary;
      final ui.Image chartImage = await boundary.toImage(pixelRatio: 3.0);
      final ByteData? chartBytes =
          await chartImage.toByteData(format: ui.ImageByteFormat.png);
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

      // Draw company logo at the top-left
      const double logoWidth = 85;
      const double logoHeight = 45;
      page.graphics.drawImage(
        logoBitmap,
        const Rect.fromLTWH(10, 12, logoWidth, logoHeight),
      );

      // Draw chart heading at the top-center
      String chartHeading = 'Water Quality Parameters Report';
      page.graphics.drawString(
        chartHeading,
        PdfStandardFont(PdfFontFamily.helvetica, 20),
        bounds: Rect.fromLTWH(0, 13, pageSize.width, 30),
        format: PdfStringFormat(
          alignment: PdfTextAlignment.center,
          lineAlignment: PdfVerticalAlignment.middle,
        ),
      );

      // Draw start and end date below the chart heading
      String dateRange =
          'Date Range: ${value.startDate?.toLocal().toString().split(' ')[0]} to ${value.endDate?.toLocal().toString().split(' ')[0]}';
      String downloadTime =
          'Reported On: ${DateFormat('yyyy-MM-dd,HH:mm:ss').format(DateTime.now().toLocal())}'; // Format for date and time

      String sensorName = 'Sensor: ${value.sensor ?? 'N/A'}';
      page.graphics.drawString(
        dateRange,
        PdfStandardFont(PdfFontFamily.helvetica, 12,
            style: PdfFontStyle.regular),
        bounds: Rect.fromLTWH(0, 50, pageSize.width, 20),
        format: PdfStringFormat(
          alignment: PdfTextAlignment.center,
          lineAlignment: PdfVerticalAlignment.middle,
        ),
      );

      page.graphics.drawString(
        downloadTime,
        PdfStandardFont(PdfFontFamily.helvetica, 12,
            style: PdfFontStyle.regular),
        bounds: Rect.fromLTWH(0, 70, pageSize.width, 20),
        format: PdfStringFormat(
          alignment: PdfTextAlignment.center,
          lineAlignment: PdfVerticalAlignment.middle,
        ),
      );

      // Draw sensor name below the date range
      page.graphics.drawString(
        sensorName,
        PdfStandardFont(PdfFontFamily.helvetica, 12,
            style: PdfFontStyle.regular),
        bounds: Rect.fromLTWH(0, 90, pageSize.width, 20),
        format: PdfStringFormat(
          alignment: PdfTextAlignment.center,
          lineAlignment: PdfVerticalAlignment.middle,
        ),
      );

      // Draw table with actual data
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
        backgroundBrush: PdfBrushes.gray, // Red background for header
        textBrush: PdfBrushes.white,
        font: PdfStandardFont(PdfFontFamily.helvetica, 12,
            style: PdfFontStyle.bold),
        cellPadding: PdfPaddings(left: 5, top: 5, right: 5, bottom: 5),
        borders: PdfBorders(
          left: PdfPens.black,
          top: PdfPens.black,
          right: PdfPens.black,
          bottom: PdfPens.black,
        ),
      );

      // Apply header style
      for (int i = 0; i < headerRow.cells.count; i++) {
        headerRow.cells[i].style = headerStyle;
      }

      // Define row style with reduced font size
      final PdfGridCellStyle rowStyle = PdfGridCellStyle(
        textBrush: PdfBrushes.black,
        font: PdfStandardFont(PdfFontFamily.helvetica, 10),
        cellPadding: PdfPaddings(left: 5, top: 5, right: 5, bottom: 5),
        borders: PdfBorders(
          left: PdfPens.black,
          top: PdfPens.black,
          right: PdfPens.black,
          bottom: PdfPens.black,
        ),
      );

      // Define list of colors for row backgrounds
      List<PdfColor> rowColors = [
        PdfColor(255, 255, 0), // Yellow
        PdfColor(0, 255, 0), // Green
        PdfColor(0, 0, 255), // Blue
        PdfColor(255, 0, 255), // Purple
        PdfColor(0, 255, 255), // Cyan
        PdfColor(255, 128, 0), // Orange
      ];

      // Add rows with actual data
      for (int i = 0; i < (value.ponds ?? []).length; i++) {
        PondModel pond = value.ponds![i];
        FarmModel? farm = value.farms?.firstWhere(
          (f) => f.farmId == pond.farmId,
          orElse: () => FarmModel(name: ''),
        );

        final PdfGridRow row = grid.rows.add();
        row.cells[0].value = pond.pondId.toString();
        row.cells[1].value = pond.farmId.toString();
        row.cells[2].value = pond.name ?? 'N/A';
        row.cells[3].value = farm?.name ?? 'N/A';
        row.cells[4].value = farm?.ownerName ?? 'N/A';

        // Set background color for each row
        row.style = PdfGridCellStyle(
          textBrush: PdfSolidBrush(rowColors[i % rowColors.length]),
        );

        // Apply row style
        for (int j = 0; j < row.cells.count; j++) {
          row.cells[j].style = rowStyle;
        }
      }

      // Draw the grid at the specified location on the page
      grid.draw(
        page: page,
        bounds: Rect.fromLTWH(0, 150, pageSize.width, pageSize.height - 100),
      );

      // Adjust the position and height of the chart
      const double chartTopMargin = 300; // Increased top margin
      const double chartHeight = 170; // Reduced height for the chart
      page.graphics.drawImage(
        chartBitmap,
        Rect.fromLTWH(0, chartTopMargin, pageSize.width, chartHeight),
      );

      // Add comments section below the chart
      const double commentsTopMargin = chartTopMargin + chartHeight + 20;
      String comments = 'Comments: ${descController.text}';
      page.graphics.drawString(
        comments,
        PdfStandardFont(PdfFontFamily.helvetica, 12),
        bounds: Rect.fromLTWH(0, commentsTopMargin, pageSize.width, 30),
        format: PdfStringFormat(
          alignment: PdfTextAlignment.left,
          lineAlignment: PdfVerticalAlignment.top,
        ),
      );

      // Save PDF and initiate download
      final List<int> bytesList = await document.save();
      document.dispose();

      AnchorElement(
        href:
            "data:application/octet-stream;charset=utf-16le;base64,${base64.encode(bytesList)}",
      )
        ..setAttribute("download", "output.pdf")
        ..click();

      MyToasts.toastSuccess("Chart has been exported as PDF document.");
    } catch (e) {
      // print("error----$e");
      MyToasts.toastError("Error exporting chart as PDF document.");
    }
  }
}
