import 'package:admin/shared/widgets/toast/my_toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';

import '../../constant/font_helper.dart';
import '../../constant/global_variables.dart';

class MyTextField extends StatefulWidget {
  final TextStyle? textStyle;
  final TextEditingController? controller;
  // final String? initialValue;
  final bool isPass, isReadOny, autoFocus;
  final String hintText;
  final TextStyle? hindStyle;
  final String? labelText;
  final TextStyle? labelStyle;
  final TextInputType textInputType;
  final VoidCallback? onTap;
  final bool isValidate;
  final Function(String)? validator;
  final int? maxLength;
  final List<TextInputFormatter>? inputFormatters;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final bool showLabel;
  final Function(String)? onChanged;
  final bool showCounter;
  final FocusNode? focusNode;
  const MyTextField({
    Key? key,
    this.textStyle,
    this.controller,
    // this.initialValue,
    this.isPass = false,
    this.isReadOny = false,
    this.autoFocus = false,
    required this.hintText,
    this.hindStyle,
    this.labelText,
    this.labelStyle,
    this.textInputType = TextInputType.text,
    this.onTap,
    this.isValidate = true,
    this.validator,
    this.maxLength,
    this.inputFormatters,
    this.prefixIcon,
    this.suffixIcon,
    this.showLabel = true,
    this.onChanged,
    this.showCounter = false,
    this.focusNode,
  }) : super(key: key);

  @override
  State<MyTextField> createState() => _MyTextFieldState();
}

class _MyTextFieldState extends State<MyTextField> {
  bool isObserver = false;
  String errorText = '';
  int textCount = 0;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          TextFormField(
            controller: widget.controller,
            // initialValue: widget.initialValue,
               focusNode: widget.focusNode,
            validator: (val) {
              if (widget.isValidate) {
                // if (widget.validator == null) {
                //   // errorText = " ";
                // } else
                if (val!.isEmpty) {
                  if (!widget.hintText.contains("-")) {
                    errorText = 'Required';
                  }
                } else {
                  errorText = widget.validator!(val);
                }
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  setState(() {});
                });
                return errorText.isEmpty ? null : errorText;
              }
              return null;
            },
            onChanged: (value) {
              if (widget.onChanged != null) {
                widget.onChanged!(value);
              }
              textCount = value.length;
              setState(() {});
            },
            style: widget.textStyle ?? GlobalFonts.ts16px700w(),
            readOnly: widget.isReadOny,
            autofocus: widget.autoFocus,
            cursorColor: greenColor,
            onTap: widget.onTap,
            maxLength: widget.maxLength,
            // autovalidateMode: AutovalidateMode.disabled,
            inputFormatters: widget.inputFormatters,
            decoration: InputDecoration(
              counter: const Offstage(),
              prefixIcon: widget.prefixIcon,
              suffix: widget.maxLength != null && widget.showCounter
                  ? Text(
                      '$textCount/${widget.maxLength}',
                      style: GlobalFonts.ts12px500w(color: greenColor),
                    )
                  : null,
              floatingLabelBehavior: widget.showLabel
                  ? FloatingLabelBehavior.always
                  : FloatingLabelBehavior.never,
              hintText: widget.hintText,
              hintStyle: (widget.hindStyle ?? GlobalFonts.ts16px700w())
                  .copyWith(color: Colors.black.withOpacity(.3)),
              labelText: widget.labelText ?? widget.hintText,
              labelStyle: (widget.labelStyle ?? GlobalFonts.ts16px600w())
                  .copyWith(
                      color: errorText.isEmpty
                          ? greenColor
                          : const Color(0xFFFF2B02)),
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide:
                      const BorderSide(color: Color(0xFF166351), width: 1.5)),
              focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide:
                      const BorderSide(color: Color(0xFF166351), width: 1.5)),
              enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide:
                      const BorderSide(color: Color(0xFF166351), width: 1.5)),
              errorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide:
                      const BorderSide(color: Color(0xFFFF2B02), width: 1.5)),
              contentPadding: const EdgeInsets.symmetric(horizontal: 16),
              errorText: null,
              errorStyle: const TextStyle(fontSize: 0),
              suffixIcon: widget.isPass
                  ? IconButton(
                      icon: isObserver
                          ? const Icon(Icons.visibility_outlined,
                              color: greenColor, size: 20)
                          : const Icon(Icons.visibility_off_outlined,
                              color: greenColor, size: 20),
                      onPressed: () => setState(
                        () => isObserver = !isObserver,
                      ),
                    )
                  : widget.suffixIcon,
            ),
            keyboardType: widget.textInputType,
            obscureText: widget.isPass && !isObserver,
          ),
          if (errorText.isNotEmpty)
            Text(
              errorText,
              style: GlobalFonts.ts12px400w(color: const Color(0xFFFF2B02)),
            )
          // else
          //   const SizedBox(height: 10),
        ],
      ),
    );
  }
}

