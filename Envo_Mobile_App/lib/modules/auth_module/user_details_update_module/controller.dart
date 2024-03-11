import 'package:envo_mobile/modules/auth_module/controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class UserDetailsController extends GetxController {
  static UserDetailsController to = Get.find<UserDetailsController>();
  PageController pageController = PageController();
  final authController = AuthController.to;
  TextEditingController phoneController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController dobCOntroller = TextEditingController();
  final formKey = GlobalKey<FormState>();
  Rxn<XFile?> pickedImage = Rxn();
  ImagePicker imagePicker = ImagePicker();

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
}
