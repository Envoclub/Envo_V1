import 'package:envo_mobile/modules/rewards_module/controller.dart';
import 'package:get/get.dart';

class RewardsBiding extends Bindings{
  @override
  void dependencies() {
    // TODO: implement dependencies
    Get.put(RewardsController());
  }

}