import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LoginController extends GetxController {
  final phoneController = TextEditingController();
  final passwordController = TextEditingController();

  RxBool isPasswordHidden = true.obs;
  RxBool rememberMe = false.obs;
  RxBool isLoading = false.obs;

  Future<void> login() async {
    final phone = phoneController.text.trim();
    final password = passwordController.text.trim();

    if (phone.isEmpty || password.isEmpty) {
      Get.snackbar("Error", "Phone and password required");
      return;
    }

    isLoading.value = true;

    try {
      // TODO: Replace with API call
      await Future.delayed(const Duration(seconds: 1));

      Get.snackbar("Success", "Login successful");
      Get.offAllNamed("/tickets"); // 👈 redirect to tickets
    } catch (e) {
      Get.snackbar("Error", "Login failed: $e");
    } finally {
      isLoading.value = false;
    }
  }
}
