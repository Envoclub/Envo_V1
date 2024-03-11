import 'dart:developer';
import 'dart:ui';

import 'package:envo_mobile/modules/auth_module/auth_screens/auth_helper_widgets.dart';
import 'package:envo_mobile/modules/tour/controller.dart';
import 'package:envo_mobile/utils/meta_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:video_player/video_player.dart';

import '../../utils/meta_assets.dart';

class TourView extends StatefulWidget {
  @override
  State<TourView> createState() => _TourViewState();
}

class _TourViewState extends State<TourView> {
  bool start = false;
  bool end = false;
  @override
  Widget build(BuildContext context) {
    TourController controller = TourController.to;
    return Scaffold(
      body: !start
          ? Scaffold(
              appBar: AppBar(),
              body: Stack(
                children: [
                  Container(
                    width: double.maxFinite,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  "Welcome to the Envo Club 😊",
                                  style: TextStyle(
                                      fontSize: 30,
                                      fontWeight: FontWeight.w700),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(18.0),
                                child: Text(
                                  "We'd like to ask you a few questions to help us better understand your average yearly carbon footprint!",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontSize: 18,
                                      color: MetaColors.tertiaryTextColor),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Stack(
                          alignment: Alignment.bottomCenter,
                          children: [
                            Image.asset(MetaAssets.surveyImageOne),
                            CustomButton(
                                handler: () {
                                  setState(() {
                                    start = true;
                                  });
                                },
                                label: "Let's get Started")
                          ],
                        )
                      ],
                    ),
                  )
                ],
              ))
          : end
              ? Scaffold(
                  appBar: AppBar(),
                  body: Stack(
                    children: [
                      Container(
                        width: double.maxFinite,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    "Thanks for the info! 😃",
                                    style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.w700),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(18.0),
                                  child: Text(
                                    "Your total avg emissions are approximately",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        fontSize: 18,
                                        color: MetaColors.tertiaryTextColor),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(18.0),
                                  child: Obx(
                                    () => Text(
                                      "${(controller.co2EValue.value! * 1000).toStringAsFixed(2)} kgCo2",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          fontSize: 30,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.green),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            Expanded(
                              child: Image.asset(MetaAssets.surveyImageTwo),
                            ),
                            Stack(
                              alignment: Alignment.bottomCenter,
                              children: [
                                CustomButton(
                                    loading: controller.loading.value,
                                    handler: () {
                                      controller.completeSurvey();
                                    },
                                    label: "Continue")
                              ],
                            )
                          ],
                        ),
                      )
                    ],
                  ))
              : Obx(() => PageView.builder(
                  controller: controller.pageController,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: controller.tourPages.value!.length,
                  itemBuilder: (context, pageIndex) {
                    return Scaffold(
                      appBar: AppBar(
                        leading: IconButton(
                          icon: Icon(
                            Icons.arrow_back,
                            color: Colors.black,
                          ),
                          onPressed: () {
                            if (pageIndex == 0) {
                              setState(() {
                                start = false;
                              });
                            }
                            controller.pageController.previousPage(
                                duration: Duration(milliseconds: 400),
                                curve: Curves.easeIn);
                          },
                        ),
                      ),
                      body: Container(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            children: [
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.all(18.0),
                                  child: Image.asset(controller
                                      .tourPages.value![pageIndex].imageUrl),
                                ),
                              ),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(18.0)
                                        .copyWith(bottom: 30),
                                    child: Text(
                                      controller
                                          .tourPages.value![pageIndex].title,
                                      style: TextStyle(
                                          fontSize: 25,
                                          fontWeight: FontWeight.w600),
                                    ),
                                  ),
                                  Obx(
                                    () => Align(
                                      alignment: Alignment.centerLeft,
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0)
                                            .copyWith(bottom: 20),
                                        child: Text(
                                          controller
                                              .tourPages
                                              .value![pageIndex]
                                              .survey
                                              .value!
                                              .question,
                                          style: TextStyle(
                                              fontSize: 20,
                                              fontWeight: FontWeight.w600),
                                        ),
                                      ),
                                    ),
                                  ),
                                  if (controller.tourPages.value![pageIndex]
                                          .suffix !=
                                      null)
                                    Padding(
                                      padding: const EdgeInsets.all(8.0)
                                          .copyWith(left: 16),
                                      child: Align(
                                        alignment: Alignment.centerLeft,
                                        child: Text(
                                          controller.tourPages
                                              .value![pageIndex].suffix!,
                                          style: TextStyle(fontSize: 18),
                                        ),
                                      ),
                                    ),
                                  Obx(
                                    () => Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: List.generate(
                                            controller
                                                .tourPages
                                                .value![pageIndex]
                                                .survey
                                                .value!
                                                .options
                                                .length,
                                            (index) => InkWell(
                                                  onTap: () {
                                                    if (!controller
                                                        .tourPages
                                                        .value![pageIndex]
                                                        .survey
                                                        .value!
                                                        .selectionIndex
                                                        .contains(index)) {
                                                      if (controller
                                                          .tourPages
                                                          .value![pageIndex]
                                                          .survey
                                                          .value!
                                                          .multiChoice) {
                                                        controller
                                                            .tourPages
                                                            .value![pageIndex]
                                                            .survey
                                                            .value!
                                                            .selectionIndex
                                                            .add(index);
                                                      } else {
                                                        controller
                                                            .tourPages
                                                            .value![pageIndex]
                                                            .survey
                                                            .value!
                                                            .selectionIndex = [
                                                          index
                                                        ];
                                                      }
                                                    } else {
                                                      controller
                                                          .tourPages
                                                          .value![pageIndex]
                                                          .survey
                                                          .value!
                                                          .selectionIndex
                                                          .remove(index);
                                                      log(controller
                                                          .tourPages
                                                          .value![pageIndex]
                                                          .survey
                                                          .value!
                                                          .selectionIndex
                                                          .toString());
                                                    }
                                                    setState(() {});
                                                  },
                                                  child: Row(
                                                    children: [
                                                      Checkbox(
                                                          value: controller
                                                              .tourPages
                                                              .value![
                                                                  pageIndex]
                                                              .survey
                                                              .value!
                                                              .selectionIndex
                                                              .contains(
                                                                  index),
                                                          onChanged: (value) {
                                                            if (value!) {
                                                              if (controller
                                                                  .tourPages
                                                                  .value![
                                                                      pageIndex]
                                                                  .survey
                                                                  .value!
                                                                  .multiChoice) {
                                                                controller
                                                                    .tourPages
                                                                    .value![
                                                                        pageIndex]
                                                                    .survey
                                                                    .value!
                                                                    .selectionIndex
                                                                    .add(
                                                                        index);
                                                              } else {
                                                                controller
                                                                    .tourPages
                                                                    .value![
                                                                        pageIndex]
                                                                    .survey
                                                                    .value!
                                                                    .selectionIndex = [
                                                                  index
                                                                ];
                                                              }
                                                            } else {
                                                              controller
                                                                  .tourPages
                                                                  .value![
                                                                      pageIndex]
                                                                  .survey
                                                                  .value!
                                                                  .selectionIndex
                                                                  .remove(
                                                                      index);
                                                              log(controller
                                                                  .tourPages
                                                                  .value![
                                                                      pageIndex]
                                                                  .survey
                                                                  .value!
                                                                  .selectionIndex
                                                                  .toString());
                                                            }
                                                            setState(() {});
                                                          }),
                                                      Expanded(
                                                        child: Text(
                                                          controller
                                                              .tourPages
                                                              .value![
                                                                  pageIndex]
                                                              .survey
                                                              .value!
                                                              .options[index],
                                                          style: TextStyle(
                                                              fontSize: 18),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ))),
                                  )
                                ],
                              ),
                              CustomButton(
                                  handler: pageIndex ==
                                          controller.tourPages.value!.length - 1
                                      ? () {
                                          setState(() {
                                            end = true;
                                          });
                                          controller.calculateData();
                                        }
                                      : () {
                                          controller.handleNext(pageIndex);
                                        },
                                  label: "Next")
                            ],
                          ),
                        ),
                      ),
                    );
                  })),
    );
  }
}
