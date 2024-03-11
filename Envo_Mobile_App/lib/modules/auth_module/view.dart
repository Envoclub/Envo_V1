import 'dart:ui';

import 'package:envo_mobile/modules/auth_module/auth_screens/auth_screens.dart';
import 'package:envo_mobile/modules/auth_module/controller.dart';
import 'package:envo_mobile/modules/home/view.dart';
import 'package:envo_mobile/modules/tour/view.dart';
import 'package:envo_mobile/utils/helper_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:get/get.dart';
import 'package:video_player/video_player.dart';

import '../../utils/meta_assets.dart';
import 'auth_screens/auth_helper_widgets.dart';

class AuthView extends GetView<AuthController> {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Obx(() => controller.loading.value
        ? Scaffold(backgroundColor: Colors.white, body: Loader())
        : controller.isFirstTime.value
            ? WelcomeScreen()
            : controller.user.value != null
                ? controller.surveyComplete.value
                    ? HomeView()
                    : TourView()
                : AuthScreens());
  }
}

class WelcomeScreen extends GetView<AuthController> {
  const WelcomeScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Stack(
          children: [
            DecoratedBox(
                position: DecorationPosition.foreground,
                decoration: BoxDecoration(
                    gradient: RadialGradient(
                        radius: 1.5,
                        colors: [Colors.transparent, Colors.black87])),
                child: SplashVideo()),
            BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 0, sigmaY: 0),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    Expanded(
                        child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                              height: MediaQuery.of(context).size.height * .05),
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
                          //     Text(
                          //       "envo",
                          //       style: TextStyle(
                          //           fontSize: 50,
                          //           fontWeight: FontWeight.w500,
                          //           color: Colors.white),
                          //     )
                          //   ],
                          // ),
                          Image.asset(MetaAssets.envoWhiteLogo),
                          // Padding(
                          //   padding: const EdgeInsets.all(8.0),
                          //   child: Padding(
                          //     padding: const EdgeInsets.all(8.0),
                          //     child: Text(
                          //       "Help Earth, Get Rewards",
                          //       style: TextStyle(
                          //           color: Colors.white.withOpacity(0.7),
                          //           fontWeight: FontWeight.w500,
                          //           fontSize: 13),
                          //     ),
                          //   ),
                          // ),
                          SizedBox(
                              height: MediaQuery.of(context).size.height * .1),
                        ],
                      ),
                    )),
                    CustomButton(
                        handler: () {
                          controller.completeSplash();
                          controller.isFirstTime.value = false;
                        },
                        label: "Let's Start")
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class SplashVideo extends StatefulWidget {
  @override
  _SplashVideoState createState() => _SplashVideoState();
}

class _SplashVideoState extends State<SplashVideo> {
  late VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.asset(MetaAssets.splashVideo);

    _controller.addListener(() {
      setState(() {});
    });
    _controller.setLooping(true);
    _controller.initialize().then((_) => setState(() {}));
    _controller.play();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        child: AspectRatio(
          aspectRatio: MediaQuery.of(context).size.aspectRatio,
          child: Stack(
            alignment: Alignment.bottomCenter,
            children: <Widget>[
              VideoPlayer(_controller),
            ],
          ),
        ),
      ),
    );
  }
}
