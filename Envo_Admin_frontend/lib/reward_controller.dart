import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import '../../models/rewards_model.dart';
import '../../repositories/post_repository.dart';
import '../../utils/helper_widgets.dart';

///`rewards_controller.dart` documentation
///This file contains the implementation of the `RewardsController` class, which is responsible for managing rewards
///and related functionalities in the Envo Mobile application.
class RewardsController extends GetxController {
  RewardsController(this.postRepository);
  static RewardsController to = Get.find<RewardsController>();
  PostRepository postRepository;
  Rxn<List<RewardsModel>> rewardsList = Rxn([]);
  Rxn<bool> loading = Rxn(false);
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController rewardsController = TextEditingController();
  ImagePicker imagePicker = ImagePicker();
  Rxn<XFile?> image = Rxn();
  final formKey = GlobalKey<FormState>();
  getData() async {
    try {
      loading.value = true;
      rewardsList.value = await postRepository.getRewardsList();

      loading.value = false;
    } catch (e) {
      loading.value = false;
      showSnackBar(e.toString());
    }
  }

  selectImage() async {
    try {
      image.value = await imagePicker.pickImage(source: ImageSource.gallery);
    } catch (e) {
      showSnackBar(e.toString());
    }
  }

  addReward(int companyId) async {
    try {
      if (formKey.currentState!.validate()) {
        if (image.value == null) {
          showSnackBar("Please Select a Banner");
          return;
        }
        Uint8List data= (await image.value!.readAsBytes());

        loading.value = true;
        RewardsModel rewardsModel = RewardsModel(
            title: titleController.text,
            description: descriptionController.text,
            coinrequired: int.parse(rewardsController.text.trim()),
            );
        var done = await postRepository.createReward(rewardsModel, companyId,data,image.value!.name);
        
        await getData();


        loading.value = false;
        return done;
      }
    } catch (e) {
      loading.value = false;
      showSnackBar(e.toString());
    }
  }

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    getData();
  }
}
