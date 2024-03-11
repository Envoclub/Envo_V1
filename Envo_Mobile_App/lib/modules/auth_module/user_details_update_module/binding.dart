import 'package:envo_mobile/modules/auth_module/user_details_update_module/controller.dart';
import 'package:get/get.dart';

class UserDetailsUpdateBinding extends Bindings{
  @override
  void dependencies() {
    // TODO: implement dependencies
    Get.put(UserDetailsController());
  }

}