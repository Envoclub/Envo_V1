import 'package:envo_mobile/modules/tour/controller.dart';
import 'package:get/get.dart';

class TourBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(TourController());
  }
}
