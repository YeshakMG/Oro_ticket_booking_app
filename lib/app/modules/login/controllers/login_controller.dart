import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../../auth/auth_service.dart';

class LoginController extends GetxController {
  final phoneController = TextEditingController();
  final passwordController = TextEditingController();

  RxBool isPasswordHidden = true.obs;
  RxBool isLoading = false.obs;
  RxBool rememberMe = false.obs;

  late final AuthService _authService;

  @override
  void onInit() {
    super.onInit();
    _authService = AuthService(); // safe after dotenv loaded in main()
  }

  Future<void> login() async {
    final phone = phoneController.text.trim();
    final password = passwordController.text.trim();

    if (phone.isEmpty || password.isEmpty) {
      Get.snackbar("Error", "Phone and password are required");
      return;
    }

    try {
      isLoading.value = true;

      // Call login API
      final result = await _authService.login(phone: phone, password: password);

      // Save token and user info to Hive
      final box = Hive.box('appBox');
      await box.put("token", result['token']);
      await box.put("user", result['user']); // e.g., { "name": "Yeshak Mesfin", "phone": "0912345678" }

      Get.snackbar("Success", "Login successful");
      Get.offAllNamed("/home"); // navigate to Home
    } catch (e) {
      Get.snackbar("Error", e.toString());
    } finally {
      isLoading.value = false;
    }
  }
}
