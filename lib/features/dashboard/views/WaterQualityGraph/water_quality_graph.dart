// // import 'package:flutter/material.dart';

// // import '../../../../shared/constant/font_helper.dart';
// // import '../../../../shared/widgets/buttons/my_button.dart';
// // import '../../../../shared/widgets/inputs/my_text_field.dart';

// // class WaterQualityGraph extends StatefulWidget {
// //   const WaterQualityGraph({super.key});

// //   @override
// //   State<WaterQualityGraph> createState() => _WaterQualityGraphState();
// // }

// // class _WaterQualityGraphState extends State<WaterQualityGraph> {
// //   final _formKey = GlobalKey<FormState>();
// //   final TextEditingController _pondIdController = TextEditingController();
// //   final TextEditingController _startDateController = TextEditingController();
// //   final TextEditingController _endDateController = TextEditingController();
// //   final TextEditingController _frequencyController = TextEditingController();
// //   String frequencyValue = '5';
// //   String parameterValue = 'Ph';
// //   DateTime? _startDate;
// //   DateTime? _endDate;
// //   @override
// //   void dispose() {
// //     _pondIdController.dispose();
// //     _startDateController.dispose();
// //     _endDateController.dispose();
// //     _frequencyController.dispose();
// //     super.dispose();
// //   }

// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //       appBar: AppBar(
// //         title: Text("Graph"),
// //       ),
// //       body: Column(
// //         children: [
// //           Form(
// //             key: _formKey,
// //             child: Column(
// //               children: [
// //                 Row(
// //                   crossAxisAlignment: CrossAxisAlignment.start,
// //                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
// //                   children: [
// //                     Expanded(
// //                       child: MyTextField(
// //                         controller: _pondIdController,
// //                         hintText: "Pond ID",
// //                         textStyle: GlobalFonts.ts20px500w(),
// //                         labelText: "PondID",
// //                         isValidate: true,
// //                         validator: (value) {
// //                           if (value.isEmpty) {
// //                             return "required";
// //                           }
// //                           return null;
// //                         },
// //                       ),
// //                     ),
// //                     Expanded(
// //                       child: MyTextField(
// //                         controller: _startDateController,
// //                         hintText: "From",
// //                         textStyle: GlobalFonts.ts20px500w(),
// //                         labelText: "Start Date",
// //                         isValidate: true,
// //                         isReadOny: true,
// //                         onTap: () async {
// //                           final DateTime? pickedDate = await showDatePicker(
// //                             context: context,
// //                             initialDate: _startDate ?? DateTime.now(),
// //                             firstDate: DateTime(2000),
// //                             lastDate: DateTime(2101),
// //                           );
// //                           if (pickedDate != null) {
// //                             setState(() {
// //                               _startDate = pickedDate;
// //                               _startDateController.text = _startDate!
// //                                   .toLocal()
// //                                   .toString()
// //                                   .split(' ')[0];
// //                               if (_endDate != null &&
// //                                   _endDate!.isBefore(_startDate!)) {
// //                                 _endDate = _startDate;
// //                                 _endDateController.text = _endDate!
// //                                     .toLocal()
// //                                     .toString()
// //                                     .split(' ')[0];
// //                               }
// //                             });
// //                           }
// //                         },
// //                         validator: (value) {
// //                           if (value.isEmpty) {
// //                             return "required";
// //                           }
// //                           return null;
// //                         },
// //                       ),
// //                     ),
// //                     Expanded(
// //                       child: MyTextField(
// //                         controller: _endDateController,
// //                         hintText: "To",
// //                         textStyle: GlobalFonts.ts20px500w(),
// //                         labelText: "End Date",
// //                         isValidate: true,
// //                         isReadOny: true,
// //                         onTap: () async {
// //                           final DateTime? pickedDate = await showDatePicker(
// //                             context: context,
// //                             initialDate:
// //                                 _endDate ?? _startDate ?? DateTime.now(),
// //                             firstDate: _startDate ?? DateTime(2000),
// //                             lastDate: DateTime(2101),
// //                           );
// //                           if (pickedDate != null) {
// //                             setState(() {
// //                               _endDate = pickedDate;
// //                               _endDateController.text =
// //                                   _endDate!.toLocal().toString().split(' ')[0];
// //                             });
// //                           }
// //                         },
// //                         validator: (value) {
// //                           if (value.isEmpty) {
// //                             return "required";
// //                           }
// //                           return null;
// //                         },
// //                       ),
// //                     ),
// //                     Expanded(
// //                       child: DropdownFormField(
// //                         labelText: "Frequency(minutes)",
// //                         hintText: '-',
// //                         value: frequencyValue,
// //                         dropDownItems: const [
// //                           '5',
// //                           '10',
// //                           '15',
// //                           '20',
// //                           '25',
// //                           '30',
// //                           '35',
// //                           '40',
// //                           '45',
// //                           '50',
// //                           '55',
// //                           '60'
// //                         ],
// //                         onChange: (value) {
// //                           frequencyValue = value;
// //                         },
// //                       ),
// //                     ),
// //                     SizedBox(
// //                       width: 7,
// //                     ),
// //                     Expanded(
// //                       child: DropdownFormField(
// //                         hintText: "Type",
// //                         value: parameterValue,
// //                         dropDownItems: const [
// //                           "Ph",
// //                           "Temp",
// //                           "DO",
// //                           "NH4",
// //                           "NO3",
// //                           "EC",
// //                         ],
// //                         onChange: (value) {
// //                           // setState(() {
// //                           parameterValue = value;
// //                           // });
// //                         },
// //                       ),
// //                     ),
// //                   ],
// //                 ),
// //                 Padding(
// //                   padding: const EdgeInsets.symmetric(horizontal: 16.0),
// //                   child: MyButton(
// //                     text: "Submit",
// //                     height: 47,
// //                     onPressed: () async {
// //                       if (_formKey.currentState!.validate()) {
// //                         // try {
// //                         //   final finalCollectionType =
// //                         //       typeValue == 'ConclusiveData' ? 1 : 2;
// //                         //   controller
// //                         //       .conclusiveOrRawLiveData(
// //                         //     typeIdController.text,
// //                         //     dlNoController.text,
// //                         //     networkNoController.text,
// //                         //     finalCollectionType.toString(),
// //                         //     countController.text,
// //                         //   )
// //                         //       .then((value) {
// //                         //     if (value != null) {
// //                         //       conclusiveOrRawData(value);
// //                         //     }
// //                         //   });
// //                         // } catch (e) {
// //                         //   MyToasts.toastError("Not Able To Fetch The Data");
// //                         // }
// //                       }
// //                     },
// //                   ),
// //                 )
// //               ],
// //             ),
// //           ),
// //         ],
// //       ),
// //     );
// //   }
// // }
// import 'package:flutter/material.dart';
// import '../../../../shared/constant/font_helper.dart';
// import '../../../../shared/widgets/buttons/my_button.dart';
// import '../../../../shared/widgets/inputs/my_text_field.dart';

// class WaterQualityGraph extends StatefulWidget {
//   const WaterQualityGraph({super.key});

//   @override
//   State<WaterQualityGraph> createState() => _WaterQualityGraphState();
// }

// class _WaterQualityGraphState extends State<WaterQualityGraph> {
//   final _formKey = GlobalKey<FormState>();
//   final TextEditingController _pondIdController = TextEditingController();
//   final TextEditingController _startDateController = TextEditingController();
//   final TextEditingController _endDateController = TextEditingController();
//   final TextEditingController _frequencyController = TextEditingController();
//   String frequencyValue = '5';
//   String parameterValue = 'Ph';
//   DateTime? _startDate;
//   DateTime? _endDate;

//   @override
//   void dispose() {
//     _pondIdController.dispose();
//     _startDateController.dispose();
//     _endDateController.dispose();
//     _frequencyController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text("Graph"),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Form(
//           key: _formKey,
//           child: LayoutBuilder(
//             builder: (BuildContext context, BoxConstraints constraints) {
//               if (constraints.maxWidth < 600) {
//                 // For small screens, use a Wrap widget to show 2 widgets per row
//                 return Wrap(
//                   spacing: 16.0,
//                   runSpacing: 16.0,
//                   children: _buildFormFields(isRowLayout: false),
//                 );
//               } else {
//                 // For large screens, use a row layout
//                 return Row(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: _buildFormFields(isRowLayout: true),
//                 );
//               }
//             },
//           ),
//         ),
//       ),
//     );
//   }

