import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class MyTextField extends StatelessWidget {
  final TextStyle? style;
  final FocusNode? focusNode;
  final TextEditingController? controller;
  final String? hintText;
  final bool? obscureText;
  final bool? isMultiline;
  final VoidCallback? onEditingComplete;
  final Function(String)? onChanged;
  final int? minLines;
  final int? maxLines;
  final Color? cursorColor;
  final EdgeInsets? scrollPadding;
  final TextInputType? keyboardType;
  final bool? enabled;
  final InputDecoration? decoration;
  final List<TextInputFormatter>? inputFormatters;
  final String obscuringCharacter;

  const MyTextField({
    this.controller,
    this.hintText,
    this.style,
    this.focusNode,
    this.scrollPadding,
    this.isMultiline,
    this.obscureText,
    this.onEditingComplete,
    this.minLines,
    this.maxLines,
    this.cursorColor,
    this.keyboardType,
    this.onChanged,
    this.enabled,
    this.decoration,
    this.inputFormatters,
    required this.obscuringCharacter,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // 1. CALCULATE FONT SIZE
    final double fontSize = style?.fontSize == null
        ? 16
        : style!.fontSize!;
    // 2. MERGE INTO textStyle param
    final textStyle = style == null
        ? TextStyle(fontSize: fontSize)
        : style!.copyWith(fontSize: fontSize);

    return TextField(
      enabled: enabled,
      focusNode: focusNode,
      controller: controller,
      // 3. SPECIFY THE SYNTHESIZED PARAM
      style: textStyle,
      onChanged: onChanged,
      obscureText: obscureText ?? false,
      minLines: minLines,
      maxLines: maxLines ?? 1,
      onEditingComplete: onEditingComplete,
      cursorColor: cursorColor,
      keyboardType: keyboardType,
      scrollPadding: scrollPadding ?? const EdgeInsets.all(20),
      decoration: decoration,
      inputFormatters: inputFormatters,
      obscuringCharacter: obscuringCharacter,
    );
  }
}