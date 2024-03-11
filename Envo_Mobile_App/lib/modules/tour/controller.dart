import 'dart:developer';

import 'package:envo_mobile/models/survey_model.dart';
import 'package:envo_mobile/modules/auth_module/controller.dart';
import 'package:envo_mobile/utils/meta_assets.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../models/tour_page_model.dart';

class TourController extends GetxController {
  static TourController to = Get.find<TourController>();
  PageController pageController = PageController();
  Rxn<double> co2EValue = Rxn(0.0);
  Rxn<bool> loading = Rxn(false);
  Rxn<List<TourPage>> tourPages = Rxn([
    TourPage(
        imageUrl: MetaAssets.carImage,
        suffix: "Everyday I:",
        survey: Rxn(Survey(
            question: "How do you get around?",
            selectionIndex: [0],
            multiChoice: false,
            emmissions: [
              0.7272,
              0,
              0.45,
            ],
            options: [
              "Use a car",
              "Bike or walk",
              "Use public transportation"
            ])),
        title: "Let's start with Mobility 🚗"),
    TourPage(
        imageUrl: MetaAssets.airplaneImage,
        survey: Rxn(Survey(
            multiChoice: false,
            emmissions: [
              0.87,
              1.65,
              5.28,
            ],
            question: "How many flights approximately do you take in a year?",
            selectionIndex: [0],
            options: ["0-5", "5-10", "10+."])),
        title: "Flights ✈"),
    TourPage(
        imageUrl: MetaAssets.dietImage,
        survey: Rxn(Survey(
            multiChoice: false,
            emmissions: [4.5, 3.375, 2.5, 1.7],
            question: "How often do you include meat in your diet?",
            selectionIndex: [0],
            options: [
              "I eat meat every day",
              "I eat meat a few times a week",
              "I am a vegetarian",
              "I am vegan (excludes all animal products)"
            ])),
        title: "Diet 🍞"),
    TourPage(
        imageUrl: MetaAssets.energyImage,
        survey: Rxn(Survey(
            multiChoice: true,
            emmissions: [.53, .78, 0.45, 1.7, 0.18],
            question: "What type of energy sources do you use at home?",
            selectionIndex: [0],
            options: [
              "Electricity (from the grid)",
              "Natural Gas",
              "Renewable/Green Energy",
              "Other ( Solar )"
            ])),
        title: "Energy 🏠"),
    // TourPage(
    //     imageUrl: MetaAssets.tourOne,
    //     survey: Rxn(Survey(
    //         multiChoice: true,
    //         emmissions: [0, 0, 0, 0],
    //         question: "How do you typically handle waste disposal?",
    //         selectionIndex: [0],
    //         options: [
    //           "Recycling",
    //           "Composting",
    //           "Landfill",
    //           "My waste disposal service takes care of this"
    //         ])),
    //     title: "Waste Disposal ♻️"),
  ]);
  void completeSurvey() async {
    loading.value = true;
    await AuthController.to.completeSurvey(co2EValue.value!);
    loading.value = false;
  }

  void calculateData() {
    double co2E = 0;
    tourPages.value!.forEach((question) {
      double questionValue = 0;
      question.survey.value!.selectionIndex.forEach((element) {
        questionValue += question.survey.value!.emmissions[element];
      });
      co2E += (questionValue / question.survey.value!.selectionIndex.length);
    });
    co2EValue.value = co2E;
  }

  void onChanged(int? value) {}

  void handleNext(int index) {
    if (tourPages.value![index].survey.value!.selectionIndex.isEmpty) {
      showSnackBar("Please select an option");
      return;
    }

    if (pageController.page == tourPages.value!.length - 1) {
      AuthController.to.completeSplash();
    } else {
      pageController.nextPage(
          duration: Duration(milliseconds: 500), curve: Curves.easeIn);
    }
  }
}
