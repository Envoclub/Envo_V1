import 'package:envo_mobile/repositories/post_repository.dart';
import 'package:get/get.dart';

import '../../models/action_model.dart';
import '../auth_module/controller.dart';

class HomeController extends GetxController {
  static HomeController to = Get.find<HomeController>();
  Rxn<int> currentIndex = Rxn(0);
  Rxn<List<PostActions>> actions = Rxn([]);
  PostRepository postRepository =
      PostRepository(AuthController.to.authRepository);

  getPostActions() async {
    try {
      actions.value = await postRepository.getAllPostActions();
    } catch (e) {
      showSnackBar(e.toString());
    }
  }
  @override 
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    getPostActions();
  }
}
