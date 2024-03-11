import 'package:envo_mobile/modules/auth_module/controller.dart';
import 'package:envo_mobile/modules/profile_module/controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class SettingsController extends GetxController {
  Rxn<bool> obscurePassword = Rxn(false);

  ProfileController get profileController => ProfileController.to;
  AuthController get authController => AuthController.to;
  Rxn<bool> isEditing = Rxn(false);
  Rxn<bool> isReset = Rxn(false);
  // TextEditingController nameController = TextEditingController();
  TextEditingController bioCOntroller = TextEditingController();
  TextEditingController passwordCOntroller = TextEditingController();
  TextEditingController resetpasswordCOntroller = TextEditingController();
  final formKey = GlobalKey<FormState>();
  Rxn<XFile?> pickedImage = Rxn();
  ImagePicker imagePicker = ImagePicker();
  Rxn<bool> loading = Rxn(false);
  pickImage() async {
    try {
      XFile? image = await imagePicker.pickImage(source: ImageSource.gallery);
      if (image != null) {
        pickedImage.value = image;
      } else {
        showSnackBar("Please Pick a valid Image");
      }
    } catch (e) {
      showSnackBar(e.toString());
    }
  }

  void updateData() async {
    if (!formKey.currentState!.validate()) {
      return;
    }
    if (pickedImage.value == null) {
      showSnackBar("Please Pick a valid Image");
      return;
    }

    try {
      loading.value = true;
      bool? value = await authController.updateUserData(
          bioCOntroller.text.trim(), pickedImage.value);
      loading.value = false;

      if (value!) {
        isEditing.value = false;
        showSnackBar("User Details updated successfully", isError: false);
      }
    } catch (e) {
      loading.value = false;
      showSnackBar(e.toString());
    }
  }

  void resetPassword() async {
    if (!formKey.currentState!.validate()) {
      return;
    }

    try {
      loading.value = true;
      bool? value = await authController.updatePassword(
        passwordCOntroller.text.trim(),
      );
      loading.value = false;

      if (value!) {
        isEditing.value = false;
        isReset.value = false;
        showSnackBar("Password updated successfully", isError: false);
      }
    } catch (e) {
      loading.value = false;
      showSnackBar(e.toString());
    }
  }
}
