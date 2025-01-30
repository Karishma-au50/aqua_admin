import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../../model/cloud_management_model.dart';
import '../../../../shared/constant/font_helper.dart';
import '../../controller/sensor_controller.dart';

class CloudManagementScreen extends StatefulWidget {
  const CloudManagementScreen({super.key});

  @override
  State<CloudManagementScreen> createState() => _CloudManagementScreenState();
}

class _CloudManagementScreenState extends State<CloudManagementScreen> {
  late final SensorController controller;
  RxList<CloudManagementModel> activeUsers = <CloudManagementModel>[].obs;
  final RxBool isLoad = true.obs;
  @override
  void initState() {
    super.initState();
    controller = Get.isRegistered<SensorController>()
        ? Get.find<SensorController>()
        : Get.put<SensorController>(SensorController());
    controller.getCloudManagementList().then((value) {
      if (value != null) {
        activeUsers.addAll(value);
      }
      isLoad.value = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(() {
        return SizedBox(
          width: MediaQuery.sizeOf(context).width,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 40),
              Text(
                "Cloud Management",
                style: GlobalFonts.ts18px600w,
              ),
              const SizedBox(height: 20),
              isLoad.isTrue
                  ? const Center(child: CircularProgressIndicator())
                  : activeUsers.isEmpty
                      ? Text(
                          "No Data Found",
                          style: GlobalFonts.ts16px700w(),
                        )
                      : Expanded(
                          child: Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 10.0),
                            child: DataTable2(
                              headingRowColor: WidgetStateColor.resolveWith(
                                (states) {
                                  return const Color.fromARGB(
                                      255, 237, 244, 214);
                                },
                              ),
                              horizontalMargin: 0,
                              columnSpacing: 1.2,
                              border: TableBorder.all(),
                              columns: [
                                DataColumn2(
                                  headingRowAlignment: MainAxisAlignment.center,
                                  label: SizedBox(
                                    width: 100,
                                    child: Center(
                                      child: Text(
                                        "dlNo",
                                        style: GlobalFonts.ts14px600w,
                                        textAlign: TextAlign.center,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ),
                                  fixedWidth: 80,
                                ),
                                DataColumn2(
                                  headingRowAlignment: MainAxisAlignment.center,
                                  label: SizedBox(
                                    width: 100,
                                    child: Center(
                                      child: Text(
                                        "dlName",
                                        style: GlobalFonts.ts14px600w,
                                        textAlign: TextAlign.center,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ),
                                  // fixedWidth: 80,
                                ),
                                DataColumn2(
                                  headingRowAlignment: MainAxisAlignment.center,
                                  label: SizedBox(
                                    width: 100,
                                    child: Center(
                                      child: Text(
                                        "updatedAt",
                                        style: GlobalFonts.ts14px600w,
                                        textAlign: TextAlign.center,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ),
                                  // fixedWidth: 80,
                                ),
                                DataColumn2(
                                  headingRowAlignment: MainAxisAlignment.center,
                                  label: SizedBox(
                                    width: 100,
                                    child: Center(
                                      child: Text(
                                        "simNumber",
                                        style: GlobalFonts.ts14px600w,
                                        textAlign: TextAlign.center,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ),
                                  // fixedWidth: 80,
                                ),
                                DataColumn2(
                                  headingRowAlignment: MainAxisAlignment.center,
                                  label: SizedBox(
                                    width: 150,
                                    child: Center(
                                      child: Text(
                                        "Refresh",
                                        style: GlobalFonts.ts14px600w,
                                        textAlign: TextAlign.center,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ),
                                  // fixedWidth: 80,
                                ),
                              ],
                              rows: activeUsers.map(
                                (data) {
                                  return DataRow2(
                                    cells: <DataCell>[
                                      DataCell(
                                        Center(
                                          child: Text(data.dlNo.toString(),
                                              style: GlobalFonts.ts14px500w),
                                        ),
                                      ),
                                      DataCell(
                                        Center(
                                          child: Text(data.dlName.toString(),
                                              style: GlobalFonts.ts14px500w),
                                        ),
                                      ),
                                      DataCell(
                                        Center(
                                          child: Text(
                                              DateFormat('dd MMM yy\nHH:mm:ss')
                                                  .format(DateTime
                                                      .fromMillisecondsSinceEpoch(
                                                          data.updatedAt)),
                                              style: GlobalFonts.ts14px500w),
                                        ),
                                      ),
                                      DataCell(
                                        Center(
                                          child: Text(data.simNumber.toString(),
                                              style: GlobalFonts.ts14px500w),
                                        ),
                                      ),
                                      DataCell(
                                        InkWell(
                                          onTap: () async {
                                            await controller
                                                .refreshCloud(data.id);
                                          },
                                          child: const Center(
                                            child: Icon(
                                              Icons.refresh_rounded,
                                              color: Colors.blue,
                                              size: 30,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  );
                                },
                              ).toList(),
                            ),
                          ),
                        ),
            ],
          ),
        );
      }),
    );
  }
}
