import 'package:envo_admin_dashboard/utils/meta_colors.dart';
import 'package:flutter/material.dart';

class MetaStyles {
  static const TextStyle labelStyle =
      TextStyle(color: Colors.black, fontWeight: FontWeight.w400,fontSize: 12);
  static OutlineInputBorder baseFormFieldBorder = OutlineInputBorder(
      borderSide: BorderSide.none, borderRadius: BorderRadius.circular(8));
  static OutlineInputBorder baseFocusedFormFieldBorder = OutlineInputBorder(
      borderSide: BorderSide(color: MetaColors.primaryColor),
      borderRadius: BorderRadius.circular(8));
  static OutlineInputBorder baseErrorFormFieldBorder = OutlineInputBorder(
      borderSide: BorderSide(color: Colors.red),
      borderRadius: BorderRadius.circular(8));

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
}
