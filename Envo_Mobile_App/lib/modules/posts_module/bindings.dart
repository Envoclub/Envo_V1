import 'package:envo_mobile/modules/posts_module/controller.dart';
import 'package:envo_mobile/repositories/auth_repository.dart';
import 'package:get/get.dart';

class PostBindings extends Bindings {
  @override
  void dependencies() {
    // TODO: implement dependencies
    Get.put(PostsController());
  }
}
