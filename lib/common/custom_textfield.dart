import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mappingapp/common/app_style.dart';

class CustomTextFields extends StatelessWidget {
  const CustomTextFields({
    super.key,
    required this.firstText,
    required this.hintText,
    this.keyboardType,
    required this.controller,
    this.suffixIcon,
    this.inputFormatters,
    this.validator,
    this.obscureText = false,
    this.onForgotPassword,
    this.autofocus = false,
    this.onChanged,
    this.maxLengthEnforcement,
    this.contentPadding,
    this.maxLength,
    this.maxLines = 1,
    this.readOnly = false,
    this.extraText, // Optional callback for "Forgot Password?"
  });
  final String? firstText, hintText, extraText;
  final TextEditingController controller;
  final String? Function(String?)? validator;
  final List<TextInputFormatter>? inputFormatters;
  final Widget? suffixIcon;
  final TextInputType? keyboardType;
  final bool obscureText, autofocus, readOnly;
  final VoidCallback? onForgotPassword; // Callback for when the link is tapped
  final Function(String)? onChanged;
  final MaxLengthEnforcement? maxLengthEnforcement;
  final EdgeInsetsGeometry? contentPadding;
  final int? maxLength, maxLines;
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      validator: validator,
      autofocus: autofocus,
      maxLength: maxLength,
      maxLines: maxLines,
      inputFormatters: inputFormatters,
      keyboardType: keyboardType,
      obscureText: obscureText,
      onChanged: onChanged,
      maxLengthEnforcement: maxLengthEnforcement,
      readOnly: readOnly,
      decoration: InputDecoration(
        suffixIcon: suffixIcon,
        hintText: hintText,
        hintStyle: appStyle(14, Colors.black, FontWeight.w500),
        contentPadding:
            contentPadding ??
            EdgeInsets.symmetric(horizontal: 20.h, vertical: 19.w),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.r),
          borderSide: BorderSide(color: Colors.grey, width: .9),
        ),
        // Border when the field is selected
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.r),
          borderSide: BorderSide(color: Colors.orange, width: 1),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.r),
          borderSide: BorderSide(color: Colors.red, width: .9),
        ),
      ),
    );
  }
}
