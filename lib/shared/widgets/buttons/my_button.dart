import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../../constant/font_helper.dart';

class MyButton extends StatefulWidget {
  final String text;
  final Color textColor;
  final double width, height;
  final AsyncCallback onPressed;
  final Color color;
  final BorderRadius borderRadius;
  final Color borderColor;
  final List<BoxShadow>? boxShadow;
  final bool disabled;
  final TextStyle? textStyle;
  final Widget? leadingIcon;
  const MyButton({
    Key? key,
    required this.text,
    this.textColor = Colors.white,
    this.width = double.infinity,
    this.height = 40,
    required this.onPressed,
    this.color = const Color(0xFF166351),
    this.borderColor = const Color(0xFF166351),
    this.borderRadius = const BorderRadius.all(Radius.circular(8)),
    this.boxShadow,
    this.disabled = false,
    this.textStyle,
    this.leadingIcon,
  }) : super(key: key);

  @override
  State<MyButton> createState() => _MyButtonState();
}

class _MyButtonState extends State<MyButton> {
  bool isPressed = false;
  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      ignoring: widget.disabled,
      child: InkWell(
        onTap: isPressed
            ? null
            : () async {
                setState(() {
                  isPressed = !isPressed;
                });
                await widget.onPressed();
                setState(() {
                  isPressed = !isPressed;
                });
              },
        child: Container(
          height: widget.height,
          width: widget.width,
          decoration: BoxDecoration(
            color: (widget.disabled && widget.color != Colors.transparent)
                ? widget.color.withOpacity(0.5)
                : widget.color,
            borderRadius: widget.borderRadius,
            border: Border.all(
                color: (widget.disabled &&
                        widget.borderColor != Colors.transparent)
                    ? widget.borderColor.withOpacity(0.5)
                    : widget.borderColor),
            // color: widget.color,
            boxShadow: widget.boxShadow,
          ),
          child: Center(
            child: isPressed
                ? const CircularProgressIndicator(color: Colors.white)
                : Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      widget.leadingIcon ?? const SizedBox(),
                      Text(
                        widget.text,
                        style: widget.textStyle
                                ?.copyWith(color: widget.textColor) ??
                            GlobalFonts.ts16px500w(color: widget.textColor),
                      ),
                    ],
                  ),
          ),
        ),
      ),
    );
  }
}
