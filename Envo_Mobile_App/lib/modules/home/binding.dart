import 'package:envo_mobile/modules/home/controller.dart';
import 'package:envo_mobile/modules/leaderboard_module/binding.dart';
import 'package:envo_mobile/modules/posts_module/bindings.dart';
import 'package:envo_mobile/modules/profile_module/binding.dart';
import 'package:envo_mobile/modules/rewards_module/bindings.dart';
import 'package:get/get.dart';

class HomeBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(HomeController());
    PostBindings().dependencies();
    ProfileBinding().dependencies();
    LeaderboardBinding().dependencies();
    RewardsBiding().dependencies();
  }
}
