import 'dart:developer';
import 'dart:ui';
import 'dart:math' as math;

import 'package:envo_mobile/modules/auth_module/auth_screens/auth_helper_widgets.dart';
import 'package:envo_mobile/modules/create_post/binding.dart';
import 'package:envo_mobile/modules/create_post/view.dart';
import 'package:envo_mobile/modules/home/controller.dart';
import 'package:envo_mobile/modules/leaderboard_module/view.dart';
import 'package:envo_mobile/utils/helper_widgets.dart';
import 'package:envo_mobile/utils/meta_assets.dart';
import 'package:envo_mobile/utils/meta_colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:get/get.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../utils/custom_painter.dart';
import '../../utils/custom_slider.dart';
import '../posts_module/view.dart';
import '../profile_module/view.dart';
import '../rewards_module/view.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      backgroundColor: Colors.white,
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            heroTag: 'photo',
            backgroundColor: MetaColors.primaryColor,
            onPressed: () {
              Get.to(() => CreatePostView(), binding: CreatePostBinding(false));
            },
            child: Icon(Icons.camera_alt_outlined),
          ),
          SizedBox(
            height: 10,
          ),
          FloatingActionButton(
            heroTag: 'video',
            backgroundColor: MetaColors.primaryColor,
            onPressed: () {
              Get.to(() => CreatePostView(), binding: CreatePostBinding(true));
            },
            child: Icon(Icons.video_call_sharp),
          ),
        ],
      ),
      bottomNavigationBar: ClipRRect(child: CustomBottomNav()),
      body: Obx(
        () {
          return controller.currentIndex.value == 0
              ? Center(
                  child: Container(child: PostsView()),
                )
              : controller.currentIndex.value == 1
                  ? RewardsView()
                  : controller.currentIndex.value == 2
                      ? Center(child: LeaderBoardView())
                      : Center(
                          child: ProfileView(),
                        );
        },
      ),
    );
  }
}

class FootPrintsScreen extends StatefulWidget {
  const FootPrintsScreen({
    super.key,
  });

  @override
  State<FootPrintsScreen> createState() => _FootPrintsScreenState();
}

class _FootPrintsScreenState extends State<FootPrintsScreen> {
  PictureInfo? svg;
  @override
  void initState() {
    getData();
  }

  getData() async {
    final PictureInfo pictureInfo = await vg.loadPicture(
        SvgPicture.asset(
          MetaAssets.activeFeet,
          colorFilter: ColorFilter.mode(Colors.red, BlendMode.src),
        ).bytesLoader,
        null);
    setState(() {
      svg = pictureInfo;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Scaffold(
        appBar: AppBar(),
        body: Center(
          child: svg == null
              ? Loader()
              : Container(
                  child: Stack(
                    children: [
                      CustomPaint(
                        size: MediaQuery.of(context).size,
                        painter: CurvePainter(svg!),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              color: MetaColors.primaryColor),
                          child: Padding(
                            padding: const EdgeInsets.all(18.0),
                            child: Row(
                              children: [
                                Container(
                                  height: 100,
                                  width: 100,
                                  decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Colors.white),
                                  child: Stack(
                                    children: [
                                      Center(
                                        child: SizedBox(
                                          height: 80,
                                          width: 80,
                                          child: CircularProgressIndicator(
                                            color: MetaColors.primaryColor,
                                            value: 0.8,
                                          ),
                                        ),
                                      ),
                                      Center(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              "6",
                                              style: TextStyle(fontSize: 30),
                                            ),
                                            Text(
                                              "Level",
                                              style: TextStyle(
                                                  color: MetaColors
                                                      .secondaryColor),
                                            )
                                          ],
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: SizedBox(
                                    height: 100,
                                    child: VerticalDivider(
                                      thickness: 1,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                                Expanded(
                                    child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                      "Meatless Mondays",
                                      style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.w600,
                                          color: Colors.white),
                                    ),
                                    Text(
                                      "Eliminate meat for a week",
                                      style: TextStyle(
                                          fontSize: 13,
                                          fontWeight: FontWeight.w500,
                                          color: Colors.white),
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0)
                                          .copyWith(left: 0),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Container(
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Text(
                                                "5 / 7 Days",
                                                style: TextStyle(
                                                    fontSize: 10,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                            ),
                                            decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                                color: Colors.white),
                                          ),
                                          Container(
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Row(
                                                children: [
                                                  CircleAvatar(
                                                    radius: 4,
                                                    backgroundImage: AssetImage(
                                                      MetaAssets.logo,
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    width: 5,
                                                  ),
                                                  Text(
                                                    "30",
                                                    style: TextStyle(
                                                        fontSize: 10,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                                color: Colors.white),
                                          ),
                                          Container(
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Text(
                                                "#Food",
                                                style: TextStyle(
                                                    fontSize: 10,
                                                    color:
                                                        MetaColors.primaryColor,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                            ),
                                            decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                                color: Colors.white),
                                          )
                                        ],
                                      ),
                                    )
                                  ],
                                ))
                              ],
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
        ),
      ),
    );
  }
}

class CustomBottomNav extends GetView<HomeController> {
  const CustomBottomNav({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    List<String> icons = [
      MetaAssets.home,
      MetaAssets.market,
      MetaAssets.footprint,
      MetaAssets.profile,
    ];
    return Obx(
      () {
        log(HomeController.to.currentIndex.value.toString());
        return Padding(
          padding: const EdgeInsets.all(18.0),
          child: Container(
            height: 60,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(25),
                color: MetaColors.primaryColor),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: List.generate(
                  icons.length,
                  (index) => InkWell(
                    onTap: () {
                      HomeController.to.currentIndex.value = index;
                    },
                    child: AnimatedContainer(
                      curve: Curves.bounceInOut,
                      duration: Duration(milliseconds: 200),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: SvgPicture.asset(
                          icons[index],
                          height: HomeController.to.currentIndex.value == index
                              ? 25
                              : 18,
                          colorFilter: ColorFilter.mode(
                              HomeController.to.currentIndex.value == index
                                  ? Colors.white
                                  : Colors.white54,
                              BlendMode.srcIn),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
