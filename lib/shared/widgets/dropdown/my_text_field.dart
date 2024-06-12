import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../constant/font_helper.dart';
import '../../constant/global_variables.dart';

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
