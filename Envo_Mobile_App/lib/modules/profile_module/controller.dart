import 'package:envo_mobile/modules/auth_module/controller.dart';
import 'package:get/get.dart';

import '../../models/posts.dart';
import '../../models/user_model.dart';
import '../../repositories/post_repository.dart';
import '../../utils/helper_widgets.dart';
import '../home/controller.dart';

class ProfileController extends GetxController {
  static ProfileController get to => Get.find<ProfileController>();
  Rxn<List<Post>> posts = Rxn([]);
  Rxn<UserModel?> get data => AuthController.to.user;
  Rxn<bool> loading = Rxn(false);
  PostRepository postRepository = HomeController.to.postRepository;
  @override
  void onInit() {
    getPosts();
  }

  getPosts() async {
    try {
      loading.value = true;
      posts.value = await postRepository.getMyPosts();
      loading.value = false;
    } catch (e) {
      loading.value = false;
      posts.value = [];
      showSnackBar(e.toString());
    }
  }
}
