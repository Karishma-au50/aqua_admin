import 'package:admin/shared/utils/extensions.dart';
import 'package:admin/shared/widgets/toast/my_toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import '../../../../model/waterquality/water_qualiity_chart_model.dart';
import '../../../../shared/constant/font_helper.dart';
import '../../../../shared/constant/global_variables.dart';
import '../../controller/water_quality_controller.dart';

class DifferenceChart extends StatefulWidget {
  const DifferenceChart({super.key});

  @override
  State<DifferenceChart> createState() => _DifferenceChartState();
}

class _DifferenceChartState extends State<DifferenceChart> {
  final WaterQualityController controller = Get.find();
  // DateTime selectedDates = DateTime.now().removeTime();
  final GlobalKey<SfCartesianChartState> _chartKey = GlobalKey();
  String selectedFrequency = '5 mins';
  final TextEditingController descController = TextEditingController();
  bool showAreaSeries = false;
  final List<int> _selectedIndexes = [];
  List<DateTime> selectedDates = [];
  late final List<DateTime> _viewDates;
  List<Color> legendColors = [
    const Color(0xFFCC79A7),
    const Color(0xFFE69400),
    const Color(0xFF56B4E9),
    const Color(0xFF009E73),
    const Color(0xFF0072B2),
    const Color(0xFF422211),
    const Color(0xFFD55E00),
  ];
  @override
  void initState() {
    super.initState();
    _viewDates = List.generate(
        controller.valueParameterModel.endDate!
                .difference(controller.valueParameterModel.startDate!)
                .inDays +
            1,
        (index) => controller.valueParameterModel.startDate!
            .add(Duration(days: index)));

    _changedate(_viewDates.last);
    _selectedIndexes.add(controller.valueParameterModel.ponds!.first.pondId!);
  }

  void _changedate(DateTime date, {bool isMultipleDatesSelected = false}) {
    if (!isMultipleDatesSelected) {
      selectedDates.clear();
    }
    if (!selectedDates.contains(date)) {
      selectedDates.add(date);
    } else {
      selectedDates.remove(date);
    }
    setState(() {});
  }

