import 'package:get/get.dart';

class AuthtabsController extends GetxController {
  // 0 = Login, 1 = SignUp
  var selectedIndex = 0.obs;

  void switchToLogin() {
    selectedIndex.value = 0;
  }

  void switchToSignup() {
    selectedIndex.value = 1;
  }
}
