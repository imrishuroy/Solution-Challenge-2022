import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final Function(String value) onChanged;
  final TextInputType textInputType;
  final String? Function(String? value) validator;
  final String hintText;
  final IconData? prefixIcon;
  final bool isPassowrdField;
  final Widget? suffixIcon;
  final EdgeInsetsGeometry? contentPadding;
  final String? initialValue;
  final int maxLines;

  const CustomTextField({
    Key? key,
    required this.onChanged,
    required this.textInputType,
    required this.validator,
    required this.hintText,
    this.maxLines = 1,
    this.prefixIcon,
    this.suffixIcon,
    this.isPassowrdField = false,
    this.contentPadding = const EdgeInsets.fromLTRB(14, 8, 12, 8),
    this.initialValue,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      maxLines: maxLines,
      initialValue: initialValue,
      style: const TextStyle(color: Colors.black, fontSize: 16.0),
      onChanged: onChanged,
      keyboardType: textInputType,
      validator: validator,
      obscureText: isPassowrdField,
      decoration: InputDecoration(
        suffixIcon: suffixIcon,
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.0),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.0),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.0),
          borderSide: const BorderSide(color: Colors.red),
        ),
        contentPadding: const EdgeInsets.all(10),

        // prefixIcon:
        //     prefixIcon != null ? Icon(prefixIcon, color: Colors.white) : null,
        // suffixIcon: suffixIcon,
        labelStyle: const TextStyle(
          color: Colors.white,
          fontFamily: 'Montserrat',
          fontSize: 14.0,
          letterSpacing: 1.0,
        ),
        hintText: hintText,

        hintStyle: TextStyle(color: Colors.grey.shade600),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14.0),
        ),
      ),
      // decoration: inputDecorator.copyWith(hintText: hintText),
    );
  }
}