  // Modify Line Axis Lable
  String modifyLineAxisLable(String lableToModify) {
    lableToModify = lableToModify.split(".")[0];
    String finalLableToModify;

    if (lableToModify.length != 4) {
      finalLableToModify = lableToModify.padLeft(4, "0");
    } else {
      finalLableToModify = lableToModify;
    }

    String lableHrs = finalLableToModify.substring(0, 2);
    String lableMins = finalLableToModify.substring(2, 4);
    String lable24HrsTime = [lableHrs, lableMins].join(":");

    String fixedDateString = "2023-01-01 $lable24HrsTime";
    DateTime dateTime = DateTime.parse(fixedDateString);

    // Format the DateTime object with a 12-hour format
    String formattedTime = DateFormat('h:mm a').format(dateTime);
    DateTime lableDateTime12Hrs = DateFormat('h:mm a').parse(formattedTime);

    String lableToDisplay = DateFormat('h a').format(lableDateTime12Hrs);

    return lableToDisplay;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(
          height: 20,
        ),
        SizedBox(
          height: 40,
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              shrinkWrap: true,
              itemCount: controller.valueParameterModel.endDate!
                      .difference(controller.valueParameterModel.startDate!)
                      .inDays +
                  1,
              itemBuilder: (context, index) {
                DateTime e = controller.valueParameterModel.startDate!
                    .add(Duration(days: index));

                return InkWell(
                  onTap: () {
                    DateTime nextDay = DateTime(e.year, e.month, e.day + 1);
                    _changedate(e);
                  },
                  onLongPress: () {
                    _selectedIndexes.length > 1
                        ? null
                        : _changedate(e, isMultipleDatesSelected: true);
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(4),
                        border: Border.all(
                          color: Colors.transparent,
                        ),
                        color: selectedDates.contains(e) ? greenColor : null,
                        gradient: selectedDates.contains(e)
                            ? null
                            : const LinearGradient(
                                colors: [
                                  Color(0xFFACCEC4),
                                  Color(0xFFDEFFF6),
                                ],
                              ),
                      ),
                      child: Center(
                        child: Text(
                          DateFormat("dd").format(e),
                          style: GlobalFonts.ts14px600w
                              .copyWith(color: Colors.white),
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ),
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
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: SfCartesianChart(
                        key: _chartKey,
                        primaryXAxis: DateTimeAxis(
                          plotBands: List.generate(
                              controller.valueParameterModel.endDate!
                                      .difference(controller
                                          .valueParameterModel.startDate!)
                                      .inDays +
                                  1,
                              (index) => controller
                                  .valueParameterModel.startDate!
                                  .add(Duration(days: index))).map((e) {
                            return PlotBand(
                                start: e
                                    .addDate(-1)
                                    .copyWith(hour: 20, minute: 0, second: 0),
                                end: e.copyWith(hour: 8, minute: 0, second: 0),
                                gradient: LinearGradient(
                                  colors: [
                                    Colors.black.withOpacity(0.3),
                                    Colors.black.withOpacity(0.2),
                                  ],
                                ));
                          }).toList(),
                          majorGridLines: const MajorGridLines(width: 0),
                          edgeLabelPlacement: EdgeLabelPlacement.shift,
                          intervalType: DateTimeIntervalType.auto,
                          dateFormat: DateFormat("HH:mm"),
                        ),
                        primaryYAxis: NumericAxis(
                          name: 'PrimaryYAxis',
                          title: AxisTitle(
                            text:
                                '${controller.waterQualityChartModel.first.sensor} Value',
                          ),
                        ),
                        axes: controller.valueParameterModel.isComb
                            ? [
                                NumericAxis(
                                  name: 'SecondaryYAxis',
                                  opposedPosition: true,
                                  title: AxisTitle(
                                    text:
                                        '${controller.waterQualityChartModel.last.sensor} Value',
                                  ),
                                ),
                              ]
                            : [],
                        series: _buildLineSeries(),
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
                          alignment: ChartAlignment.center,
                        ),
                      ),
                    ),
                  ],
                );
              }
            }),
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          width: double.maxFinite,
          child: Wrap(
            spacing: 12.0,
            children: controller.valueParameterModel.ponds!.map((e) {
              return FilterChip(
                label: Text(
                  e.name.toString(),
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                  ),
                ),
                selected: _selectedIndexes.contains(e.pondId),
                checkmarkColor: Colors.transparent,
                showCheckmark: false,
                selectedColor: (_selectedIndexes.contains(e.pondId))
                    ? legendColors[_selectedIndexes.indexOf(e.pondId!)]
                    : Colors.black,
                onSelected: (bool selected) {
                  setState(() {
                    if (selected) {
                      if (selectedDates.length > 1) {
                        if (_selectedIndexes.isNotEmpty) {
                          MyToasts.toastError(
                            "Cannot select more than one pond when multiple dates are selected.",
                          );
                          return;
                        } else {
                          _selectedIndexes.add(e.pondId!);
                        }
                      } else {
                        if (_selectedIndexes.length < 8) {
                          _selectedIndexes.add(e.pondId!);
                        } else {
                          MyToasts.toastSuccess(
                            "You can select at most 7 ponds",
                          );
                        }
                      }
                    } else {
                      _selectedIndexes.removeWhere((p) => p == e.pondId);
                    }
                  });
                },
              );
            }).toList(),
          ),
        ),
      ],
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

  List<LineSeries<SensorChartModel, DateTime>> _buildLineSeries() {
    List<Color> colors = [
      Colors.orange,
      Colors.green,
      Colors.blue,
      Colors.red,
      Colors.purple,
      Colors.cyan,
    ];

    final chartData = controller.waterQualityChartModel
        .where((p0) => _selectedIndexes.contains(p0.pondId));

    if (selectedDates.length > 1) {
      List<LineSeries<SensorChartModel, DateTime>> listData = [];
      int colorIndex = 0;

      for (DateTime date in selectedDates) {
        final data = chartData.first.data
            .where((p0) => date == p0.dateTime.removeTime())
            .map((e) {
          DateTime tempDate = e.dateTime.copyWith(year: 2023, month: 1, day: 1);
          return e.copyWith(derivedTime: tempDate.millisecondsSinceEpoch);
        }).toList();

        if (data.isNotEmpty) {
          // Check if data is not empty
          listData.add(LineSeries<SensorChartModel, DateTime>(
            dataSource: _filterDataByFrequency(data),
            xValueMapper: (data, _) => data.dateTime,
            yValueMapper: (data, _) => data.value,
            markerSettings: const MarkerSettings(isVisible: false),
            color: colors[colorIndex % colors.length],
            name: "${chartData.first.sensor} (${chartData.first.pondId})",
            emptyPointSettings: const EmptyPointSettings(
              mode: EmptyPointMode.gap,
              color: Color.fromRGBO(0, 0, 0, 0),
              borderColor: Colors.transparent,
            ),
          ));
          colorIndex++;
        }
      }
      return listData;
    }

    return chartData
        .map((element) {
          final data = element.data
              .where((p0) => selectedDates.contains(p0.dateTime.removeTime()))
              .toList();
          int elementIndex = controller.waterQualityChartModel.indexOf(element);

          if (data.isNotEmpty) {
            return LineSeries<SensorChartModel, DateTime>(
              dataSource: _filterDataByFrequency(data),
              xValueMapper: (data, _) => data.dateTime,
              yValueMapper: (data, _) => data.value,
              markerSettings: const MarkerSettings(isVisible: false),
              color: colors[elementIndex % colors.length],
              name: "${element.sensor} (${element.pondId})",
              emptyPointSettings: const EmptyPointSettings(
                mode: EmptyPointMode.gap,
                color: Color.fromRGBO(0, 0, 0, 0),
                borderColor: Colors.transparent,
              ),
            );
          }
          return null;
        })
        .whereType<LineSeries<SensorChartModel, DateTime>>()
        .toList();
  }

  // List<LineSeries<SensorChartModel, DateTime>> _buildLineSeries() {
  //   List<Color> colors = [
  //     Colors.orange,
  //     Colors.green,
  //     Colors.blue,
  //     Colors.red,
  //     Colors.purple,
  //     Colors.cyan
  //   ];

  //   final chartData = controller.waterQualityChartModel
  //       .where((p0) => _selectedIndexes.contains(p0.pondId));

  //   if (selectedDates.length > 1) {
  //     List<LineSeries<SensorChartModel, DateTime>> listData = [];
  //     int colorIndex = 0;

  //     for (DateTime date in selectedDates) {
  //       final data = chartData.first.data
  //           .where((p0) => date == p0.dateTime.removeTime())
  //           .map((e) {
  //         DateTime tempDate = e.dateTime.copyWith(year: 2023, month: 1, day: 1);
  //         return e.copyWith(derivedTime: tempDate.millisecondsSinceEpoch);
  //       }).toList();

  //       listData.add(LineSeries<SensorChartModel, DateTime>(
  //         dataSource: _filterDataByFrequency(data),
  //         xValueMapper: (data, _) => data.dateTime,
  //         yValueMapper: (data, _) => data.value,
  //         markerSettings: const MarkerSettings(isVisible: false),
  //         color: colors[colorIndex %
  //             colors.length], // Use colorIndex for different colors
  //         name: "${chartData.first.sensor} (${chartData.first.pondId})",
  //         emptyPointSettings: const EmptyPointSettings(
  //           mode: EmptyPointMode.gap,
  //           color: Color.fromRGBO(0, 0, 0, 0),
  //           borderColor: Colors.transparent,
  //         ),
  //       ));

  //       colorIndex++; // Increment color index for the next series
  //     }
  //     return listData;
  //   }

  //   return chartData.map((element) {
  //     final data = element.data
  //         .where((p0) => selectedDates.contains(p0.dateTime.removeTime()))
  //         .toList();
  //     int elementIndex = controller.waterQualityChartModel.indexOf(element);

  //     return LineSeries<SensorChartModel, DateTime>(
  //       dataSource: _filterDataByFrequency(data),
  //       xValueMapper: (data, _) => data.dateTime,
  //       yValueMapper: (data, _) => data.value,
  //       markerSettings: const MarkerSettings(isVisible: false),
  //       color: colors[elementIndex %
  //           colors.length], // Use elementIndex for color selection
  //       name: "${element.sensor} (${element.pondId})",
  //       emptyPointSettings: const EmptyPointSettings(
  //         mode: EmptyPointMode.gap,
  //         color: Color.fromRGBO(0, 0, 0, 0),
  //         borderColor: Colors.transparent,
  //       ),
  //     );
  //   }).toList();
  // }
}
