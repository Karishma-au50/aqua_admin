import 'package:admin/routes/app_routes.dart';
import 'package:admin/shared/utils/nav_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

import '../../../../shared/constant/font_helper.dart';
import '../../../../shared/constant/global_variables.dart';
import '../../../../shared/widgets/buttons/my_button.dart';
import '../../../../shared/widgets/inputs/my_text_field.dart';
import '../../controller/dashboard_controller.dart';

class DashBoardScreen extends StatelessWidget {
  const DashBoardScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
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
                padding: const EdgeInsets.all(10),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount:
                      MediaQuery.of(context).size.width > 800 ? 5 : 2,
                  childAspectRatio: 2,
                  crossAxisSpacing: MediaQuery.of(context).size.width * 0.01,
                  mainAxisSpacing: MediaQuery.of(context).size.width * 0.01,
                ),
                children: [
                  DashboardItem(
                    ontab: () async {
                      showDialog(
                          context: context,
                          builder: (context) =>
                              const SenserCaliberationDialoge());
                    },
                    title: 'Sensor Caliberation',
                  ),
                  DashboardItem(
                    ontab: () async {
                      showDialog(
                          context: context,
                          builder: (context) => const CleanInventoryDialog());
                    },
                    title: 'Clean Inventory',
                  ),
                  DashboardItem(
                    ontab: () async {
                      NavHelper.pushToNamed(AppRoutes.conclusiveOrRawLiveData);
                    },
                    title: 'Live Data',
                  )
                ],
              ),
            ),
          ],
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
      child: Card(
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
                  style: GlobalFonts.ts16px500w().copyWith(fontSize: 13),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ],
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
