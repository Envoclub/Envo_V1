import 'package:envo_mobile/utils/meta_strings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../utils/meta_colors.dart';
import '../../../utils/validators.dart';
import '../controller.dart';
import 'auth_helper_widgets.dart';

class ForgotPassword extends StatefulWidget {
  const ForgotPassword({super.key, required this.pageController});
  final PageController pageController;

  @override
  State<ForgotPassword> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  TextEditingController emailController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        widget.pageController.jumpToPage(0);
        return Future.value(false);
      },
      child: Scaffold(
        appBar: AppBar(
          leading: Padding(
            padding: const EdgeInsets.all(8.0),
            child: InkWell(
              onTap: () async {
               
              },
              child: Card(
                shadowColor: MetaColors.formFieldColor,
                elevation: 10,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
                child: Center(
                  child: Icon(
                    Icons.arrow_back,
                    color: MetaColors.primaryColor,
                  ),
                ),
              ),
            ),
          ),
          title: Align(
            alignment: Alignment.centerLeft,
            child: TitleWidget(
              title: "Forgot Password",
            ),
          ),
        ),
        body: Container(
            child: Form(
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: SingleChildScrollView(
                child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 10,
                ),
                FormFieldWidget(
                  textController: emailController,
                  label: "Email Address",
                  validator: validateEmail,
                ),
                SizedBox(
                  height: 10,
                ),
                CustomButton(
                  label: "Send Password Reset Link",
                  handler: () {
                    if (!_formKey.currentState!.validate()) return;
                  },
                ),
              ],
            )),
          ),
        )),
      ),
    );
  }
}
