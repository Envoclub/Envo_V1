import 'package:envo_admin_dashboard/repositories/auth_repository.dart';
import 'package:envo_admin_dashboard/utils/helper_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';

import '../../../auth.dart';
import '../../../utils/meta_colors.dart';
import '../../../utils/validators.dart';
import 'auth_helper_widgets.dart';

class ResetPassword extends StatefulWidget {
  const ResetPassword({super.key, required this.uid, required this.token});

  final String uid;
  final String token;

  @override
  State<ResetPassword> createState() => _ResetPasswordState();
}

class _ResetPasswordState extends State<ResetPassword> {
  TextEditingController codeController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool loading = false;

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        return Future.value(true);
      },
      child: Container(
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
          ),
          body: loading
              ? Center(
                  child: Loader(),
                )
              : Form(
                  key: _formKey,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: SingleChildScrollView(
                        child: Column(
                      children: [
                        SizedBox(
                          height: MediaQuery.of(context).size.height * .15,
                        ),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: TitleWidget(
                            title: "Reset Password?",
                          ),
                        ),
                        Align(
                          alignment: Alignment.centerLeft,
                          child:
                              SubtitleWidget(title: "Update your new Password"),
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
                        CustomButton(
                          label: "Confirm",
                          handler: () async {
                            if (!_formKey.currentState!.validate()) return;
                            setState(() {
                              loading = true;
                            });
                            var response = await AuthRepository()
                                .resetPasswordConfirm(widget.uid, widget.token,
                                    passwordController.text.trim());
                            setState(() {
                              loading = false;
                            });
                            if (response[0]) {
                              showSnackBar(
                                  "Password Reset successfully.Please login again",
                                  isError: false);

                              Get.offUntil(
                                  GetPageRoute(
                                      page: () => Scaffold(
                                          body: Container(
                                              color: Colors.blue.shade100
                                                  .withOpacity(0.1),
                                              child: Auth()))),
                                  (route) => false);
                            } else {
                              showSnackBar(
                                response[1] ?? "Errororor",
                              );
                            }
                          },
                        ),
                      ],
                    )),
                  ),
                ),
        ),
      ),
    );
  }
}
