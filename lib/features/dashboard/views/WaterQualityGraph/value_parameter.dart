import 'package:admin/model/farmer_pond_info_model.dart';
import 'package:admin/shared/constant/app_colors.dart';
import 'package:admin/shared/constant/font_helper.dart';
import 'package:admin/shared/widgets/buttons/my_button.dart';
import 'package:admin/shared/widgets/inputs/my_text_field.dart';

import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:get/get.dart';
import 'package:get/get_core/get_core.dart';
import 'package:get/get_utils/get_utils.dart';
import 'package:intl/intl.dart';

import '../../../../shared/constant/global_variables.dart';
import '../../controller/dashboard_controller.dart';

class ValueParameter extends StatefulWidget {
  const ValueParameter({super.key});

  @override
  State<ValueParameter> createState() => _ValueParameterState();
}

class _ValueParameterState extends State<ValueParameter> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _pondIdController = TextEditingController();
  final TextEditingController _startDateController = TextEditingController();
  final TextEditingController _endDateController = TextEditingController();
  final TextEditingController _frequencyController = TextEditingController();
  Rx<FarmerPondInfoModel> farmerPondInfo = FarmerPondInfoModel().obs;

  final SensorController controller = Get.isRegistered<SensorController>()
      ? Get.find()
      : Get.put(SensorController());
  String frequencyValue = '5';
  String parameterValue = 'PH';
  List<String> options = [
    "DO",
    "PH",
    "NH3",
    "NH4",
    "TAN",
    "NO2",
    "NO3",
    "PH & DO",
    "PH & NH3",
    "NH4 & NH3"
  ];
  DateTime? _startDate;
  DateTime? _endDate;

  Future<void> _selectStartDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _startDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2030),
    );
    if (picked != null && picked != _startDate) {
      setState(() {
        _startDate = picked;
        if (_endDate != null && _endDate!.isBefore(_startDate!)) {
          _endDate = _startDate;
        }
      });
    }
  }

  Future<void> _selectEndDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _endDate ?? DateTime.now(),
      firstDate: _startDate ?? DateTime.now(),
      lastDate: DateTime(2030),
    );
    if (picked != null && picked != _endDate) {
      setState(() {
        _endDate = picked;
      });
    }
  }

  List<String> frequency = [
    '5 minutes',
    '10 minutes',
    '15 minutes',
    '30 minutes',
    '45 minutes',
    '60 minutes'
  ];
  // List<bool> _isSelected = [false, false, false, false, false, false];
  // List<bool> _isSelectedFrequency = [false, false, false, false, false, false];
  final TextEditingController _pondController = TextEditingController();
  final TextEditingController _farmController = TextEditingController();
  final List<String> _selectedFarms = [];
  final List<String> _selectedPonds = [];
  //   final TextEditingController _farmController = TextEditingController();
  // final List<String> _selectedFarms = [];
  // Replace farmerPondInfo with your actual data source
  // final farmerPondInfo = ValueNotifier<FarmData>(FarmData());

  @override
  void initState() {
    // TODO: implement initState
    controller.getfarmerpondinfo().then((value) {
      if (value != null) {
        farmerPondInfo(value);
      }
    });

    super.initState();
  }

  @override
  void dispose() {
    _pondIdController.dispose();
    _startDateController.dispose();
    _endDateController.dispose();
    _frequencyController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 9),
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            Container(
              height: MediaQuery.of(context).size.height * 0.15,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.green),
                borderRadius: BorderRadius.circular(0),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    width: 80,
                    decoration: const BoxDecoration(
                      color: greenColor,
                    ),
                    child: const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Center(
                        child: Text(
                          "WHERE?",
                          style: TextStyle(color: Colors.white, fontSize: 16),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                          border: Border.all(color: Colors.black)),
                      child: TypeAheadField<String>(
                        builder: (context, controller, focusNode) {
                          return MyTextField(
                            controller: controller,
                            hintText: _selectedFarms.join(', '),
                            focusNode: focusNode,
                            isReadOny: true,
                          );
                        },
                        onSelected: (value) {},
                        suggestionsCallback: (search) {
                          return farmerPondInfo.value.farms!
                              .where((ele) =>
                                  ele.name.contains(search) ||
                                  ele.farmId.toString().contains(search))
                              .map((e) => "${e.name} (${e.farmId})")
                              .toList();
                        },
                        itemBuilder: (context, suggestion) {
                          return CheckboxListTile(
                            title: Text(suggestion),
                            value: _selectedFarms.contains(suggestion),
                            onChanged: (bool? selected) {
                              setState(() {
                                if (selected == true &&
                                    !_selectedFarms.contains(suggestion)) {
                                  _selectedFarms.add(suggestion);
                                } else if (selected == false &&
                                    _selectedFarms.contains(suggestion)) {
                                  _selectedFarms.remove(suggestion);
                                }
                                _farmController.clear();
                              });
                            },
                          );
                        },
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 20,
                  ),
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                          border: Border.all(color: Colors.black)),
                      child: TypeAheadField<String>(
                        onSelected: (value) {},
                        suggestionsCallback: (search) {
                          return farmerPondInfo.value.farms!
                              .where((ele) =>
                                  ele.name
                                      .toLowerCase()
                                      .contains(search.toLowerCase()) ||
                                  ele.farmId
                                      .toString()
                                      .toLowerCase()
                                      .contains(search.toLowerCase()))
                              .map((e) => "${e.name} (${e.farmId})")
                              .toList();
                        },
                        itemBuilder: (context, suggestion) {
                          return CheckboxListTile(
                            title: Text(suggestion),
                            value: _selectedFarms.contains(suggestion),
                            onChanged: (bool? selected) {
                              setState(() {
                                if (selected == true &&
                                    !_selectedFarms.contains(suggestion)) {
                                  _selectedFarms.add(suggestion);
                                } else if (selected == false &&
                                    _selectedFarms.contains(suggestion)) {
                                  _selectedFarms.remove(suggestion);
                                }
                                _farmController.clear();
                              });
                            },
                          );
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Container(
              height: context.height * 0.2,
              decoration: BoxDecoration(
                  border: Border.all(color: greenColor),
                  borderRadius: BorderRadius.circular(0)),
              child: Row(
                children: [
                  Container(
                    width: 80,
                    decoration: const BoxDecoration(
                      color: greenColor,
                      // borderRadius: BorderRadius.only(
                      //   topLeft: Radius.circular(10.0),
                      //   topRight: Radius.circular(10.0),
                      // ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Center(
                        child: Text(
                          "WHAT?",
                          style:
                              GlobalFonts.ts16px400w(color: AppColors.kcWhite),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Wrap(
                      children: List.generate(
                        options.length,
                        (index) => SizedBox(
                          width: 120,
                          child: Row(
                            children: [
                              Radio(
                                activeColor: greenColor,
                                value: options[index],
                                groupValue: parameterValue,
                                onChanged: (String? value) {
                                  setState(() {
                                    parameterValue = value!;
                                  });
                                },
                              ),
                              Text(
                                options[index],
                                style: GlobalFonts.ts14px500w,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Container(
              height: context.height * 0.15,
              decoration: BoxDecoration(
                  border: Border.all(color: greenColor),
                  borderRadius: BorderRadius.circular(0)),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    width: 80,
                    decoration: const BoxDecoration(
                      color: greenColor,
                      // borderRadius: BorderRadius.only(
                      //   topLeft: Radius.circular(10.0),
                      //   topRight: Radius.circular(10.0),
                      // ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Center(
                        child: Text(
                          "WHEN?",
                          style:
                              GlobalFonts.ts16px400w(color: AppColors.kcWhite),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: MyTextField(
                      isReadOny: true,
                      suffixIcon: const Icon(Icons.calendar_month_outlined),
                      labelText: '',
                      hintText: _startDate == null
                          ? 'FROM'
                          : DateFormat.yMd().format(_startDate!),
                      onTap: () => _selectStartDate(context),
                    ),
                  ),
                  Expanded(
                    child: MyTextField(
                      isReadOny: true,
                      suffixIcon: const Icon(Icons.calendar_month_outlined),
                      labelText: '',
                      hintText: _endDate == null
                          ? 'TO'
                          : DateFormat.yMd().format(_endDate!),
                      onTap: () => _selectEndDate(context),
                    ),
                  )
                ],
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            MyButton(
                text: "Submit",
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {}
                })
          ],
        ),
      ),
    );
  }
}
