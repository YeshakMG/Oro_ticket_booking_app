import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:oro_ticket_booking_app/app/modules/auth/auth_service.dart';

class ProfileEditController extends GetxController {
  final AuthService _authService = Get.find<AuthService>();
  final box = Hive.box('appBox');

  // Form controllers
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();
  final currentPasswordController = TextEditingController();
  final newPasswordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  // Observables
  final RxBool isLoading = false.obs;
  final RxBool isPasswordVisible = false.obs;
  final RxBool isNewPasswordVisible = false.obs;
  final RxBool isConfirmPasswordVisible = false.obs;

  @override
  void onInit() {
    super.onInit();
    _loadCurrentUserData();
  }

  void _loadCurrentUserData() {
    final user = box.get("user", defaultValue: {});
    if (user is Map) {
      nameController.text = user["full_name"] ?? "";
      emailController.text = user["email"] ?? "";
      phoneController.text = user["phone"] ?? "";
    }
  }

  void togglePasswordVisibility() {
    isPasswordVisible.value = !isPasswordVisible.value;
  }

  void toggleNewPasswordVisibility() {
    isNewPasswordVisible.value = !isNewPasswordVisible.value;
  }

  void toggleConfirmPasswordVisibility() {
    isConfirmPasswordVisible.value = !isConfirmPasswordVisible.value;
  }

  Future<void> updateProfile() async {
    if (nameController.text.trim().isEmpty) {
      Get.snackbar("Error", "Name is required");
      return;
    }

    if (emailController.text.trim().isEmpty) {
      Get.snackbar("Error", "Email is required");
      return;
    }

    if (phoneController.text.trim().isEmpty) {
      Get.snackbar("Error", "Phone number is required");
      return;
    }

    try {
      isLoading.value = true;

      // TODO: Call API to update profile
      // For now, just update local storage
      final updatedUser = {
        "full_name": nameController.text.trim(),
        "email": emailController.text.trim(),
        "phone": phoneController.text.trim(),
      };

      await box.put("user", updatedUser);

      Get.snackbar("Success", "Profile updated successfully");
      Get.back(); // Go back to settings

    } catch (e) {
      Get.snackbar("Error", "Failed to update profile: $e");
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> changePassword() async {
    if (currentPasswordController.text.isEmpty) {
      Get.snackbar("Error", "Current password is required");
      return;
    }

    if (newPasswordController.text.length < 6) {
      Get.snackbar("Error", "New password must be at least 6 characters");
      return;
    }

    if (newPasswordController.text != confirmPasswordController.text) {
      Get.snackbar("Error", "New passwords do not match");
      return;
    }

    try {
      isLoading.value = true;

      // TODO: Call API to change password
      // For now, just show success
      Get.snackbar("Success", "Password changed successfully");

      // Clear password fields
      currentPasswordController.clear();
      newPasswordController.clear();
      confirmPasswordController.clear();

    } catch (e) {
      Get.snackbar("Error", "Failed to change password: $e");
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onClose() {
    nameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    currentPasswordController.dispose();
    newPasswordController.dispose();
    confirmPasswordController.dispose();
    super.onClose();
  }
}