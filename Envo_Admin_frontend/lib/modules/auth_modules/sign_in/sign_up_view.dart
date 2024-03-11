import 'package:envo_admin_dashboard/modules/auth_modules/sign_in/auth_helper_widgets.dart';
import 'package:envo_admin_dashboard/utils/meta_assets.dart';
import 'package:envo_admin_dashboard/utils/meta_colors.dart';
import 'package:envo_admin_dashboard/utils/validators.dart';
import 'package:flutter/material.dart';

class SignUpWidget extends StatefulWidget {
  final PageController pageController;
  const SignUpWidget({super.key, required this.pageController});

  @override
  State<SignUpWidget> createState() => _SignUpWidgetState();
}

class _SignUpWidgetState extends State<SignUpWidget> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Container(
        child: Form(
      key: _formKey,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
            child: Column(
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height * .1,
            ),
            Align(
              alignment: Alignment.centerLeft,
              child: TitleWidget(
                title: "Sign Up.",
              ),
            ),
            Align(
              alignment: Alignment.centerLeft,
              child: SubtitleWidget(
                  title: "Enter your Email and Password to Sign In"),
            ),
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
              handler: () {},
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
                            style: TextStyle(color: MetaColors.primaryColor))
                      ])),
                ),
              ),
            )
          ],
        )),
      ),
    ));
  }
}
