import 'package:envo_mobile/modules/auth_module/auth_screens/user_details_update.dart';
import 'package:envo_mobile/modules/auth_module/controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';

import '../user_details_update_module/view.dart';
import 'forgot_password.dart';
import 'reset_password.dart';
import 'sign_in_screen.dart';
import 'sign_up_screen.dart';

class AuthScreens extends GetView<AuthController> {
  const AuthScreens({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Scaffold(
        body: Container(
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(20)),
          child: PageView(
            physics: NeverScrollableScrollPhysics(),
            controller: controller.pageController,
            children: [
              SignInScreen(pageController: controller.pageController),
              
              SignUpScreen(pageController: controller.pageController),
              ForgotPassword(
                pageController: controller.pageController,
              ),
              ResetPassword(pageController: controller.pageController),UserDetailsUpdateScreen(),
            ],
          ),
        ),
      ),
    );
  }
}
