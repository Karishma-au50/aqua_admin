import 'package:admin/features/dashboard/controller/water_quality_controller.dart';
import 'package:admin/model/value_parameter_model.dart';
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
  final VoidCallback? callback;
  const ValueParameter({super.key, this.callback});

  @override
  State<ValueParameter> createState() => _ValueParameterState();
}

class _ValueParameterState extends State<ValueParameter> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _pondIdController = TextEditingController();
  final TextEditingController _startDateController = TextEditingController();
  final TextEditingController _endDateController = TextEditingController();
  final TextEditingController _frequencyController = TextEditingController();
  FarmerPondInfoModel farmerPondInfo = FarmerPondInfoModel();

  List<FarmModel> selectedFarms = <FarmModel>[].obs;
  List<PondModel> selectedPonds = <PondModel>[].obs;

  RxList<PondModel> filteredPonds = <PondModel>[].obs;

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
    // "PH & DO",
    // "PH & NH3",
    // "NH4 & NH3"
  ];

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
  final SuggestionsController<PondModel> _pondSuggestionsController =
      SuggestionsController<PondModel>();

  DateTimeRange? selectedDateRange;
  Future<void> _selectDateRange(BuildContext context) async {
    final DateTimeRange? picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: greenColor,
              secondary: Colors.grey,
              onPrimary: Colors.white,
              onSurface: Colors.black,
            ),
          ),
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                ),
                // height: MediaQuery.of(context).size.height * 0.6,
                // width: MediaQuery.of(context).size.width * 0.7,
                constraints:
                    const BoxConstraints(maxWidth: 500, maxHeight: 570),
                child: child,
              ),
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
        farmerPondInfo = value;
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
        child: LayoutBuilder(builder: (context, constraints) {
          bool isMobile = constraints.maxWidth < 600;
          return Column(
            children: [
              Container(
                height: isMobile ? null : context.height * 0.12,
                decoration: BoxDecoration(
                  color: Colors.white, // Add background color if needed
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 2,
                      blurRadius: 3,
                      offset:
                          const Offset(0, 0.5), // changes position of shadow
                    ),
                  ],
                  borderRadius: BorderRadius.circular(
                      10), // Adjust border radius as needed
                ),
                child: isMobile
                    ? Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                            // width: 80,
                            decoration: const BoxDecoration(
                              color: greenColor,
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(10.0),
                                topRight: Radius.circular(10.0),
                              ),
                            ),
                            child: const Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Center(
                                child: Text(
                                  "WHERE?",
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 16),
                                ),
                              ),
                            ),
                          ),
                          TypeAheadField<FarmModel>(
                            controller: _farmController,
                            decorationBuilder: (context, child) {
                              return Material(
                                type: MaterialType.card,
                                elevation: 4,
                                borderRadius: BorderRadius.circular(8),
                                child: child,
                              );
                            },
                            offset: const Offset(0, 12),
                            constraints: const BoxConstraints(maxHeight: 300),
                            builder: (context, controller, focusNode) {
                              return Obx(() {
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
                              });
                            },
                            onSelected: (value) {},
                            suggestionsCallback: (search) {
                              return farmerPondInfo.farms!
                                  .where((ele) =>
                                      ele.name.contains(search) ||
                                      ele.farmId.toString().contains(search))
                                  .toList();
                            },
                            itemBuilder: (context, suggestion) {
                              return Container(
                                decoration:
                                    const BoxDecoration(color: Colors.white),
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
                                      filteredPonds.clear();
                                      filteredPonds.value = farmerPondInfo
                                          .ponds!
                                          .where((element) => selectedFarms
                                              .map((e) => e.farmId)
                                              .contains(element.farmId))
                                          .toList();
                                      _pondSuggestionsController.suggestions =
                                          filteredPonds;
                                      _farmController.clear();
                                    });
                                  },
                                ),
                              );
                            },
                          ),
                          TypeAheadField<PondModel>(
                            controller: _pondController,
                            suggestionsController: _pondSuggestionsController,
                            constraints: const BoxConstraints(maxHeight: 300),
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
                              return filteredPonds.isEmpty
                                  ? null
                                  : filteredPonds
                                      .where((ele) =>
                                          (ele.name!.toLowerCase().contains(
                                                  search.toLowerCase()) ||
                                              ele.pondId
                                                  .toString()
                                                  .toLowerCase()
                                                  .contains(
                                                      search.toLowerCase())) &&
                                          selectedFarms.any((element) =>
                                              element.farmId == ele.farmId))
                                      .toList();
                            },
                            itemBuilder: (context, suggestion) {
                              return Container(
                                decoration:
                                    const BoxDecoration(color: Colors.white),
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
                          )
                        ],
                      )
                    : Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                            width: 80,
                            decoration: const BoxDecoration(
                              color: greenColor,
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(10.0),
                                bottomLeft: Radius.circular(10.0),
                              ),
                            ),
                            child: const Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Center(
                                child: Text(
                                  "WHERE?",
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 16),
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            child: TypeAheadField<FarmModel>(
                              controller: _farmController,
                              decorationBuilder: (context, child) {
                                return Material(
                                  type: MaterialType.card,
                                  elevation: 4,
                                  borderRadius: BorderRadius.circular(8),
                                  child: child,
                                );
                              },
                              offset: const Offset(0, 12),
                              constraints: const BoxConstraints(maxHeight: 300),
                              builder: (context, controller, focusNode) {
                                return Obx(() {
                                  return MyTextField(
                                    controller: controller,
                                    hintText: selectedFarms.isEmpty
                                        ? "Select Farm"
                                        : selectedFarms
                                            .map((e) =>
                                                "${e.name} (${e.farmId})")
                                            .join(', '),
                                    focusNode: focusNode,
                                    labelText: "FARMS",
                                  );
                                });
                              },
                              onSelected: (value) {},
                              suggestionsCallback: (search) {
                                return farmerPondInfo.farms!
                                    .where((ele) =>
                                        ele.name.contains(search) ||
                                        ele.farmId.toString().contains(search))
                                    .toList();
                              },
                              itemBuilder: (context, suggestion) {
                                return Container(
                                  decoration:
                                      const BoxDecoration(color: Colors.white),
                                  child: CheckboxListTile(
                                    title: Text(
                                        "${suggestion.name} (${suggestion.farmId})"),
                                    value: selectedFarms.contains(suggestion),
                                    onChanged: (bool? selected) {
                                      setState(() {
                                        if (selected == true &&
                                            !selectedFarms
                                                .contains(suggestion)) {
                                          selectedFarms.add(suggestion);
                                        } else if (selected == false &&
                                            selectedFarms
                                                .contains(suggestion)) {
                                          selectedFarms.remove(suggestion);
                                        }
                                        filteredPonds.clear();
                                        filteredPonds.value = farmerPondInfo
                                            .ponds!
                                            .where((element) => selectedFarms
                                                .map((e) => e.farmId)
                                                .contains(element.farmId))
                                            .toList();
                                        _pondSuggestionsController.suggestions =
                                            filteredPonds;
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
                            suggestionsController: _pondSuggestionsController,
                            constraints: const BoxConstraints(maxHeight: 300),
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
                              return filteredPonds.isEmpty
                                  ? null
                                  : filteredPonds
                                      .where((ele) =>
                                          (ele.name!.toLowerCase().contains(
                                                  search.toLowerCase()) ||
                                              ele.pondId
                                                  .toString()
                                                  .toLowerCase()
                                                  .contains(
                                                      search.toLowerCase())) &&
                                          selectedFarms.any((element) =>
                                              element.farmId == ele.farmId))
                                      .toList();
                            },
                            itemBuilder: (context, suggestion) {
                              return Container(
                                decoration:
                                    const BoxDecoration(color: Colors.white),
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
                          )),
                        ],
                      ),
              ),
              const SizedBox(
                height: 10,
              ),
              Container(
                height: isMobile ? null : context.height * 0.13,
                decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 2,
                      blurRadius: 3,
                      offset: const Offset(0, 0.5),
                    ),
                  ],
                  borderRadius: BorderRadius.circular(10),
                ),
                child: isMobile
                    ? Column(
                        children: [
                          Container(
                            decoration: const BoxDecoration(
                              color: greenColor,
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(10.0),
                                topRight: Radius.circular(10.0),
                              ),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Center(
                                child: Text(
                                  "WHAT?",
                                  style: GlobalFonts.ts16px400w(
                                      color: AppColors.kcWhite),
                                ),
                              ),
                            ),
                          ),
                          Wrap(
                            children: List.generate(
                              selectedPonds.length > 1 ? 7 : options.length,
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
                          )
                        ],
                      )
                    : Row(
                        children: [
                          Container(
                            width: 80,
                            decoration: const BoxDecoration(
                              color: greenColor,
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(10.0),
                                bottomLeft: Radius.circular(10.0),
                              ),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Center(
                                child: Text(
                                  "WHAT?",
                                  style: GlobalFonts.ts16px400w(
                                      color: AppColors.kcWhite),
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            child: Wrap(
                              children: List.generate(
                                selectedPonds.length > 1 ? 7 : options.length,
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
                height: isMobile ? null : context.height * 0.12,
                decoration: BoxDecoration(
                  color: Colors.white, // Add background color if needed
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 2,
                      blurRadius: 3,
                      offset:
                          const Offset(0, 0.5), // changes position of shadow
                    ),
                  ],
                  borderRadius: BorderRadius.circular(
                      10), // Adjust border radius as needed
                ),
                child: isMobile
                    ? Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                            decoration: const BoxDecoration(
                              color: greenColor,
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(10.0),
                                topRight: Radius.circular(10.0),
                              ),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Center(
                                child: Text(
                                  "WHEN?",
                                  style: GlobalFonts.ts16px400w(
                                      color: AppColors.kcWhite),
                                ),
                              ),
                            ),
                          ),
                          MyTextField(
                            labelText: "From - To",
                            hintText: selectedDateRange == null
                                ? 'Select Date Range'
                                : '${DateFormat('dd/MMMM/yyyy').format(selectedDateRange!.start)}  -  ${DateFormat('dd/MMMM/yyyy').format(selectedDateRange!.end)}',
                            isReadOny: true,
                            onTap: () {
                              _selectDateRange(context);
                            },
                          ),
                        ],
                      )
                    : Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                            width: 80,
                            decoration: const BoxDecoration(
                              color: greenColor,
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(10.0),
                                bottomLeft: Radius.circular(10.0),
                              ),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Center(
                                child: Text(
                                  "WHEN?",
                                  style: GlobalFonts.ts16px400w(
                                      color: AppColors.kcWhite),
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
              Align(
                alignment: AlignmentDirectional.topEnd,
                child: MyButton(
                    width: context.width * 0.2,
                    text: "Submit",
                    borderRadius: BorderRadius.circular(5),
                    disabled: selectedFarms.isEmpty ||
                        selectedPonds.isEmpty ||
                        selectedDateRange == null,
                    borderColor: selectedFarms.isEmpty ||
                            selectedPonds.isEmpty ||
                            selectedDateRange == null
                        ? Colors.grey
                        : greenColor,
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
                      // final farmIds =
                      //     selectedFarms.map((e) => e.farmId!).toList();
                      final pondIds =
                          selectedPonds.map((e) => e.pondId!).toList();
                      controller.valueParameterModel = ValueParameterModel(
                        ponds: selectedPonds,
                        farms: selectedFarms,
                        sensor: parameterValue,
                        startDate: startDate,
                        endDate: endDate,
                      );

                      await controller.getWaterQualityChartData(
                          pondIds, [parameterValue], startDate, endDate);
                    }),
              )
            ],
          );
        }),
      ),
    );
  }
}
