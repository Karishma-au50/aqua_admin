import 'dart:convert';
import 'dart:html';
import 'dart:ui' as ui;

import 'package:admin/shared/constant/global_variables.dart';
import 'package:admin/shared/widgets/buttons/my_button.dart';
import 'package:admin/shared/widgets/toast/my_toast.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';

import '../../../../shared/constant/app_colors.dart';
import '../../../../shared/constant/font_helper.dart';

class LineChart extends StatefulWidget {
  const LineChart({super.key});

  @override
  State<LineChart> createState() => _LineChartState();
}

class _LineChartState extends State<LineChart> {
  final GlobalKey<SfCartesianChartState> _chartKey = GlobalKey();
  List<Map<String, dynamic>> chartData = [
    {
      "year": 2005,
      "series": [24, 55, 30, 45, 60]
    },
    {
      "year": 2006,
      "series": [25, 65, 35, 50, 65]
    },
    {
      "year": 2007,
      "series": [29, 68, 40, 55, 70]
    },
    {
      "year": 2008,
      "series": [32, 60, 45, 60, 75]
    },
    {
      "year": 2009,
      "series": [34, 55, 50, 65, 80]
    },
    {
      "year": 2010,
      "series": [50, 67, 55, 70, 85]
    },
    {
      "year": 2011,
      "series": [44, 81, 60, 75, 90]
    },
    {
      "year": 2012,
      "series": [60, 88, 65, 80, 95]
    },
  ];
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20),
          child: SizedBox(
            height: 300,
            child: SfCartesianChart(
              key: _chartKey,
              tooltipBehavior: TooltipBehavior(enable: true),
              series: _buildLineSeries(),
              trackballBehavior: TrackballBehavior(
                enable: true,
                activationMode: ActivationMode.none,
                tooltipSettings: InteractiveTooltip(
                  enable: true,
                  color: Colors.black,
                  textStyle: TextStyle(color: Colors.white),
                ),
              ),
            ),
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
                      onPressed: () {},
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

  List<LineSeries<Map<String, dynamic>, int>> _buildLineSeries() {
    int numSeries = chartData.first['series'].length;

    List<Color> colors = [
      Colors.orange,
      Colors.green,
      Colors.blue,
      Colors.red,
      Colors.purple,
      Colors.cyan
    ];

    return List.generate(numSeries, (index) {
      return LineSeries<Map<String, dynamic>, int>(
        dataSource: chartData,
        xValueMapper: (data, _) => data['year'],
        yValueMapper: (data, _) => data['series'][index],
        markerSettings: const MarkerSettings(isVisible: true),
        color: colors[index % colors.length],
      );
    });
  }

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

      // Set the size of the page to fit the chart image
      document.pageSettings.size =
          Size(chartBitmap.width.toDouble(), chartBitmap.height.toDouble());

      // Draw company logo at the top-left
      const double logoWidth = 85;
      const double logoHeight = 45;
      page.graphics
          .drawImage(logoBitmap, Rect.fromLTWH(10, 10, logoWidth, logoHeight));

      // Draw chart heading at the top-center
      const String chartHeading = 'Water Quality Parameters Report';
      page.graphics.drawString(
          chartHeading, PdfStandardFont(PdfFontFamily.helvetica, 20),
          bounds: Rect.fromLTWH(0, 10, pageSize.width, 30),
          format: PdfStringFormat(
              alignment: PdfTextAlignment.center,
              lineAlignment: PdfVerticalAlignment.middle));

      // Draw farmer name and mobile number in the center, side by side
      const String farmerName = 'Prashant Mohania';
      const String mobileNumber = '7417485874';
      page.graphics.drawString('$farmerName | $mobileNumber',
          PdfStandardFont(PdfFontFamily.helvetica, 12),
          bounds: Rect.fromLTWH(0, 50, pageSize.width, 20),
          format: PdfStringFormat(
              alignment: PdfTextAlignment.center,
              lineAlignment: PdfVerticalAlignment.middle));

      // Draw farm name, pond name, and reported time at the top-right
      const String farmName = 'Farm';
      const String pondName = 'Pond';
      const String reportedTime = 'Reported On';
      page.graphics.drawString('$reportedTime\n$pondName\n$farmName',
          PdfStandardFont(PdfFontFamily.helvetica, 12),
          bounds: Rect.fromLTWH(pageSize.width - 120, 10, 110, 60),
          format: PdfStringFormat(
              alignment: PdfTextAlignment.right,
              lineAlignment: PdfVerticalAlignment.top));

      // Draw chart image below the header text and images
      const double chartTopMargin = 90;
      page.graphics.drawImage(
          chartBitmap,
          Rect.fromLTWH(0, chartTopMargin, pageSize.width,
              pageSize.height - chartTopMargin));

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