class DropdownFormField extends StatefulWidget {
  const DropdownFormField({
    super.key,
    this.textStyle,
    required this.hintText,
    required this.dropDownItems,
    this.labelText,
    this.labelStyle,
    this.controller,
    this.isValidate = false,
    this.isReadOny = false,
    this.value = '',
    this.validator,
    this.onChange,
  });
  final TextStyle? textStyle;
  final String hintText;
  final String? labelText;
  final TextStyle? labelStyle;
  final List<String> dropDownItems;
  final TextEditingController? controller;
  final bool isValidate;
  final bool isReadOny;
  final String value;
  final Function(String)? validator;
  final Function(String)? onChange;

  @override
  State<DropdownFormField> createState() => _DropdownFormFieldState();
}

class _DropdownFormFieldState extends State<DropdownFormField> {
  String? _currentSelectedValue;
  String errorText = '';
  bool isValueChanged = false;
  @override
  void initState() {
    super.initState();
    if (widget.value.isNotEmpty) {
      widget.controller?.text = widget.value;
    }

    widget.controller?.addListener(() {
      if (widget.controller!.text.isNotEmpty &&
          widget.dropDownItems.contains(widget.controller!.text)) {
        // _currentSelectedValue = widget.controller!.text;
        _currentSelectedValue = widget.dropDownItems
            .firstWhere((element) => element == widget.controller!.text);
        debugPrint('_currentSelectedValue: $_currentSelectedValue');

        WidgetsBinding.instance.addPostFrameCallback((_) {
          mounted
              ? setState(() {
                  isValueChanged = true;
                  debugPrint('isValueChanged: $isValueChanged');
                })
              : null;
        });
      } else {
        debugPrint("not found!!!");
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    // remove listener
    widget.controller?.removeListener(() {});
  }

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      ignoring: widget.isReadOny,
      child: GestureDetector(
        onTap: widget.dropDownItems.isEmpty
            ? () {
                if (widget.dropDownItems.isEmpty) {
                  MyToasts.toastSuccess(
                      "${widget.labelText?.replaceAll("*", "") ?? widget.hintText} has no item");
                }
              }
            : null,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            DropdownButtonFormField(
              borderRadius: BorderRadius.circular(10),
              validator: (val) {
                if (widget.isValidate) {
                  if (val == null) {
                    errorText = 'Required';
                  } else {
                    errorText = widget.validator!(val);
                  }
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    mounted ? setState(() {}) : null;
                  });
                  return errorText.isEmpty ? null : errorText;
                }
                return null;
              },
              isExpanded: true,
              style: widget.textStyle ?? GlobalFonts.ts16px500w(),
              alignment: Alignment.topCenter,
              icon: const Icon(Icons.keyboard_arrow_down_outlined,
                  color: blackColor),
              decoration: InputDecoration(
                hintText: widget.hintText,
                labelText: widget.labelText ?? widget.hintText,
                floatingLabelBehavior: FloatingLabelBehavior.always,
                hintStyle:
                    GlobalFonts.ts16px700w(color: Colors.black.withOpacity(.5)),
                labelStyle: (widget.labelStyle ?? GlobalFonts.ts16px700w())
                    .copyWith(
                        color: errorText.isEmpty
                            ? greenColor
                            : const Color(0xFFFF2B02)),
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide:
                        const BorderSide(color: Color(0xFF166351), width: 1.5)),
                focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide:
                        const BorderSide(color: Color(0xFF166351), width: 1.5)),
                enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide:
                        const BorderSide(color: Color(0xFF166351), width: 1.5)),
                errorBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide:
                        const BorderSide(color: Color(0xFFFF2B02), width: 1.5)),
                contentPadding: const EdgeInsets.symmetric(horizontal: 16)
                    .copyWith(right: 5),
                counter: const Offstage(),
                errorText: null,
                errorStyle: const TextStyle(fontSize: 0),
              ),
              value: widget.value == '' || isValueChanged
                  ? _currentSelectedValue
                  : widget.value,
              items: widget.dropDownItems.map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value, style: GlobalFonts.ts14px600w),
                );
              }).toList(),
              onChanged: (String? value) {
                setState(() {
                  _currentSelectedValue = value!;
                  widget.controller?.text = value;
                });
                if (widget.onChange != null) {
                  widget.onChange!(value!);
                }
              },
            ),
            if (errorText.isNotEmpty)
              Text(
                errorText,
                style: GlobalFonts.ts12px400w(color: const Color(0xFFFF2B02)),
              )
          ],
        ),
      ),
    );
  }
}

