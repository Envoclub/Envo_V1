import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../utils/meta_assets.dart';
import '../../../utils/meta_colors.dart';
import '../../../utils/validators.dart';
import 'auth_helper_widgets.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key, required this.pageController});
  final PageController pageController;

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();
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
          title: TitleWidget(title: "Sign Up."),
        ),
        body: Container(
            child: Form(
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: SingleChildScrollView(
                child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: InkWell(
                    onTap: () {
                      widget.pageController.jumpToPage(0);
                    },
                    child: Card(
                      shadowColor: MetaColors.formFieldColor,
                      elevation: 10,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Icon(
                          Icons.arrow_back_ios,
                          color: MetaColors.primaryColor,
                        ),
                      ),
                    ),
                  ),
                ),
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.asset(
                    MetaAssets.logo,
                    height: 50,
                    width: 50,
                  ),
                ),
                FormFieldWidget(
                  textController: emailController,
                  label: "Email Address",
                  validator: validateEmail,
                ),
                SizedBox(
                  height: 10,
                ),
                FormFieldWidget(
                  textController: passwordController,
                  label: "Password",
                  obscureText: true,
                  validator: validatePassword,
                ),
                SizedBox(
                  height: 10,
                ),
                FormFieldWidget(
                  textController: confirmPasswordController,
                  label: "Confirm Password",
                  obscureText: true,
                  validator: (value) {
                    return validateConfirmPassword(
                        value, passwordController.text.trim());
                  },
                ),
                SizedBox(
                  height: 10,
                ),
                CustomButton(
                  label: "Sign Up",
                  handler: () {
                    if (!_formKey.currentState!.validate()) return;
                  },
                ),
                AgreementWidget(),
                SizedBox(
                  height: 10,
                ),
                Align(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: InkWell(
                      onTap: () {
                        widget.pageController.jumpToPage(0);
                      },
                      child: RichText(
                          text: TextSpan(
                              text: "Already Registered? ",
                              style: TextStyle(
                                  color: MetaColors.tertiaryTextColor,
                                  fontFamily: "Poppins",
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500),
                              children: [
                            TextSpan(
                                text: "Sign In.",
                                style:
                                    TextStyle(color: MetaColors.primaryColor))
                          ])),
                    ),
                  ),
                )
              ],
            )),
          ),
        )),
      ),
    );
  }
}
