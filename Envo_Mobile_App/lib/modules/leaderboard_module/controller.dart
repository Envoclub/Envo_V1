import 'package:envo_mobile/modules/auth_module/controller.dart';
import 'package:get/get.dart';

import '../../models/leaderboard_model.dart';
import '../../repositories/post_repository.dart';
import '../home/controller.dart';

class LeaderboardController extends GetxController {
  static LeaderboardController to = Get.find<LeaderboardController>();
  PostRepository postRepository = HomeController.to.postRepository;
  Rxn<List<LeaderboardModel>> leadersList = Rxn([]);
  Rxn<bool> loading = Rxn(false);
  Rxn<int> currentRank = Rxn(0);
  Rxn<LeaderboardModel> currentData = Rxn();

  getData() async {
    try {
      loading.value = true;
      leadersList.value = await postRepository.getLeaderBoard();
      currentRank.value = leadersList.value!.indexWhere(
          (element) => element.id == AuthController.to.user.value!.id);
      currentData.value = leadersList.value![currentRank.value!];
      loading.value = false;
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
