import 'package:get/get.dart';

class AuthtabsController extends GetxController {
  RxInt selectedTab = 0.obs; // 0 = Login, 1 = Sign Up

  void changeTab(int index) {
    selectedTab.value = index;
  }
}
