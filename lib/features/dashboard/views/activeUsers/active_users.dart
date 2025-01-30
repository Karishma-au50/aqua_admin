import 'package:admin/model/activeUsers.dart';
import 'package:data_table_2/data_table_2.dart';
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
                          child: Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 10.0),
                            child: DataTable2(
                              headingRowColor: MaterialStateColor.resolveWith(
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
                                DataColumn2(
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
                                DataColumn2(
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
                                DataColumn2(
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
                                DataColumn2(
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
                                DataColumn2(
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
                                DataColumn2(
                                  label: SizedBox(
                                    width: 150,
                                    child: Center(
                                      child: Text(
                                        "Delete User",
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
                                          child: Text(
                                              data.name != null
                                                  ? data.name.toString()
                                                  : '-',
                                              style: GlobalFonts.ts14px500w),
                                        ),
                                      ),
                                      DataCell(
                                        Center(
                                          child: Text(
                                              data.mobile != null
                                                  ? data.mobile.toString()
                                                  : "-",
                                              style: GlobalFonts.ts14px500w),
                                        ),
                                      ),
                                      DataCell(
                                        Center(
                                          child: Text(
                                              data.roleName != null
                                                  ? data.roleName.toString()
                                                  : '-',
                                              style: GlobalFonts.ts14px500w),
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
                                                              data.createdOn!))
                                                  : '-',
                                              style: GlobalFonts.ts14px500w),
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
                                                              data.lastLogin!))
                                                  : '-',
                                              style: GlobalFonts.ts14px500w),
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
                                      DataCell(
                                        InkWell(
                                          onTap: () async {
                                            showDialog(
                                                context: context,
                                                builder: (context) {
                                                  return SizedBox(
                                                    width: 600,
                                                    child: Dialog(
                                                      shape:
                                                          RoundedRectangleBorder(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(12.0),
                                                      ),
                                                      backgroundColor:
                                                          Colors.white,
                                                      child: ConstrainedBox(
                                                        constraints:
                                                            const BoxConstraints(
                                                                maxWidth: 300),
                                                        child: Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(20.0),
                                                          child: Column(
                                                            mainAxisSize:
                                                                MainAxisSize
                                                                    .min,
                                                            children: [
                                                              // Icon and Title
                                                              const Icon(
                                                                Icons
                                                                    .warning_rounded,
                                                                color: Colors
                                                                    .redAccent,
                                                                size: 50,
                                                              ),
                                                              const SizedBox(
                                                                  height: 16),
                                                              const Text(
                                                                "Are You Sure?",
                                                                style:
                                                                    TextStyle(
                                                                  fontSize: 18,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                  color: Colors
                                                                      .black87,
                                                                ),
                                                              ),
                                                              Text(
                                                                data.name !=
                                                                        null
                                                                    ? "${data.name} ${data.mobile}"
                                                                    : "",
                                                                textAlign:
                                                                    TextAlign
                                                                        .center,
                                                              ),

                                                              const SizedBox(
                                                                  height: 4),
                                                              Text(
                                                                "This action will permanently delete the user and cannot be undone.",
                                                                textAlign:
                                                                    TextAlign
                                                                        .center,
                                                                style:
                                                                    TextStyle(
                                                                  fontSize: 14,
                                                                  color: Colors
                                                                          .grey[
                                                                      700],
                                                                ),
                                                              ),
                                                              const SizedBox(
                                                                  height: 14),

                                                              // Action Buttons
                                                              Row(
                                                                children: [
                                                                  Expanded(
                                                                    child:
                                                                        ElevatedButton(
                                                                      style: ElevatedButton
                                                                          .styleFrom(
                                                                        backgroundColor:
                                                                            Colors.redAccent,
                                                                        padding: const EdgeInsets
                                                                            .symmetric(
                                                                            vertical:
                                                                                12),
                                                                        shape:
                                                                            RoundedRectangleBorder(
                                                                          borderRadius:
                                                                              BorderRadius.circular(8.0),
                                                                        ),
                                                                      ),
                                                                      onPressed:
                                                                          () async {
                                                                        Navigator.pop(
                                                                            context);
                                                                        await controller
                                                                            .deleteUserById(data.id ??
                                                                                "")
                                                                            .then((value) {
                                                                          if (value) {
                                                                            controller.getActiveUsers().then((value) {
                                                                              if (value != null) {
                                                                                activeUsers.assignAll(value);
                                                                              }
                                                                              isLoad.value = false;
                                                                            });
                                                                          }
                                                                        });
                                                                      },
                                                                      child:
                                                                          const Text(
                                                                        "Delete",
                                                                        style:
                                                                            TextStyle(
                                                                          fontSize:
                                                                              16,
                                                                          color:
                                                                              Colors.white,
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  ),
                                                                  const SizedBox(
                                                                      width:
                                                                          12),
                                                                  Expanded(
                                                                    child:
                                                                        OutlinedButton(
                                                                      style: OutlinedButton
                                                                          .styleFrom(
                                                                        side: BorderSide(
                                                                            color:
                                                                                Colors.grey[400]!),
                                                                        padding: const EdgeInsets
                                                                            .symmetric(
                                                                            vertical:
                                                                                12),
                                                                        shape:
                                                                            RoundedRectangleBorder(
                                                                          borderRadius:
                                                                              BorderRadius.circular(8.0),
                                                                        ),
                                                                      ),
                                                                      onPressed:
                                                                          () {
                                                                        Navigator.pop(
                                                                            context);
                                                                      },
                                                                      child:
                                                                          const Text(
                                                                        "Cancel",
                                                                        style:
                                                                            TextStyle(
                                                                          fontSize:
                                                                              16,
                                                                          color:
                                                                              Colors.black87,
                                                                        ),
                                                                      ),
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
                                                // const DeleteUserById()
                                                );
                                          },
                                          child: const Center(
                                              child: Icon(
                                            Icons.delete,
                                            color: Colors.red,
                                          )),
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