//   List<Widget> _buildFormFields({required bool isRowLayout}) {
//     List<Widget> fields = [
//       MyTextField(
//         controller: _startDateController,
//         hintText: "From",
//         textStyle: GlobalFonts.ts20px500w(),
//         labelText: "Start Date",
//         isValidate: true,
//         isReadOny: true,
//         onTap: () async {
//           final DateTime? pickedDate = await showDatePicker(
//             context: context,
//             initialDate: _startDate ?? DateTime.now(),
//             firstDate: DateTime(2000),
//             lastDate: DateTime(2101),
//           );
//           if (pickedDate != null) {
//             setState(() {
//               _startDate = pickedDate;
//               _startDateController.text =
//                   _startDate!.toLocal().toString().split(' ')[0];
//               if (_endDate != null && _endDate!.isBefore(_startDate!)) {
//                 _endDate = _startDate;
//                 _endDateController.text =
//                     _endDate!.toLocal().toString().split(' ')[0];
//               }
//             });
//           }
//         },
//         validator: (value) {
//           if (value.isEmpty) {
//             return "required";
//           }
//           return null;
//         },
//       ),
//       MyTextField(
//         controller: _endDateController,
//         hintText: "To",
//         textStyle: GlobalFonts.ts20px500w(),
//         labelText: "End Date",
//         isValidate: true,
//         isReadOny: true,
//         onTap: () async {
//           final DateTime? pickedDate = await showDatePicker(
//             context: context,
//             initialDate: _endDate ?? _startDate ?? DateTime.now(),
//             firstDate: _startDate ?? DateTime(2000),
//             lastDate: DateTime(2101),
//           );
//           if (pickedDate != null) {
//             setState(() {
//               _endDate = pickedDate;
//               _endDateController.text =
//                   _endDate!.toLocal().toString().split(' ')[0];
//             });
//           }
//         },
//         validator: (value) {
//           if (value.isEmpty) {
//             return "required";
//           }
//           return null;
//         },
//       ),
//       DropdownFormField(
//         labelText: "Frequency(minutes)",
//         hintText: '-',
//         value: frequencyValue,
//         dropDownItems: const [
//           '5',
//           '10',
//           '15',
//           '20',
//           '25',
//           '30',
//           '35',
//           '40',
//           '45',
//           '50',
//           '55',
//           '60'
//         ],
//         onChange: (value) {
//           frequencyValue = value;
//         },
//       ),
//       DropdownFormField(
//         hintText: "Type",
//         value: parameterValue,
//         dropDownItems: const [
//           "Ph",
//           "Temp",
//           "DO",
//           "NH4",
//           "NO3",
//           "EC",
//         ],
//         onChange: (value) {
//           parameterValue = value;
//         },
//       ),
//       MyTextField(
//         controller: _pondIdController,
//         hintText: "Pond ID",
//         textStyle: GlobalFonts.ts20px500w(),
//         labelText: "PondID",
//         isValidate: true,
//         validator: (value) {
//           if (value.isEmpty) {
//             return "required";
//           }
//           return null;
//         },
//       ),
//       MyButton(
//         text: "Submit",
//         height: 47,
//         onPressed: () async {
//           if (_formKey.currentState!.validate()) {}
//         },
//       )
//     ];

//     if (isRowLayout) {
//       return fields.map((field) => Expanded(child: field)).toList();
//     }
//     return fields
//         .map((field) => SizedBox(
//               width: MediaQuery.of(context).size.width / 2 - 24,
//               child: field,
//             ))
//         .toList();
//   }
// }

import 'package:admin/shared/constant/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get_utils/get_utils.dart';
// import 'package:syncfusion_flutter_datepicker/datepicker.dart';

class WaterQualityGraph extends StatefulWidget {
  const WaterQualityGraph({super.key});

  @override
  State<WaterQualityGraph> createState() => _WaterQualityGraphState();
}

