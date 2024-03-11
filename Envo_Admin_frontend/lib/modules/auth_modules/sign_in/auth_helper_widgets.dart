import 'package:envo_admin_dashboard/utils/meta_colors.dart';
import 'package:envo_admin_dashboard/utils/meta_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AgreementWidget extends StatelessWidget {
  const AgreementWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Text(
        "By Clicking on Login I agree to all the Terms and conditions and privacy policy.",
        style: TextStyle(
            fontSize: 10,
            fontWeight: FontWeight.w500,
            color: MetaColors.secondaryTextColor),
      ),
    );
  }
}

class SubtitleWidget extends StatelessWidget {
  const SubtitleWidget({Key? key, required this.title}) : super(key: key);
  final String title;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Text(
        title,
        style: TextStyle(
            color: MetaColors.tertiaryTextColor,
            fontWeight: FontWeight.w500,
            fontSize: 11),
      ),
    );
  }
}

class TitleWidget extends StatelessWidget {
  const TitleWidget({Key? key, required this.title}) : super(key: key);
  final String title;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0).copyWith(bottom: 10),
      child: Text(
        title,
        style: TextStyle(
            fontSize: 18, fontWeight: FontWeight.w800, color: Colors.black),
      ),
    );
  }
}

class CustomButton extends StatelessWidget {
  const CustomButton({
    Key? key,
    this.loading = false,
    this.isDashBoard=false,
    required this.handler,
    required this.label,
  }) : super(key: key);
  final VoidCallback handler;
  final String label;
  final bool? loading;
  final bool isDashBoard;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        width:isDashBoard?null: double.maxFinite,
        decoration: BoxDecoration(
          color: MetaColors.primaryColor,
          boxShadow: [
            BoxShadow(
                color: MetaColors.primaryColor.withOpacity(0.3),
                spreadRadius: 5,
                blurRadius: 15,
                offset: Offset(0, 8))
          ],
          borderRadius: BorderRadius.circular(12),
        ),
        child: loading!
            ? Center(
                child: Padding(
                  padding: const EdgeInsets.all(18.0),
                  child: CircularProgressIndicator(
                    color: Colors.white,
                  ),
                ),
              )
            : InkWell(
                onTap: handler,
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.all(18.0),
                    child: Text(
                      label,
                      style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          color: Colors.white),
                    ),
                  ),
                ),
              ),
      ),
    );
  }
}

class FormFieldWidget extends StatelessWidget {
  FormFieldWidget(
      {Key? key,
      required this.textController,
      this.enabled = true,
      this.readOnly = false,
      this.isPhone = false,
      required this.label,
      this.obscureText = false,
      this.onTap,
      required this.validator})
      : super(key: key);
  final String label;
  final TextEditingController textController;
  final bool? obscureText;
  final String? Function(String?) validator;
  final bool? enabled;
  final bool? readOnly;
  final bool? isPhone;
  VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextFormField(
        readOnly: readOnly!,
        onTap: onTap,
        enabled: enabled,
        inputFormatters: [
          if (isPhone!) FilteringTextInputFormatter.digitsOnly,
          if (isPhone!) LengthLimitingTextInputFormatter(10)
        ],
        validator: validator,
        controller: textController,
        style: MetaStyles.labelStyle,
        cursorColor: Colors.black,
        obscureText: obscureText!,
        decoration: MetaStyles.formFieldDecoration(label),
      ),
    );
  }
}
