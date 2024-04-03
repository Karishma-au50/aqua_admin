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
      appBar: AppBar(),
      body: Column(
        children: [
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
                crossAxisSpacing: Get.width * 0.04,
                mainAxisSpacing: Get.width * 0.02,
              ),
              children: [
                DashboardItem(
                  ontab: () async {
                    Get.dialog(const SenserCaliberationDialoge());
                  },
                  title: 'Sensor Caliberation',
                  icon: SvgPicture.asset(
                    "assets/images/farms.svg",
                    color: greenColor,
                    height: context.height * .1,
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class DashboardItem extends StatelessWidget {
  const DashboardItem({
    super.key,
    required this.title,
    required this.icon,
    this.ontab,
    this.isError = false,
  });
  final String title;
  final Widget icon;
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
              Expanded(
                flex: 8,
                child: Center(child: icon),
              ),
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
      // height: 350,
      child: Dialog(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: ListView(
            shrinkWrap: true,
            padding: const EdgeInsets.all(16.0),
            children: [
              MyTextField(
                controller: deviceID,
                hintText: "",
                textStyle: GlobalFonts.ts20px500w(),
                labelText: "Device ID",

                onChanged: (newValue) {
                  deviceID.text = newValue;
                },
                //isReadOny: true,
              ),
              SizedBox(
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
                      Get.toNamed(AppRoutes.sensorCaliberation,
                          parameters: {"pondId": deviceID.text});
                    }),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
