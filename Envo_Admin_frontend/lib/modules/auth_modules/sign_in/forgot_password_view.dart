import 'package:envo_admin_dashboard/modules/auth_modules/sign_in/auth_helper_widgets.dart';
import 'package:envo_admin_dashboard/utils/meta_assets.dart';
import 'package:envo_admin_dashboard/utils/meta_colors.dart';
import 'package:envo_admin_dashboard/utils/validators.dart';
import 'package:flutter/material.dart';

class ForgotPasswordWidget extends StatefulWidget {
final PageController pageController;
  const ForgotPasswordWidget({super.key,required this.pageController});

  @override
  State<ForgotPasswordWidget> createState() => _ForgotPasswordWidgetState();
}

class _ForgotPasswordWidgetState extends State<ForgotPasswordWidget> {
   TextEditingController emailController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Container(
      child: WillPopScope(
      onWillPop: () {
        widget.pageController.jumpToPage(0);
        return Future.value(false);
      },
      child: Container(
        child: Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(
          backgroundColor: Colors.transparent,elevation: 0,
            title: InkWell(
              onTap: () {
                widget.pageController.jumpToPage(0);
              },
              child: Card(
                // shadowColor: MetaColors.formFieldColor,
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
          body: Form(
                key: _formKey,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SingleChildScrollView(
                      child: Column(
                    children: [
                      SizedBox(
                        height: MediaQuery.of(context).size.height * .05,
                      ),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: TitleWidget(
                          title: "Forgot Password?",
                        ),
                      ),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: SubtitleWidget(
                            title:
                                "Enter your Email to receive password reset link"),
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
                      CustomButton(
                       
                        label: "Send Password Reset Link",
                        handler: () {
                     
                        },
                      ),
                    ],
                  )),
                ),
              )
        ),
      ),
    ));
  }
}
