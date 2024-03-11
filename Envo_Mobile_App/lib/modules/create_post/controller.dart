import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:envo_mobile/models/posts.dart';
import 'package:envo_mobile/modules/auth_module/controller.dart';
import 'package:envo_mobile/modules/home/controller.dart';
import 'package:envo_mobile/modules/leaderboard_module/controller.dart';
import 'package:envo_mobile/modules/posts_module/controller.dart';
import 'package:envo_mobile/repositories/post_repository.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:video_player/video_player.dart';

import '../../models/action_model.dart';
import '../../utils/meta_colors.dart';
import '../profile_module/controller.dart';

class CreatePostController extends GetxController {
  CreatePostController(this.pickVideo);
  static CreatePostController get to => Get.find<CreatePostController>();
  PostRepository postRepository = HomeController.to.postRepository;
  ImagePicker picker = ImagePicker();
  final profileController = ProfileController.to;
  bool pickVideo = false;
  Rxn<XFile?> image = Rxn();
  Rxn<bool> loading = Rxn(false);
  Rxn<PostActions?> selectedAction = Rxn();
  List<Action> actions = [
    Action(name: "Plant A tree", id: "1"),
    Action(name: "CarPool", id: "2")
  ];
  Rxn<VideoPlayerController?> controller = Rxn();

  getImage() async {
    try {
      image.value = pickVideo
          ? await picker.pickVideo(
              source: ImageSource.camera, maxDuration: Duration(seconds: 10))
          : await picker.pickImage(source: ImageSource.camera);
      if (image.value != null) {
        await handleImageSelection();
      }
    } catch (e) {
      showSnackBar(e.toString());
    }
  }

  handleImageSelection() async {
    if (image.value == null) {
      showSnackBar("Please select an image or video");
      return;
    }
    selectedAction.value = await getAction();
    if (pickVideo) {
      controller.value = VideoPlayerController.file(File(image.value!.path));

      controller.value?.addListener(() {});
      controller.value?.setLooping(true);
      controller.value?.initialize().then((_) {});
      controller.value?.play();
    }
  }

  Future<PostActions?> getAction() async {
    return await Get.dialog<PostActions>(Material(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                Text(
                  "Which eco-action did you take?",
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 20,
                      fontWeight: FontWeight.w700),
                ),
                Expanded(
                  child: GridView.count(
                    crossAxisCount: 2,
                    children: HomeController.to.actions.value!
                        .map((e) => Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: InkWell(
                                onTap: () {
                                  Get.back(result: e);
                                },
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Container(
                                    width: double.maxFinite,
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      boxShadow: [
                                        BoxShadow(
                                            color: MetaColors.primaryColor
                                                .withOpacity(0.1),
                                            spreadRadius: 5,
                                            offset: Offset(0, 5),
                                            blurRadius: 10)
                                      ],
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          e.image != null && e.image!.isNotEmpty
                                              ? CachedNetworkImage(
                                                  imageUrl: e.image!)
                                              : Icon(
                                                  CupertinoIcons.tree,
                                                  size: 80,
                                                  color: MetaColors
                                                      .secondaryGradient,
                                                ),
                                          SizedBox(
                                            width: 10,
                                          ),
                                          Text(
                                            e.action.toString(),
                                            style: TextStyle(
                                                fontSize: 12,
                                                fontWeight: FontWeight.w700),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ))
                        .toList(),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    ));
  }

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();

    getImage();
  }

  @override
  void dispose() {
    controller.value?.dispose();
    super.dispose();
  }

  @override
  void onClose() {
    // TODO: implement onClose

    controller.value?.dispose();
    super.onClose();
  }

  void handlePost() async {
    try {
      if (image.value == null) {
        showSnackBar("Please select a video or image");
        return;
      }
      if (selectedAction.value == null) {
        showSnackBar("Please select an eco-action");
      }
      loading.value = true;
      await postRepository.createPost(CreatePostModel(
          postUrl: File(image.value!.path),
          description: "",
          action: selectedAction.value!.id!));
      await PostsController.to.getPosts();
      await ProfileController.to.getPosts();
      await LeaderboardController.to.getData();
      
      loading.value = false;

      handleSuccess();
    } catch (e) {
      loading.value = false;
      showSnackBar(e.toString());
    }
  }

  handleSuccess() {
    profileController.getPosts();
    Get.back();
    showSnackBar("Success, Your post will be reviewed and posted shortly",
        isError: false);
  }
}

class Action {
  String name;
  String id;
  Action({required this.name, required this.id});
}
