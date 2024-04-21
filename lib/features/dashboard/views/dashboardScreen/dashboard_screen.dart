import 'package:admin/routes/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

import '../../../../shared/constant/font_helper.dart';
import '../../../../shared/constant/global_variables.dart';
import '../../../../shared/widgets/buttons/my_button.dart';
import '../../../../shared/widgets/inputs/my_text_field.dart';
import '../../controller/dashboard_controller.dart';

class DashBoardScreen extends StatefulWidget {
  const DashBoardScreen({
    super.key,
  });

  @override
  State<DashBoardScreen> createState() => _DashBoardScreenState();
}

class _DashBoardScreenState extends State<DashBoardScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ConstrainedBox(
          constraints:const BoxConstraints(
            maxWidth: 300,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(
                height: 20,
              ),
              SvgPicture.asset(
                "assets/images/logo.svg",
                height: 80,
              ),
              const SizedBox(
                height: 20,
              ),
              Expanded(
                child: GridView(
                  physics: const NeverScrollableScrollPhysics(),
                  padding: const EdgeInsets.all(10),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 1,
                    crossAxisSpacing: Get.width * 0.01,
                    mainAxisSpacing: Get.width * 0.01,
                  ),
                  children: [
                    DashboardItem(
                      ontab: () async {
                        Get.dialog(const SenserCaliberationDialoge());
                      },
                      title: 'Sensor Caliberation',
                    ),
                    DashboardItem(
                      ontab: () async {
                        Get.dialog(const CleanInventoryDialog());
                      },
                      title: 'Clean Inventory',
                    ),
                    DashboardItem(
                      ontab: () async {
                        Get.toNamed(AppRoutes.conclusiveOrRawLiveData);
                      },
                      title: 'Live Data',
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class DashboardItem extends StatelessWidget {
  const DashboardItem({
    super.key,
    required this.title,
    this.icon,
    this.ontab,
    this.isError = false,
  });
  final String title;
  final Widget? icon;
  final Function()? ontab;
  final bool isError;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: ontab,
      child: Container(
        height: Get.height * .15,
        width: Get.width * .38,
        padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 11),
        decoration: BoxDecoration(
          color: const Color(0xFF156350).withOpacity(0.08),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: greenColor),
        ),
        child: SizedBox(
          width: Get.width,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Expanded(
              //   flex: 8,
              //   child: Center(child: icon),
              // ),
              Expanded(
                flex: 7,
                child: Center(
                  child: Text(
                    title,
                    style: GlobalFonts.ts16px500w()
                        .copyWith(color: Colors.black, fontSize: 13),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class SenserCaliberationDialoge extends StatefulWidget {
  const SenserCaliberationDialoge({
    super.key,
    this.id,
  });
  final String? id;

  @override
  State<SenserCaliberationDialoge> createState() =>
      _SenserCaliberationDialogeState();
}

class _SenserCaliberationDialogeState extends State<SenserCaliberationDialoge> {
  TextEditingController deviceID = TextEditingController();
  final SensorController controller = Get.put(SensorController());
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 400,
      child: Dialog(
        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: 300),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: ListView(
              shrinkWrap: true,
              padding: const EdgeInsets.all(16.0),
              children: [
                MyTextField(
                  controller: deviceID,
                  hintText: "PondId",
                  textStyle: GlobalFonts.ts20px500w(),
                  labelText: "Pond ID",

                  onChanged: (newValue) {
                    // deviceID.text = newValue;
                  },
                  //isReadOny: true,
                ),
                const SizedBox(
                  height: 15,
                ),
                Center(
                  child: MyButton(
                      height: 50,
                      textColor: Colors.white,
                      width: context.width * 0.5,
                      color: greenColor,
                      text: 'SUBMIT',
                      onPressed: () async {
                        Get.back();
                        Get.toNamed(AppRoutes.sensorCaliberation,
                            parameters: {"pondId": deviceID.text});
                      }),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// clean inventory popup
class CleanInventoryDialog extends StatefulWidget {
  const CleanInventoryDialog({
    super.key,
    this.id,
  });
  final String? id;

  @override
  State<CleanInventoryDialog> createState() => _CleanInventoryDialogState();
}

class _CleanInventoryDialogState extends State<CleanInventoryDialog> {
  TextEditingController deviceID = TextEditingController();
  final SensorController controller = Get.put(SensorController());
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 400,
      child: Dialog(
        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: 300),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: ListView(
              shrinkWrap: true,
              padding: const EdgeInsets.all(16.0),
              children: [
                MyTextField(
                  controller: deviceID,
                  hintText: "Enter Device ID",
                  textStyle: GlobalFonts.ts20px500w(),
                  labelText: "Device ID",
                ),
                const SizedBox(
                  height: 15,
                ),
                Center(
                  child: MyButton(
                      height: 50,
                      textColor: Colors.white,
                      width: context.width * 0.5,
                      color: greenColor,
                      text: 'SUBMIT',
                      onPressed: () async {
                        Get.back();
                        await controller.cleanInventory(deviceID.text);
                      }),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// class LiveDataDialog extends StatefulWidget {
//   const LiveDataDialog({
//     super.key,
//     this.id,
//   });
//   final String? id;

//   @override
//   State<LiveDataDialog> createState() => _LiveDataDialogState();
// }

// class _LiveDataDialogState extends State<LiveDataDialog> {
//   TextEditingController typeIdController = TextEditingController();
//   TextEditingController dlNoController = TextEditingController();
//   TextEditingController networkNoController = TextEditingController();
//   TextEditingController collectionTypeController = TextEditingController();

//   final SensorController controller = Get.put(SensorController());
//   @override
//   Widget build(BuildContext context) {
//     return SizedBox(
//       width: 400,
//       child: Dialog(
//         child: ConstrainedBox(
//           constraints: const BoxConstraints(maxWidth: 300),
//           child: Padding(
//             padding: const EdgeInsets.all(8.0),
//             child: ListView(
//               shrinkWrap: true,
//               padding: const EdgeInsets.all(16.0),
//               children: [
//                 MyTextField(
//                   controller: typeIdController,
//                   hintText: "Type ID",
//                   textStyle: GlobalFonts.ts20px500w(),
//                   labelText: "TypeID",
//                 ),
//                 const SizedBox(
//                   height: 10,
//                 ),
//                 MyTextField(
//                   controller: dlNoController,
//                   hintText: "dlno",
//                   textStyle: GlobalFonts.ts20px500w(),
//                   labelText: "dlno",
//                 ),
//                 const SizedBox(
//                   height: 10,
//                 ),
//                 MyTextField(
//                   controller: networkNoController,
//                   hintText: "Network No",
//                   textStyle: GlobalFonts.ts20px500w(),
//                   labelText: "Network Number",
//                 ),
//                 const SizedBox(
//                   height: 10,
//                 ),
//                 DropdownFormField(
//                   controller: collectionTypeController,
//                   dropDownItems: const ['ConclusiveData', 'RawData'],
//                   value: 'ConclusiveData',
//                   hintText: '',
//                   labelText: "Collection Type",
//                   labelStyle: GlobalFonts.ts16px700w(),
//                   textStyle: GlobalFonts.ts20px500w(),
//                   isValidate: true,
//                   validator: (value) {
//                     if (value.isEmpty) {
//                       return "required";
//                     }
//                     return "";
//                   },
//                 ),
//                 const SizedBox(
//                   height: 10,
//                 ),
//                 Center(
//                   child: MyButton(
//                       height: 50,
//                       textColor: Colors.white,
//                       width: context.width * 0.5,
//                       color: greenColor,
//                       text: 'SUBMIT',
//                       onPressed: () async {
//                         Get.back();
//                         // Get.toNamed(AppRoutes.sensorCaliberation,
//                         //     parameters: {"pondId": deviceID.text});
//                       }),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