class _WaterQualityGraphState extends State<WaterQualityGraph> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _pondIdController = TextEditingController();
  final TextEditingController _startDateController = TextEditingController();
  final TextEditingController _endDateController = TextEditingController();
  final TextEditingController _frequencyController = TextEditingController();
  String frequencyValue = '5';
  String parameterValue = 'Ph';
  // final DateRangePickerController _datePickerController =
  //     DateRangePickerController();
  // final List<bool> _isSelected = List.generate(6, (index) => false);
  // final String _selectedValue = 'Option 1';

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
    return Scaffold(
      appBar: AppBar(
        title: Text("Graph"),
      ),
      body: Row(
        children: [
          Expanded(
            child: Column(
              children: [
                Container(
                    width: context.width * 0.2,
                    height: context.height * 0.2,
                    decoration: BoxDecoration(
                      border: Border.all(color: AppColors.kcBlack),
                    ),
                    child: Text("data")
                    //  SfDateRangePicker(
                    //   controller: _datePickerController,
                    //   selectionMode: DateRangePickerSelectionMode.range,
                    // )
                    ),
                SizedBox(
                  height: 10,
                ),
                Container(
                  width: context.width * 0.2,
                  height: context.height * 0.2,
                  decoration: BoxDecoration(
                      border: Border.all(color: AppColors.kcBlack)),
                  child: Text("data"),
                ),
                SizedBox(
                  height: 10,
                ),
                Container(
                  width: context.width * 0.2,
                  height: context.height * 0.2,
                  decoration: BoxDecoration(
                      border: Border.all(color: AppColors.kcBlack)),
                  child: Text("data"),
                ),
              ],
            ),
          ),
          Expanded(
            child: Column(
              children: [
                Container(
                  width: double.infinity,
                  height: context.height * 0.65,
                  decoration: BoxDecoration(
                      border: Border.all(color: AppColors.kcBlack)),
                  child: Text("data"),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}

// class MyHomePage extends StatefulWidget {
//   @override
//   _MyHomePageState createState() => _MyHomePageState();
// }

// class _MyHomePageState extends State<MyHomePage> {
//   DateRangePickerController _datePickerController = DateRangePickerController();
//   List<bool> _isSelected = List.generate(6, (index) => false);
//   String _selectedValue = 'Option 1';

//   @override
//   Widget build(BuildContext context) {
//     return Expanded(
//       child: Column(
//         children: [
//           Container(
//             width: MediaQuery.of(context).size.width * 0.2,
//             height: MediaQuery.of(context).size.height * 0.2,
//             decoration: BoxDecoration(
//               border: Border.all(color: Colors.black),
//             ),
//             child: SfDateRangePicker(
//               controller: _datePickerController,
//               selectionMode: DateRangePickerSelectionMode.range,
//             ),
//           ),
//           SizedBox(
//             height: 10,
//           ),
//           Container(
//             width: MediaQuery.of(context).size.width * 0.2,
//             height: MediaQuery.of(context).size.height * 0.2,
//             decoration: BoxDecoration(
//               border: Border.all(color: Colors.black),
//             ),
//             child: ListView.builder(
//               itemCount: 6,
//               itemBuilder: (context, index) {
//                 return CheckboxListTile(
//                   title: Text('Option ${index + 1}'),
//                   value: _isSelected[index],
//                   onChanged: (bool? value) {
//                     setState(() {
//                       _isSelected[index] = value!;
//                     });
//                   },
//                 );
//               },
//             ),
//           ),
//           SizedBox(
//             height: 10,
//           ),
//           Container(
//             width: MediaQuery.of(context).size.width * 0.2,
//             height: MediaQuery.of(context).size.height * 0.2,
//             decoration: BoxDecoration(
//               border: Border.all(color: Colors.black),
//             ),
//             child: DropdownButton<String>(
//               value: _selectedValue,
//               items: <String>['Option 1', 'Option 2', 'Option 3', 'Option 4']
//                   .map((String value) {
//                 return DropdownMenuItem<String>(
//                   value: value,
//                   child: Text(value),
//                 );
//               }).toList(),
//               onChanged: (String? newValue) {
//                 setState(() {
//                   _selectedValue = newValue!;
//                 });
//               },
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
