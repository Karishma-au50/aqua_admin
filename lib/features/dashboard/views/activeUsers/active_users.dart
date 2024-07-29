import 'package:admin/model/activeUsers.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../../shared/constant/font_helper.dart';

import '../../controller/sensor_controller.dart';

class ActiveUsersScreen extends StatefulWidget {
  const ActiveUsersScreen({super.key});

  @override
  State<ActiveUsersScreen> createState() => _ActiveUsersScreenState();
}

class _ActiveUsersScreenState extends State<ActiveUsersScreen> {
  late final SensorController controller;
  RxList<ActiveUsersModel> activeUsers = <ActiveUsersModel>[].obs;
  final RxBool isLoad = true.obs;
  @override
  void initState() {
    super.initState();
    controller = Get.isRegistered<SensorController>()
        ? Get.find<SensorController>()
        : Get.put<SensorController>(SensorController());
    controller.getActiveUsers().then((value) {
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
                "ACTIVE USERS",
                style: GlobalFonts.ts18px600w,
              ),
              const SizedBox(height: 20),

              isLoad.isTrue
                  ? const Center(child: CircularProgressIndicator())
                  : activeUsers.isEmpty
                      ? Text(
                          "No User Found",
                          style: GlobalFonts.ts16px700w(),
                        )
                      : Expanded(
                          child: SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: SingleChildScrollView(
                              scrollDirection: Axis.vertical,
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10.0),
                                child: DataTable(
                                  headingRowColor:
                                      MaterialStateColor.resolveWith(
                                    (states) {
                                      return const Color.fromARGB(
                                          255, 237, 244, 214);
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
                                            "Name",
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
                                            "Mobile No",
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
                                            "Role",
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
                                            "Created On",
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
                                            "Last Login",
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
                                        width: 150,
                                        child: Center(
                                          child: Text(
                                            "Alternate Mobile No",
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
                                      return DataRow(
                                        cells: <DataCell>[
                                          DataCell(
                                            Center(
                                              child: Text(
                                                  data.name != null
                                                      ? data.name.toString()
                                                      : '-',
                                                  style:
                                                      GlobalFonts.ts14px500w),
                                            ),
                                          ),
                                          DataCell(
                                            Center(
                                              child: Text(
                                                  data.mobile != null
                                                      ? data.mobile.toString()
                                                      : "-",
                                                  style:
                                                      GlobalFonts.ts14px500w),
                                            ),
                                          ),
                                          DataCell(
                                            Center(
                                              child: Text(
                                                  data.roleName != null
                                                      ? data.roleName.toString()
                                                      : '-',
                                                  style:
                                                      GlobalFonts.ts14px500w),
                                            ),
                                          ),
                                          DataCell(
                                            Center(
                                              child: Text(
                                                  data.createdOn != null
                                                      ? DateFormat(
                                                              'dd MMM yy\nHH:mm:ss')
                                                          .format(DateTime
                                                              .fromMillisecondsSinceEpoch(
                                                                  data
                                                                      .createdOn!))
                                                      : '-',
                                                  style:
                                                      GlobalFonts.ts14px500w),
                                            ),
                                          ),
                                          DataCell(
                                            Center(
                                              child: Text(
                                                  data.lastLogin != null
                                                      ? DateFormat(
                                                              'dd MMM yy\nHH:mm:ss')
                                                          .format(DateTime
                                                              .fromMillisecondsSinceEpoch(
                                                                  data
                                                                      .lastLogin!))
                                                      : '-',
                                                  style:
                                                      GlobalFonts.ts14px500w),
                                            ),
                                          ),
                                          DataCell(
                                            Center(
                                              child: Text(
                                                data.alternateMobile != null &&
                                                        data.alternateMobile!
                                                            .isNotEmpty
                                                    ? data.alternateMobile!
                                                        .join(', ')
                                                    : '-',
                                                style: GlobalFonts.ts14px500w,
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
                          ),
                        ),

              // FutureBuilder(
              //     future: controller.getActiveUsers(),
              //     builder: (context, s) {
              //       if (activeUsers.isEmpty) {
              //         return Center(
              //           child: Text(
              //             "No Data Found",
              //             style: GlobalFonts.ts16px700w(),
              //           ),
              //         );
              //       }

              //       return Expanded(
              //         child: DataTable(
              //           headingRowColor: MaterialStateColor.resolveWith(
              //             (states) {
              //               return const Color.fromARGB(255, 237, 244, 214);
              //             },
              //           ),
              //           horizontalMargin: 0,
              //           columnSpacing: 1.2,
              //           headingRowHeight: context.height * 0.09,
              //           border: TableBorder.all(),
              //           columns: [
              //             DataColumn(
              //               // size: ColumnSize.M,
              //               label: Center(
              //                 child: Text(
              //                   "Date\nTime",
              //                   style: GlobalFonts.ts14px500w,
              //                   textAlign: TextAlign.center,
              //                   overflow: TextOverflow.ellipsis,
              //                 ),
              //               ),
              //               tooltip: 'DateTime',
              //             ),
              //             DataColumn(
              //               // size: ColumnSize.M,
              //               label: Center(
              //                 child: Text(
              //                   "abc",
              //                   style: GlobalFonts.ts10px500w(),
              //                   overflow: TextOverflow.ellipsis,
              //                 ),
              //               ),
              //               tooltip: 'PH',
              //             ),
              //             DataColumn(
              //               label: Center(
              //                 child: Text(
              //                   "abc",
              //                   style: GlobalFonts.ts10px500w(),
              //                   overflow: TextOverflow.ellipsis,
              //                 ),
              //               ),
              //               tooltip: 'Do',
              //             ),
              //             DataColumn(
              //               // size: ColumnSize.M,
              //               label: Center(
              //                 child: Text(
              //                   "abc",
              //                   style: GlobalFonts.ts10px500w(),
              //                   overflow: TextOverflow.ellipsis,
              //                 ),
              //               ),
              //               tooltip: 'Temp',
              //             ),
              //             DataColumn(
              //               // size: ColumnSize.M,
              //               label: Center(
              //                 child: Text(
              //                   "abc",
              //                   style: GlobalFonts.ts10px500w(),
              //                   overflow: TextOverflow.ellipsis,
              //                 ),
              //               ),
              //               tooltip: 'sal',
              //             ),
              //           ],
              //           rows: List.generate(
              //             activeUsers.length,
              //             (index) {
              //               var d = activeUsers[index];

              //               return DataRow(
              //                 cells: <DataCell>[
              //                   DataCell(
              //                     Center(
              //                       child: Text(
              //                         "dfghj",
              //                         // DateFormat('dd MMM\nHH:mm').format(
              //                         //     DateTime.fromMillisecondsSinceEpoch(
              //                         //         d.createdOn!)),
              //                         style: GlobalFonts.ts10px500w(),
              //                         textAlign: TextAlign.center,
              //                       ),
              //                     ),
              //                   ),
              //                   DataCell(
              //                     Center(
              //                       child: Text(
              //                         '-',
              //                         style:
              //                             GlobalFonts.ts10px500w(color: Colors.red),
              //                       ),
              //                     ),
              //                   ),
              //                   DataCell(
              //                     Center(
              //                       child: Text(
              //                         '-',
              //                         style:
              //                             GlobalFonts.ts10px500w(color: Colors.red),
              //                       ),
              //                     ),
              //                   ),
              //                   DataCell(
              //                     Center(
              //                       child: Text(
              //                         '-',
              //                         style:
              //                             GlobalFonts.ts10px500w(color: Colors.red),
              //                       ),
              //                     ),
              //                   ),
              //                   DataCell(
              //                     Center(
              //                       child: Text(
              //                         '-',
              //                         style:
              //                             GlobalFonts.ts10px500w(color: Colors.red),
              //                       ),
              //                     ),
              //                   ),
              //                 ],
              //               );
              //             },
              //           ).toList(),
              //         ),
              //       );
              //     }),
            ],
          ),
        );
      }),
    );
  }
}
