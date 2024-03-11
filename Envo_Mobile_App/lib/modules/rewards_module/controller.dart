import 'package:get/get.dart';

import '../../models/rewards_model.dart';
import '../../repositories/post_repository.dart';
import '../../utils/helper_widgets.dart';
import '../auth_module/controller.dart';
import '../home/controller.dart';

class RewardsController extends GetxController {
  static RewardsController to = Get.find<RewardsController>();
  PostRepository postRepository = HomeController.to.postRepository;
  Rxn<List<RewardsModel>> rewardsList = Rxn([]);
  Rxn<bool> loading = Rxn(false);

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

  redeemData(RewardsModel data) async {
    try {
      loading.value = true;
      String message = await postRepository.redeemData(data.id!);
      AuthController.to.refreshUserData();
      loading.value = false;
      Get.back();
      showSnackBar(message, isError: false);
      getData();
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
