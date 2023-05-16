import 'package:flutter/material.dart';

import '../constants/app_colors.dart';

class CustomTextFiled extends StatelessWidget {
  const CustomTextFiled(
      {Key? key,
      this.controller,
      this.prefixIcon,
      this.labelText,
      this.validator,
      this.maxLines,
      this.suffixIcon,
      this.maxLength,
      this.onTap,
      this.onFieldSubmitted,
      this.enabled = true,
      this.readOnly = false,
      this.keyboardType = TextInputType.text})
      : super(key: key);
  final TextEditingController? controller;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final String? labelText;
  final TextInputType? keyboardType;
  final bool enabled;
  final int? maxLines;
  final int? maxLength;
  final bool readOnly;
  final ValueChanged<String>? onFieldSubmitted;
  final FormFieldValidator<String>? validator;
  final GestureTapCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      onTap: onTap,
      enabled: enabled,
      controller: controller,
      validator: validator,
      maxLines: maxLines,
      maxLength: maxLength,
      readOnly: readOnly,
      onFieldSubmitted: onFieldSubmitted,
      style: const TextStyle(color: Colors.black),
      decoration: InputDecoration(
        counter: const SizedBox(),
        contentPadding:
            const EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
        prefixIcon: prefixIcon,
        suffixIcon: suffixIcon,
        labelText: labelText,
        labelStyle: const TextStyle(
            color: Color(0xff222f3e),
            fontWeight: FontWeight.w500,
            fontSize: 14),
        border: OutlineInputBorder(
          borderSide: BorderSide(
              color: enabled ? AppColors.accent : Colors.grey.shade300),
          borderRadius: BorderRadius.circular(10.0),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(
              color: enabled ? AppColors.accent : Colors.grey.shade300),
          borderRadius: BorderRadius.circular(10.0),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(
              color: enabled ? AppColors.accent : Colors.grey.shade300),
          borderRadius: BorderRadius.circular(10.0),
        ),
      ),
      // autofocus: false,
      keyboardType: keyboardType,
    );
  }
}
