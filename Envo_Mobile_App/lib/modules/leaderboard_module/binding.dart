import 'package:envo_mobile/modules/leaderboard_module/controller.dart';
import 'package:get/get.dart';

class LeaderboardBinding extends Bindings{
  @override
  void dependencies() {
  Get.put(LeaderboardController());
  }

}