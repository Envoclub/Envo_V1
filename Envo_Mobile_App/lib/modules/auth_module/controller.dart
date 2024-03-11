import 'dart:developer';
import 'dart:io';

import 'package:envo_mobile/modules/home/binding.dart';
import 'package:envo_mobile/modules/tour/binding.dart';
import 'package:envo_mobile/repositories/auth_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import '../../models/user_model.dart';

class AuthController extends GetxController {
  static AuthController get to => Get.find<AuthController>();
  RxBool isFirstTime = false.obs;
  RxBool surveyComplete = false.obs;
  PageController pageController = PageController();
  RxBool loading = false.obs;
  RxBool authLoading = false.obs;
  Rxn<UserModel?> user = Rxn();
  AuthRepository authRepository = AuthRepository();
  FlutterSecureStorage storage = const FlutterSecureStorage(
    aOptions: AndroidOptions(
      encryptedSharedPreferences: true,
    ),
  );
  Rxn<bool> obscurePassword = Rxn(false);
  @override
  void onInit() {
    super.onInit();
    authenticate();
  }

  authenticate() async {
    try {
      loading.value = true;
      isFirstTime.value = !((await storage.read(key: "isFirstTime")) != null);
      surveyComplete.value =
          ((await storage.read(key: "surveyComplete")) != null);

      String? token = await storage.read(key: "accessToken");
    
      log("current access $token refresh");
      if (token != null) {
        UserModel? userModel = await authRepository.getUserDetails();
        user.value = userModel;
     
        // isFirstTime.value = !(user.value?.surveyCompleted ?? false);
        surveyComplete.value = user.value!.surveyCompleted ?? false;
        if (isFirstTime.value) {
         
          loading.value = false;
        }
        if (!surveyComplete.value) {
          TourBinding().dependencies();
        }
        // surveyComplete.value = user.value!.surveyCompleted!;

        HomeBinding().dependencies();
      } else {
        user.value = null;
      }
     
      loading.value = false;
    } catch (e) {
      loading.value = false;
      showSnackBar(e.toString());
    }
  }

  signIn(String email, String password) async {
    try {
      authLoading.value = true;
      await authRepository.login(email, password);
      authLoading.value = false;
      authenticate();
    } catch (e) {
      authLoading.value = false;
      showSnackBar(e.toString());
    }
  }

  logout() async {
    try {
      authLoading.value = true;
      await authRepository.logout();
      authLoading.value = false;
      await authenticate();
    } catch (e) {
      authLoading.value = false;
      showSnackBar(e.toString());
    }
  }

  completeSplash() async {
    try {
      await storage.write(key: "isFirstTime", value: "done");
      await authenticate();
    } catch (e) {
      showSnackBar(e.toString());
    }
  }

  completeSurvey(double value) async {
    try {
      user.value = await authRepository.updateUserCo2(value, user.value!.id!);

      await authenticate();
    } catch (e) {
      showSnackBar(e.toString());
    }
  }

  refreshUserData() async {
    try {
      UserModel? userModel = await authRepository.getUserDetails();
      user.value = userModel;
      HomeBinding().dependencies();
    } catch (e) {
      showSnackBar(e.toString());
    }
  }

  updateUserData(String? bio, XFile? file) async {
    try {
      bool? done = await authRepository.updateUserDetails(
          user.value!.id.toString(), bio, File(file!.path));
      if (done!) {
        refreshUserData();
        return done;
      }
    } catch (e) {
      showSnackBar(e.toString());
    }
  }

  updatePassword(String password) async {
    try {
      bool? done = await authRepository.updatePassword(password);
      if (done!) {
        refreshUserData();
        return done;
      }
    } catch (e) {
      showSnackBar(e.toString());
    }
  }
}

showSnackBar(String message, {bool isError = true}) {
  Get.showSnackbar(GetSnackBar(
    duration: Duration(seconds: 3),
    backgroundColor: isError ? Colors.red : Colors.green,
    title: isError ? "Oops!" : "Success",
    message: message,
  ));
}