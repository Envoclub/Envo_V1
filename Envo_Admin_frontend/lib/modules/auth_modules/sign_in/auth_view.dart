import 'dart:math';

import 'package:envo_admin_dashboard/main.dart';
import 'package:envo_admin_dashboard/modules/auth_modules/sign_in/forgot_password_view.dart';
import 'package:envo_admin_dashboard/modules/auth_modules/sign_in/sign_in_view.dart';
import 'package:envo_admin_dashboard/modules/auth_modules/sign_in/sign_up_view.dart';
import 'package:envo_admin_dashboard/utils/meta_assets.dart';
import 'package:flutter/material.dart';

class AuthView extends StatefulWidget {
  const AuthView({super.key});

  @override
  State<AuthView> createState() => _AuthViewState();
}

class _AuthViewState extends State<AuthView> {
  PageController pageController = PageController();
  Random random = Random();

  @override
  Widget build(BuildContext context) {
    int value = random.nextInt(6);
    // int value = random.nextInt(5);
    return Padding(
      padding: const EdgeInsets.all(30.0),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(18),
          boxShadow: [
            BoxShadow(
                color: Colors.blue.shade100.withOpacity(0.5),
                blurRadius: 30,
                offset: Offset(
                  8,
                  8,
                ))
          ],
        ),
        child: LayoutBuilder(builder: (context, constraints) {
          if (constraints.maxWidth < 1000)
            return Center(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(18),
                ),
                width: MediaQuery.of(context).size.width * .6,
                child: AuthWidgets(pageController: pageController),
              ),
            );
          return Row(

            children: [
              Expanded(
                child: ClipRRect(
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(18),
                      bottomLeft: Radius.circular(18)),
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                        gradient: RadialGradient(radius: 0.9, colors: [
                      Colors.transparent,
                      Colors.black.withOpacity(0.2),
                    ])),
                    position: DecorationPosition.foreground,
                    child: Image.asset(
                      MetaAssets.authBackgorundImage[value],
                      fit: BoxFit.fill,
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height,
                    ),
                  ),
                ),
              ),
              Align(
                alignment: Alignment.centerRight,
                child: Container(
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                          topRight: Radius.circular(18),
                          bottomRight: Radius.circular(18))),
                  width: MediaQuery.of(context).size.width * .3,
                  child: Padding(
                    padding:
                        const EdgeInsets.all(30.0).copyWith(top: 0, bottom: 0),
                    child: Center(
                        child: AuthWidgets(pageController: pageController)),
                  ),
                ),
              ),
            ],
          );
        }),
      ),
    );
  }
}

class AuthWidgets extends StatelessWidget {
  const AuthWidgets({
    Key? key,
    required this.pageController,
  }) : super(key: key);

  final PageController pageController;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(height: 50,),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child:Image.asset(
                MetaAssets.logo,
                height: 80,
              ),

        ),
        Expanded(
          child: PageView(
            physics: NeverScrollableScrollPhysics(),
            controller: pageController,
            children: [
              SignInWidget(pageController: pageController),
              SignUpWidget(pageController: pageController),
              ForgotPasswordWidget(
                pageController: pageController,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
