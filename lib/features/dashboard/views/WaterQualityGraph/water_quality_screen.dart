import 'package:admin/features/dashboard/views/WaterQualityGraph/line_chart.dart';
import 'package:admin/features/dashboard/views/WaterQualityGraph/value_parameter.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class WaterQualityScreen extends StatefulWidget {
  const WaterQualityScreen({super.key});

  @override
  State<WaterQualityScreen> createState() => _WaterQualityScreenState();
}

class _WaterQualityScreenState extends State<WaterQualityScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 6),
          child: Column(
            children: [
              const ValueParameter(),
              const SizedBox(
                height: 20,
              ),
              const LineChart(),
              TimeBasedColorChart(
                chartData: [
                  ChartData(DateTime(2024, 7, 1, 5), 10),
                  ChartData(DateTime(2024, 7, 1, 7), 20),
                  ChartData(DateTime(2024, 7, 1, 15), 30),
                  ChartData(DateTime(2024, 7, 1, 19), 25),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class TimeBasedColorChart extends StatelessWidget {
  final List<ChartData> chartData;

  const TimeBasedColorChart({super.key, required this.chartData});

  @override
  Widget build(BuildContext context) {
    return SfCartesianChart(
      primaryXAxis: const DateTimeAxis(),
      primaryYAxis: const NumericAxis(),
      series: <CartesianSeries>[
        // Daytime data series
        AreaSeries<ChartData, DateTime>(
          dataSource: chartData.where(isDayTime).toList(),
          xValueMapper: (ChartData data, _) => data.dateTime,
          yValueMapper: (ChartData data, _) => data.value,
          color: Colors.blue,
        ),
        // Nighttime data series
        AreaSeries<ChartData, DateTime>(
          dataSource: chartData.where((data) => !isDayTime(data)).toList(),
          xValueMapper: (ChartData data, _) => data.dateTime,
          yValueMapper: (ChartData data, _) => data.value,
          color: Colors.grey,
        ),
      ],
    );
    //  SfCartesianChart(
    //   primaryXAxis: const DateTimeAxis(),
    //   primaryYAxis: const NumericAxis(),
    //   series: <CartesianSeries>[
    //     AreaSeries<ChartData, DateTime>(
    //       dataSource: chartData,
    //       xValueMapper: (ChartData data, _) => data.dateTime,
    //       yValueMapper: (ChartData data, _) => data.value,

    //       pointColorMapper: (ChartData data, _) {
    //         Color color = isDayTime(data.dateTime) ? Colors.blue : Colors.grey;
    //         print(
    //             'DateTime: ${data.dateTime}, Color: ${color == Colors.blue ? "Blue" : "Grey"}');
    //         return color;
    //       },
    //       borderDrawMode: BorderDrawMode.excludeBottom,
    //       // pointColorMapper: (ChartData data, _) =>
    //       //     isDayTime(data.dateTime) ? Colors.blue : Colors.grey,
    //     ),
    //   ],
    // );
  }

  bool isDayTime(ChartData dateTime) {
    final hour = dateTime.dateTime.hour;
    print("hour--$hour");
    return hour >= 6 && hour < 18;
  }
}

class ChartData {
  final DateTime dateTime;
  final double value;

  ChartData(this.dateTime, this.value);
}
