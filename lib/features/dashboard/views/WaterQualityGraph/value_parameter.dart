import 'package:admin/features/dashboard/controller/water_quality_controller.dart';
import 'package:admin/shared/widgets/toast/my_toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../../../model/farm_model.dart';
import '../../../../model/farmer_pond_info_model.dart';
import '../../../../model/pond_model.dart';
import '../../../../shared/constant/app_colors.dart';
import '../../../../shared/constant/font_helper.dart';
import '../../../../shared/constant/global_variables.dart';
import '../../../../shared/widgets/buttons/my_button.dart';
import '../../../../shared/widgets/inputs/my_text_field.dart';

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

  List<FarmModel> selectedFarms = [];
  List<PondModel> selectedPonds = [];

  final WaterQualityController controller =
      Get.isRegistered<WaterQualityController>()
          ? Get.find()
          : Get.put(WaterQualityController());
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
  // DateTime? _startDate;
  // DateTime? _endDate;

  // Future<void> _selectStartDate(BuildContext context) async {
  //   final DateTime? picked = await showDatePicker(
  //     context: context,
  //     initialDate: _startDate ?? DateTime.now(),
  //     firstDate: DateTime(2000),
  //     lastDate: DateTime(2030),
  //   );
  //   if (picked != null && picked != _startDate) {
  //     setState(() {
  //       _startDate = picked;
  //       if (_endDate != null && _endDate!.isBefore(_startDate!)) {
  //         _endDate = _startDate;
  //       }
  //     });
  //   }
  // }

  // Future<void> _selectEndDate(BuildContext context) async {
  //   final DateTime? picked = await showDatePicker(
  //     context: context,
  //     initialDate: _endDate ?? DateTime.now(),
  //     firstDate: _startDate ?? DateTime.now(),
  //     lastDate: DateTime(2030),
  //   );
  //   if (picked != null && picked != _endDate) {
  //     setState(() {
  //       _endDate = picked;
  //     });
  //   }
  // }

  List<String> frequency = [
    '5 minutes',
    '10 minutes',
    '15 minutes',
    '30 minutes',
    '45 minutes',
    '60 minutes'
  ];
  final TextEditingController _pondController = TextEditingController();
  final TextEditingController _farmController = TextEditingController();
  // final List<String> _selectedFarms = [];
  // final List<String> _selectedPonds = [];

  DateTimeRange? selectedDateRange;
  Future<void> _selectDateRange(BuildContext context) async {
    final DateTimeRange? picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
      builder: (BuildContext context, Widget? child) {
        return Center(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              decoration:
                  BoxDecoration(borderRadius: BorderRadius.circular(10)),
              height: MediaQuery.of(context).size.height * 0.6,
              child: child,
            ),
          ),
        );
      },
    );

    if (picked != null && picked != selectedDateRange) {
      setState(() {
        selectedDateRange = picked;
      });
    }
  }

  @override
  void initState() {
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
              height: MediaQuery.of(context).size.height * 0.12,
              decoration: BoxDecoration(
                border: Border.all(color: greenColor),
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
                    child: TypeAheadField<FarmModel>(
                      controller: _farmController,
                      builder: (context, controller, focusNode) {
                        return MyTextField(
                          controller: controller,
                          hintText: selectedFarms.isEmpty
                              ? "Select Farm"
                              : selectedFarms
                                  .map((e) => "${e.name} (${e.farmId})")
                                  .join(', '),
                          focusNode: focusNode,
                          labelText: "FARMS",
                        );
                      },
                      onSelected: (value) {
                        print(value);
                      },
                      suggestionsCallback: (search) {
                        return farmerPondInfo.value.farms!
                            .where((ele) =>
                                ele.name.contains(search) ||
                                ele.farmId.toString().contains(search))
                            // .map((e) => "${e.name} (${e.farmId})")
                            .toList();
                      },
                      itemBuilder: (context, suggestion) {
                        return Container(
                          decoration: const BoxDecoration(color: Colors.white),
                          child: CheckboxListTile(
                            title: Text(
                                "${suggestion.name} (${suggestion.farmId})"),
                            value: selectedFarms.contains(suggestion),
                            onChanged: (bool? selected) {
                              setState(() {
                                if (selected == true &&
                                    !selectedFarms.contains(suggestion)) {
                                  selectedFarms.add(suggestion);
                                } else if (selected == false &&
                                    selectedFarms.contains(suggestion)) {
                                  selectedFarms.remove(suggestion);
                                }
                                _farmController.clear();
                              });
                            },
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(
                    width: 20,
                  ),
                  Expanded(
                    child: TypeAheadField<PondModel>(
                      controller: _pondController,
                      builder: (context, controller, focusNode) {
                        return MyTextField(
                          controller: controller,
                          hintText: selectedPonds.isEmpty
                              ? "Select Pond"
                              : selectedPonds
                                  .map((e) => "${e.name} (${e.pondId})")
                                  .join(', '),
                          focusNode: focusNode,
                          labelText: "PONDS",
                        );
                      },
                      onSelected: (value) {},
                      suggestionsCallback: (search) {
                        return farmerPondInfo.value.ponds!
                            .where((ele) =>
                                ele.name!
                                    .toLowerCase()
                                    .contains(search.toLowerCase()) ||
                                ele.pondId
                                    .toString()
                                    .toLowerCase()
                                    .contains(search.toLowerCase()))
                            // .map((e) => "${e.name} (${e.pondId})")
                            .toList();
                      },
                      itemBuilder: (context, suggestion) {
                        return Container(
                          decoration: const BoxDecoration(color: Colors.white),
                          child: CheckboxListTile(
                            title: Text(
                                "${suggestion.name} (${suggestion.pondId})"),
                            value: selectedPonds.contains(suggestion),
                            onChanged: (bool? selected) {
                              setState(() {
                                if (selected == true &&
                                    !selectedPonds.contains(suggestion)) {
                                  selectedPonds.add(suggestion);
                                } else if (selected == false &&
                                    selectedPonds.contains(suggestion)) {
                                  selectedPonds.remove(suggestion);
                                }
                                _pondController.clear();
                              });
                            },
                          ),
                        );
                      },
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
              height: context.height * 0.12,
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
                      labelText: "From - To",
                      hintText: selectedDateRange == null
                          ? 'Select Date Range'
                          : '${DateFormat('dd/MMMM/yyyy').format(selectedDateRange!.start)}  -  ${DateFormat('dd/MMMM/yyyy').format(selectedDateRange!.end)}',
                      isReadOny: true,
                      onTap: () {
                        _selectDateRange(context);
                      },
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            MyButton(
                text: "Submit",
                onPressed: () async {
                  // if (_formKey.currentState!.validate()) {
                  if (selectedFarms.isEmpty) {
                    MyToasts.toastError("Please select farm");
                    return;
                  }
                  if (selectedPonds.isEmpty) {
                    MyToasts.toastError("Please select pond");
                    return;
                  }
                  if (selectedDateRange == null) {
                    MyToasts.toastError("Please select date range");
                    return;
                  }

                  final startDate = selectedDateRange!.start;
                  final endDate = selectedDateRange!.end;
                  final farmIds = selectedFarms.map((e) => e.farmId!).toList();
                  final pondIds = selectedPonds.map((e) => e.pondId!).toList();
                  // final sensors = parameterValue.split(' & ');

                  await controller.getWaterQualityChartData(
                      pondIds, [parameterValue], startDate, endDate);
                }
                // },
                )
          ],
        ),
      ),
    );
  }
}
