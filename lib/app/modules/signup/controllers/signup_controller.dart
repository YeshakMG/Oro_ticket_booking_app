import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';

class SignUpController extends GetxController {
  final fullNameController = TextEditingController();
  final phoneController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  RxBool isPasswordHidden = true.obs;
  RxBool isLoading = false.obs;

  Future<void> register() async {
    final fullName = fullNameController.text.trim();
    final phone = phoneController.text.trim();
    final email = emailController.text.trim();
    final password = passwordController.text.trim();

    if (fullName.isEmpty || phone.isEmpty || email.isEmpty || password.isEmpty) {
      Get.snackbar("Error", "All fields are required");
      return;
    }

    try {
      isLoading.value = true;

      // Simulate API call
      await Future.delayed(const Duration(seconds: 1));

      Get.snackbar("Success", "Account created successfully");
      Get.offAllNamed("/login"); // Navigate to login page after signup
    } catch (e) {
      Get.snackbar("Error", "Registration failed: $e");
    } finally {
      isLoading.value = false;
    }
  }
}
