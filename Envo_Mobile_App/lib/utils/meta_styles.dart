import 'package:flutter/material.dart';

import 'meta_colors.dart';

class MetaStyles {
  static const TextStyle labelStyle =
      TextStyle(color: Colors.black, fontWeight: FontWeight.w600);
  static OutlineInputBorder baseFormFieldBorder = OutlineInputBorder(
      borderSide: BorderSide.none, borderRadius: BorderRadius.circular(15));
  static OutlineInputBorder baseFocusedFormFieldBorder = OutlineInputBorder(
      borderSide: BorderSide(color: MetaColors.primaryColor),
      borderRadius: BorderRadius.circular(18));
  static OutlineInputBorder baseErrorFormFieldBorder = OutlineInputBorder(
      borderSide: BorderSide(color: Colors.red),
      borderRadius: BorderRadius.circular(18));
  static UnderlineInputBorder baseFormFieldUnderLineBorder =
      UnderlineInputBorder(
          borderSide: BorderSide.none, borderRadius: BorderRadius.circular(15));
  static UnderlineInputBorder baseFocusedFormFieldUnderLineBorder =
      UnderlineInputBorder(
          borderSide: BorderSide(color: MetaColors.primaryColor),
          borderRadius: BorderRadius.circular(18));
  static UnderlineInputBorder baseErrorFormFieldUnderLineBorder =
      UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.red),
          borderRadius: BorderRadius.circular(18));

  static InputDecoration formFieldDecoration(String label, {Widget? suffix}) {
    return InputDecoration(
      labelText: label,
      suffixIcon: suffix,

      // hintText: "Email",
      labelStyle: MetaStyles.labelStyle,
      filled: true,
      fillColor: MetaColors.formFieldColor,
      border: MetaStyles.baseFormFieldBorder,
      errorBorder: MetaStyles.baseErrorFormFieldBorder,
      focusedBorder: MetaStyles.baseFocusedFormFieldBorder,
    );
  }

  static InputDecoration formFieldUnderLineDecoration(String label,
      {Widget? suffix}) {
    return InputDecoration(
      labelText: label,
      suffixIcon: suffix,

      // hintText: "Email",
      labelStyle: MetaStyles.labelStyle,
      filled: false,
      fillColor: MetaColors.formFieldColor,
      disabledBorder: MetaStyles.baseFocusedFormFieldUnderLineBorder,
      enabledBorder: MetaStyles.baseFocusedFormFieldUnderLineBorder,
      border: MetaStyles.baseFocusedFormFieldUnderLineBorder,
      errorBorder: MetaStyles.baseErrorFormFieldUnderLineBorder,
      focusedBorder: MetaStyles.baseFocusedFormFieldUnderLineBorder,
    );
  }
}
