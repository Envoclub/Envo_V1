import 'package:envo_mobile/modules/auth_module/controller.dart';
import 'package:envo_mobile/modules/home/controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../models/posts.dart';
import '../../repositories/post_repository.dart';

class PostsController extends GetxController {
  static PostsController to = Get.find<PostsController>();
  PageController pageController = PageController(viewportFraction: 0.75);
  Rxn<List<Post>> posts = Rxn([]);
  Rxn<bool> loading = Rxn(false);
  PostRepository postRepository = HomeController.to.postRepository;
  @override
  void onInit() {
    getPosts();
  }

  getPosts() async {
    try {
      loading.value = true;
      posts.value = await postRepository.getAllPosts();
      loading.value = false;
    } catch (e) {
      showSnackBar(e.toString());
    }
  }

  likePost(Post post) async {
    try {
      int index = posts.value!.indexWhere((element) => element.pk == post.pk);
      if (posts.value![index].likes?.firstWhereOrNull((element) =>
              element.usernames == AuthController.to.user.value!.username) ==
          null) {
        posts.value![index].likeCount = posts.value![index].likeCount! + 1;
        posts.value![index].likes!
            .add(Like(usernames: AuthController.to.user.value!.username));
      } else {
        posts.value![index].likeCount = posts.value![index].likeCount! - 1;
        posts.value![index].likes!.removeWhere((element) =>
            element.usernames == AuthController.to.user.value!.username);
      }
      List<Post> tempPosts = posts.value!;
      posts.value = [];
      posts.value!.addAll(tempPosts);

      await postRepository.like(post);
    } catch (e) {
      showSnackBar(e.toString());
    }
  }

  unLikePost(Post post) async {
    try {
      await postRepository.unLike(post);
    } catch (e) {
      showSnackBar(e.toString());
    }
  }
}
