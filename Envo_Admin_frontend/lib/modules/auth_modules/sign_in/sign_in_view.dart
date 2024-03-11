import 'package:envo_admin_dashboard/cubits/auth/auth_cubit.dart';
import 'package:envo_admin_dashboard/modules/auth_modules/sign_in/auth_helper_widgets.dart';
import 'package:envo_admin_dashboard/utils/meta_assets.dart';
import 'package:envo_admin_dashboard/utils/meta_colors.dart';
import 'package:envo_admin_dashboard/utils/validators.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SignInWidget extends StatefulWidget {
  final PageController pageController;
  const SignInWidget({super.key, required this.pageController});

  @override
  State<SignInWidget> createState() => _SignInWidgetState();
}

class _SignInWidgetState extends State<SignInWidget> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
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
                title: "Sign In.",
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
              validator: (val){
                return null;
              },
            ),
            SizedBox(
              height: 10,
            ),
            CustomButton(
              label: "Sign In",
              handler: () {
                if (!_formKey.currentState!.validate()) return;
                context.read<AuthCubit>().login(emailController.text.trim(),
                    passwordController.text.trim());
              },
            ),
            SizedBox(
              height: 10,
            ),
            Align(
              alignment: Alignment.centerRight,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: InkWell(
                    onTap: () {
                      widget.pageController.jumpToPage(2);
                    },
                    child: Text(
                      "Forgot Password?",
                      style:
                          TextStyle(fontSize: 11, fontWeight: FontWeight.w600),
                    )),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            // Align(
            //   child: Padding(
            //     padding: const EdgeInsets.all(8.0),
            //     child: InkWell(
            //       onTap: () {
            //         widget.pageController.jumpToPage(1);
            //       },
            //       child: RichText(
            //           text: TextSpan(
            //               text: "New User? ",
            //               style: TextStyle(
            //                   color: MetaColors.tertiaryTextColor,
            //                   fontFamily: "Poppins",
            //                   fontSize: 12,
            //                   fontWeight: FontWeight.w500),
            //               children: [
            //             TextSpan(
            //                 text: "Sign Up.",
            //                 style:
            //                     TextStyle(color: MetaColors.primaryColor))
            //           ])),
            //     ),
            //   ),
            // )
          ],
        )),
      ),
    ));
  }
}
