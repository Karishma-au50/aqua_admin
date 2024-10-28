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
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text("Selected Date Ranges"),
        Container(
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: List.generate(
                  controller.valueParameterModel.endDate!
                          .difference(controller.valueParameterModel.startDate!)
                          .inDays +
                      1,
                  (index) => controller.valueParameterModel.startDate!
                      .add(Duration(days: index))).map((e) {
                return InkWell(
                  onTap: () {
                    // isMultipleDatesSelected = false;
                    DateTime nextDay = DateTime(e.year, e.month, e.day + 1);
                    // changeDate(e, controller, nextDay);
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(4),
                          border: Border.all(
                            color:
                                //  !isSelected
                                //     ? const Color(0xFF050009).withOpacity(0.35)
                                //     :
                                Colors.transparent,
                          ),
                          color: Colors.red,
                          //  isSelected ? controller.graphColors[0] : null,
                          gradient:
                              //  !isSelected
                              //     ?
                              const LinearGradient(
                            colors: [
                              Color(0xFFACCEC4),
                              Color(0xFFDEFFF6),
                            ],
                          )
                          // : null,
                          ),
                      child: Center(
                        child: Text(
                          DateFormat("dd").format(e),
                          style: GlobalFonts.ts14px600w
                              .copyWith(color: Colors.black),
                        ),
                      ),
                    ),
                  ),
                );
              }).toList(),
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
                bool isSinglePond =
                    controller.waterQualityChartModel.isNotEmpty;

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
                        key: _chartKey,
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
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                'List Of Ponds',
                style: GlobalFonts.ts18px700w,
              ),
              const SizedBox(height: 10.0),
              Wrap(
                spacing: 12.0,
                children: controller.valueParameterModel.ponds!.map((e) {
                  return FilterChip(
                    label: Text(
                      e.pondId.toString(),
                      style: TextStyle(
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
                          if (_selectedIndexes.length < 8) {
                            _selectedIndexes.add(e.pondId!);
                          } else {
                            MyToasts.toastSuccess(
                              "You can select atmost 7 Ponds",
                            );
                          }
                        } else {
                          _selectedIndexes.removeWhere((p) => p == e.pondId);
                        }
                      });
                    },
                  );
                }).toList(),
              ),
            ],
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

  List<AreaSeries<SensorChartModel, DateTime>> _buildAreaSeries() {
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
          (element) => AreaSeries<SensorChartModel, DateTime>(
            dataSource: _filterDataByFrequency(element.data),
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
            emptyPointSettings: const EmptyPointSettings(
              mode: EmptyPointMode.gap,
              color: Colors.transparent,
              borderColor: Colors.transparent,
            ),
          ),
        )
        .toList();
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
}
