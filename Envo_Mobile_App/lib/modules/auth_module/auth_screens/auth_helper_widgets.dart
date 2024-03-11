import 'package:envo_mobile/utils/meta_assets.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';

import '../../../utils/meta_colors.dart';
import '../../../utils/meta_styles.dart';

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
      padding: const EdgeInsets.all(8.0),
      child: Text(
        title,
        style: TextStyle(
            color: MetaColors.tertiaryTextColor,
            fontWeight: FontWeight.w500,
            fontSize: 13),
      ),
    );
  }
}

class TitleWidget extends StatelessWidget {
  const TitleWidget({Key? key, required this.title, this.isLogo = false})
      : super(key: key);
  final String title;
  final bool isLogo;
  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: TextStyle(
          fontSize: isLogo ? 50 : 25,
          fontWeight: FontWeight.w500,
          color: MetaColors.secondaryColor),
    );
  }
}

class CustomButton extends StatelessWidget {
  const CustomButton({
    Key? key,
    this.loading = false,
    required this.handler,
    required this.label,
  }) : super(key: key);
  final VoidCallback? handler;
  final String label;
  final bool? loading;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(18.0),
      child: Container(
        width: double.maxFinite,
        decoration: BoxDecoration(
          color:
              handler == null ? Colors.grey.shade500 : MetaColors.primaryColor,
          boxShadow: [
            BoxShadow(
                color: MetaColors.primaryColor.withOpacity(0.3),
                spreadRadius: 5,
                blurRadius: 15,
                offset: Offset(0, 8))
          ],
          borderRadius: BorderRadius.circular(16),
          // gradient: LinearGradient(
          //     begin: Alignment.bottomCenter,
          //     end: Alignment.topCenter,
          //     colors: [MetaColors.primaryColor, MetaColors.secondaryColor])
        ),
        child: loading!
            ? Center(
                child: Padding(
                    padding: const EdgeInsets.all(18.0),
                    child: CircularProgressIndicator(color: Colors.white)),
              )
            : InkWell(
                onTap: handler,
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.all(18.0),
                    child: Text(
                      label,
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color:
                              handler == null ? Colors.white30 : Colors.white),
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
      this.isUnderLineStyle = false,
      this.onTap,
      this.suffix,
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
  final bool isUnderLineStyle;
  final Widget? suffix;

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
        decoration: isUnderLineStyle
            ? MetaStyles.formFieldUnderLineDecoration(label)
                .copyWith(suffix: suffix)
            : MetaStyles.formFieldDecoration(label).copyWith(suffix: suffix),
      ),
    );
  }
}
