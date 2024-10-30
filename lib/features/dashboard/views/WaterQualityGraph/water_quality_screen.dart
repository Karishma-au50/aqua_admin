import 'package:admin/features/dashboard/views/WaterQualityGraph/line_chart.dart';
import 'package:admin/features/dashboard/views/WaterQualityGraph/value_parameter.dart';
import 'package:admin/shared/constant/global_variables.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import 'difference_chart.dart';

class WaterQualityScreen extends StatefulWidget {
  const WaterQualityScreen({super.key});

  @override
  State<WaterQualityScreen> createState() => _WaterQualityScreenState();
}

class _WaterQualityScreenState extends State<WaterQualityScreen> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: SingleChildScrollView(
        child: DefaultTabController(
          length: 2,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 6),
            child: Column(
              children: [
                ValueParameter(),
                SizedBox(height: 20),
                Column(
                  children: [
                    TabBar(
                      labelColor: greenColor,
                      unselectedLabelColor: Colors.grey,
                      indicatorColor: greenColor,
                      tabs: [
                        Tab(text: 'Water Quality Chart'),
                        Tab(text: 'Day Night Difference Chart'),
                      ],
                    ),
                    SizedBox(
                      height: 800,
                      child: TabBarView(
                        children: [
                          LineChart(),
                          DifferenceChart(),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
