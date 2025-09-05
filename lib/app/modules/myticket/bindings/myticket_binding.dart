import 'package:get/get.dart';

import '../controllers/myticket_controller.dart';

class MyticketBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<MyticketController>(
      () => MyticketController(),
    );
  }
}
