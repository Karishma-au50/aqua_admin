import 'package:admin/shared/constant/app_colors.dart';
import 'package:admin/shared/constant/font_helper.dart';
import 'package:admin/shared/widgets/buttons/my_button.dart';
import 'package:admin/shared/widgets/inputs/my_text_field.dart';
import 'package:flutter/material.dart';
import 'package:get/get_utils/get_utils.dart';
import 'package:intl/intl.dart';

import '../../../../shared/constant/global_variables.dart';

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
  String frequencyValue = '5';
  String parameterValue = 'PH';
  List<String> options = [
    'PH',
    'DO',
    'NH3',
    'NH4',
    'TEMPERATURE',
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
  List<bool> _isSelected = [false, false, false, false, false, false];
  List<bool> _isSelectedFrequency = [false, false, false, false, false, false];

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
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: MyTextField(
                    isReadOny: true,
                    suffixIcon: const Icon(Icons.calendar_month_outlined),
                    labelText: 'Start Date',
                    hintText: _startDate == null
                        ? 'Start Date'
                        : DateFormat.yMd().format(_startDate!),
                    onTap: () => _selectStartDate(context),
                  ),
                ),
                // const SizedBox(height: 20),
                Expanded(
                  child: MyTextField(
                    isReadOny: true,
                    suffixIcon: const Icon(Icons.calendar_month_outlined),
                    labelText: 'End Date',
                    hintText: _endDate == null
                        ? 'End Date'
                        : DateFormat.yMd().format(_endDate!),
                    onTap: () => _selectEndDate(context),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Container(
                      height: context.height * 0.35,
                      decoration: BoxDecoration(
                          border: Border.all(color: greenColor),
                          borderRadius: BorderRadius.circular(10)),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: double.infinity,
                            decoration: BoxDecoration(
                              color: greenColor,
                              borderRadius: new BorderRadius.only(
                                topLeft: const Radius.circular(10.0),
                                topRight: const Radius.circular(10.0),
                              ),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                "Select Frequency",
                                style: GlobalFonts.ts16px400w(
                                    color: AppColors.kcWhite),
                              ),
                            ),
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: List.generate(
                              frequency.length,
                              (index) => Row(
                                children: [
                                  Radio(
                                    activeColor: greenColor,
                                    value: frequency[index],
                                    groupValue: frequencyValue,
                                    onChanged: (String? value) {
                                      setState(() {
                                        frequencyValue = value!;
                                      });
                                    },
                                  ),
                                  SizedBox(
                                    width: context.width * 0.04,
                                  ),
                                  Text(
                                    frequency[index],
                                    style: GlobalFonts.ts14px500w,
                                  ),
                                ],
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 20,
                  ),
                  Expanded(
                    child: Container(
                      height: context.height * 0.35,
                      decoration: BoxDecoration(
                          border: Border.all(color: greenColor),
                          borderRadius: BorderRadius.circular(10)),
                      child: Column(
                        children: [
                          Container(
                            width: double.infinity,
                            decoration: const BoxDecoration(
                              color: greenColor,
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(10.0),
                                topRight: Radius.circular(10.0),
                              ),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                "Select Parameter",
                                style: GlobalFonts.ts16px400w(
                                    color: AppColors.kcWhite),
                              ),
                            ),
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: List.generate(
                              options.length,
                              (index) => Row(
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
                                  SizedBox(
                                    width: context.width * 0.04,
                                  ),
                                  Text(
                                    options[index],
                                    style: GlobalFonts.ts14px500w,
                                  ),
                                ],
                              ),
                            ),
                          )
                        ],
                      ),
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
                  if (_formKey.currentState!.validate()) {}
                })
          ],
        ),
      ),
    );
  }
}