// class DropdownFormFieldByModel<T> extends StatefulWidget {
//   const DropdownFormFieldByModel({
//     super.key,
//     required this.hintText,
//     required this.dropDownItems,
//     this.labelText,
//     this.controller,
//     this.isValidate = false,
//     this.isReadOnly = false,
//     this.value,
//     this.validator,
//     this.onChange,
//   });

//   final String hintText;
//   final String? labelText;
//   final List<DropdownMenuItem<T>> dropDownItems;
//   final TextEditingController? controller;
//   final bool isValidate;
//   final bool isReadOnly;
//   final T? value;
//   final String? Function(T?)? validator;
//   final void Function(T?)? onChange;

//   @override
//   State<DropdownFormFieldByModel<T>> createState() =>
//       _DropdownFormFieldByModelState<T>();
// }

// class _DropdownFormFieldByModelState<T>
//     extends State<DropdownFormFieldByModel<T>> {
//   T? _currentSelectedValue;
//   String errorText = '';
//   bool _isDropdownOpen = false;
//   final TextEditingController _typeAheadController = TextEditingController();

//   @override
//   void initState() {
//     super.initState();
//     _currentSelectedValue = widget.value;
//   }

//   @override
//   Widget build(BuildContext context) {
//     return IgnorePointer(
//       ignoring: widget.isReadOnly,
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         mainAxisAlignment: MainAxisAlignment.start,
//         children: [
//           GestureDetector(
//             onTap: () {
//               setState(() {
//                 _isDropdownOpen = !_isDropdownOpen;
//               });
//             },
//             child: Container(
//               decoration: BoxDecoration(
//                 border: Border.all(color: Colors.grey),
//                 borderRadius: BorderRadius.circular(8.0),
//               ),
//               child: Row(
//                 children: [
//                   Expanded(
//                     child: Padding(
//                       padding: const EdgeInsets.all(8.0),
//                       child: Text(widget.hintText),
//                     ),
//                   ),
//                   Icon(
//                     _isDropdownOpen
//                         ? Icons.keyboard_arrow_up
//                         : Icons.keyboard_arrow_down,
//                     color: Colors.black,
//                   ),
//                 ],
//               ),
//             ),
//           ),
//           if (_isDropdownOpen)
//             TypeAheadField<T>(
//               textFieldConfiguration: TextFieldConfiguration(
//                 controller: _typeAheadController,
//                 decoration: InputDecoration(
//                   labelText: widget.labelText ?? widget.hintText,
//                   floatingLabelBehavior: FloatingLabelBehavior.always,
//                 ),
//               ),
//               suggestionsCallback: (pattern) {
//                 return widget.dropDownItems
//                     .where((item) => item.value
//                         .toString()
//                         .toLowerCase()
//                         .contains(pattern.toLowerCase()))
//                     .map((item) => item.value!)
//                     .toList();
//               },
//               itemBuilder: (context, suggestion) {
//                 return ListTile(
//                   title: Text(suggestion.toString()),
//                 );
//               },
//               onSuggestionSelected: (suggestion) {
//                 setState(() {
//                   _currentSelectedValue = suggestion;
//                   _typeAheadController.text = suggestion.toString();
//                   _isDropdownOpen = false;
//                 });
//                 if (widget.onChange != null) {
//                   widget.onChange!(suggestion);
//                 }
//               },
//             ),
//           if (errorText.isNotEmpty)
//             Text(
//               errorText,
//               style: TextStyle(color: Colors.red, fontSize: 12),
//             ),
//         ],
//       ),
//     );
//   }
// }

