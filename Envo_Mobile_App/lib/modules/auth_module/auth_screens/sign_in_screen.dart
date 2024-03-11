import 'package:envo_mobile/modules/auth_module/controller.dart';
import 'package:envo_mobile/modules/home/binding.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../utils/meta_assets.dart';
import '../../../utils/meta_colors.dart';
import '../../../utils/meta_strings.dart';
import '../../../utils/validators.dart';
import '../../home/view.dart';
import 'auth_helper_widgets.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key, required this.pageController});
  final PageController pageController;
  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Container(
          child: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Scaffold(
            appBar: AppBar(),
            body: Container(
              child: SingleChildScrollView(
                  child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Align(
                    //   alignment: Alignment.centerLeft,
                    //   child: SubtitleWidget(
                    //       title: "Enter your Email and Password to Sign In"),
                    // ),
                    SizedBox(height: MediaQuery.of(context).size.height * .05),
                    Image.asset(
                      MetaAssets.envoBlueLogo,
                      height: 80,
                    ),
                    // Row(
                    //   mainAxisAlignment: MainAxisAlignment.center,
                    //   children: [
                    //     ClipRRect(
                    //       borderRadius: BorderRadius.circular(8),
                    //       child: Image.asset(
                    //         MetaAssets.logo,
                    //         height: 50,
                    //         width: 50,
                    //       ),
                    //     ),
                    //     SizedBox(
                    //       width: 10,
                    //     ),
                    //     TitleWidget(
                    //       title: "envo",
                    //       isLogo: true,
                    //     )
                    //   ],
                    // ),
                    // SubtitleWidget(title: "Help Earth, Get Rewarded"),
                    SizedBox(height: MediaQuery.of(context).size.height * .1),
                    FormFieldWidget(
                      enabled: !AuthController.to.authLoading.value,
                      textController: emailController,
                      label: "Email Address",
                      validator: validateEmail,
                    ),

                    Obx(
                      () => FormFieldWidget(
                        enabled: !AuthController.to.authLoading.value,
                        textController: passwordController,
                        label: "Password",
                        obscureText: AuthController.to.obscurePassword.value,
                        suffix: InkWell(
                          onTap: () {
                            AuthController.to.obscurePassword.value =
                                !AuthController.to.obscurePassword.value!;
                          },
                          child:
                              Obx(() => AuthController.to.obscurePassword.value!
                                  ? Icon(
                                      CupertinoIcons.eye,
                                      color: MetaColors.primaryColor,
                                    )
                                  : Icon(
                                      CupertinoIcons.eye_slash,
                                      color: MetaColors.primaryColor,
                                    )),
                        ),
                        validator: validatePassword,
                      ),
                    ),

                    CustomButton(
                      loading: AuthController.to.authLoading.value,
                      label: "Sign In",
                      handler: () {
                        if (!_formKey.currentState!.validate()) return;
                        AuthController.to.signIn(emailController.text.trim(),
                            passwordController.text.trim());
                      },
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Align(
                      alignment: Alignment.centerRight,
                      child: InkWell(
                        onTap: () async {
                            final Uri url = Uri.parse(MetaStrings.baseUrl +
                                MetaStrings.forgotPassword);
                            if (!await launchUrl(url,
                                mode: LaunchMode.externalApplication)) {
                              showSnackBar(
                                  "Something went wrong Please try again later");
                            }
                          },
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                              "Forgot Password?",
                              style: TextStyle(
                                  fontSize: 13, fontWeight: FontWeight.w600),
                            ),
                        ),
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
                    //         Get.to(HomeView());
                    //       },
                    //       child: RichText(
                    //           text: TextSpan(
                    //               text: "Jump to Onboarding UI? ",
                    //               style: TextStyle(
                    //                   color: MetaColors.tertiaryTextColor,
                    //                   fontFamily: "Poppins",
                    //                   fontSize: 12,
                    //                   fontWeight: FontWeight.w500),
                    //               children: [
                    //             TextSpan(
                    //                 text: "Click Here.",
                    //                 style: TextStyle(
                    //                     color: MetaColors.primaryColor))
                    //           ])),
                    //     ),
                    //   ),
                    // )
                  ],
                ),
              )),
            ),
          ),
        ),
      )),
    );
  }
}
