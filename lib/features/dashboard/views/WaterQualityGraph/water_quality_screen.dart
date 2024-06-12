import 'package:admin/features/dashboard/views/WaterQualityGraph/line_chart.dart';
import 'package:admin/features/dashboard/views/WaterQualityGraph/value_parameter.dart';
import 'package:admin/shared/widgets/buttons/my_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';

class WaterQualityScreen extends StatefulWidget {
  const WaterQualityScreen({super.key});

  @override
  State<WaterQualityScreen> createState() => _WaterQualityScreenState();
}

class _WaterQualityScreenState extends State<WaterQualityScreen> {
  @override
  Widget build(BuildContext context) {
    return
        //  MaterialApp(
        //   title: 'Flutter TypeAhead Example',
        //   theme: ThemeData(
        //     primarySwatch: Colors.blue,
        //   ),
        //   home: TypeAheadExample(),
        // );

        const Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            ValueParameter(),
            SizedBox(
              height: 20,
            ),
            LineChart(),
            // TypeAheadExample(),
            // MyButton(
            //     width: 150, text: "Add Parameters", onPressed: () async {}),
          ],
        ),
      ),
    );
  }
}

// class TypeAheadExample extends StatefulWidget {
//   @override
//   _TypeAheadExampleState createState() => _TypeAheadExampleState();
// }

// class _TypeAheadExampleState extends State<TypeAheadExample> {
//   final TextEditingController _typeAheadController = TextEditingController();
//   final List<String> _selectedItems = [];
//   final List<String> _suggestions = [
//     'Apple',
//     'Banana',
//     'Cherry',
//     'Date',
//     'Fig',
//     'Grape',
//     'Kiwi'
//   ];

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Flutter TypeAhead Example'),
//       ),
//       body: SingleChildScrollView(
//         child: Column(
//           children: [
//             TypeAheadField<String>(
//               textFieldConfiguration: TextFieldConfiguration(
//                 controller: _typeAheadController,
//                 decoration: InputDecoration(
//                   labelText: 'Select Items',
//                 ),
//               ),
//               suggestionsCallback: (pattern) {
//                 return _suggestions
//                     .where((item) =>
//                         item.toLowerCase().contains(pattern.toLowerCase()))
//                     .toList();
//               },
//               itemBuilder: (context, suggestion) {
//                 final isSelected = _selectedItems.contains(suggestion);
//                 return CheckboxListTile(
//                   title: Text(suggestion),
//                   value: isSelected,
//                   onChanged: (bool? selected) {
//                     setState(() {
//                       if (selected == true && !isSelected) {
//                         _selectedItems.add(suggestion);
//                       } else if (selected == false && isSelected) {
//                         _selectedItems.remove(suggestion);
//                       }
//                       _typeAheadController.clear();
//                     });
//                   },
//                 );
//               },
//               onSuggestionSelected: (suggestion) {
//                 // Do nothing here since selection is handled in CheckboxListTile
//               },
//             ),
//             SizedBox(height: 20),
//             Wrap(
//               spacing: 8.0,
//               children: _selectedItems.map((item) {
//                 return Chip(
//                   label: Text(item),
//                   onDeleted: () {
//                     setState(() {
//                       _selectedItems.remove(item);
//                     });
//                   },
//                 );
//               }).toList(),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