class DropdownFormFieldByModel<T> extends StatefulWidget {
  const DropdownFormFieldByModel({
    Key? key,
    required this.hintText,
    required this.dropDownItems,
    this.labelText,
    this.controller,
    this.isValidate = false,
    this.isReadOnly = false,
    this.value,
    this.validator,
    this.onChange,
  }) : super(key: key);

  final String hintText;
  final String? labelText;
  final List<DropdownMenuItem<T>> dropDownItems;
  final TextEditingController? controller;
  final bool isValidate;
  final bool isReadOnly;
  final T? value;
  final Function(T?)? validator;
  final void Function(T?)? onChange;

  @override
  State<DropdownFormFieldByModel<T>> createState() =>
      _DropdownFormFieldByModelState<T>();
}

class _DropdownFormFieldByModelState<T>
    extends State<DropdownFormFieldByModel<T>> {
  T? _currentSelectedValue;
  String errorText = '';

  @override
  void initState() {
    super.initState();
    _currentSelectedValue = widget.value;
  }

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      ignoring: widget.isReadOnly,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          DropdownButtonFormField<T>(
            validator: (val) {
              if (widget.isValidate) {
                if (val == null) {
                  errorText = 'Required';
                } else if (widget.validator != null) {
                  errorText = widget.validator!(val);
                }
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  setState(() {});
                });
                return errorText.isEmpty ? null : errorText;
              }
              return null;
            },
            isExpanded: true,
            style: GlobalFonts.ts16px700w(),
            alignment: Alignment.topCenter,
            icon: const Icon(Icons.keyboard_arrow_down_outlined,
                color: Colors.black),
            decoration: InputDecoration(
              hintText: widget.hintText,
              labelText: widget.labelText ?? widget.hintText,
              floatingLabelBehavior: FloatingLabelBehavior.always,
              hintStyle:
                  GlobalFonts.ts16px700w(color: Colors.black.withOpacity(.5)),
              labelStyle: GlobalFonts.ts16px700w(
                  color:
                      errorText.isEmpty ? greenColor : const Color(0xFFFF2B02)),
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide:
                      const BorderSide(color: Color(0xFF166351), width: 1.5)),
              focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide:
                      const BorderSide(color: Color(0xFF166351), width: 1.5)),
              enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide:
                      const BorderSide(color: Color(0xFF166351), width: 1.5)),
              errorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide:
                      const BorderSide(color: Color(0xFFFF2B02), width: 1.5)),
              contentPadding: const EdgeInsets.symmetric(horizontal: 16),
              counter: const Offstage(),
              errorText: null,
              errorStyle: const TextStyle(fontSize: 0),
            ),
            value: _currentSelectedValue,
            items: widget.dropDownItems,
            onChanged: (T? value) {
              setState(() {
                _currentSelectedValue = value;
              });
              if (widget.onChange != null) {
                widget.onChange!(value);
              }
            },
          ),
          if (errorText.isNotEmpty)
            Text(
              errorText,
              style: GlobalFonts.ts12px400w(color: const Color(0xFFFF2B02)),
            )
        ],
      ),
    );
  }
}
