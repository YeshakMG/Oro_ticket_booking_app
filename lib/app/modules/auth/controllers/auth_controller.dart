import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import '../auth_service.dart';

class AuthController extends GetxController {
  final formKey = GlobalKey<FormState>();
  final AuthService _authService = Get.find<AuthService>();
  final box = GetStorage();

  // Observables
  var isLogin = true.obs;
  var isLoading = false.obs;

  var fullName = ''.obs;
  var phone = ''.obs;
  var email = ''.obs;
  var password = ''.obs;
  var roleId = 2.obs; // default role_id for customers

  /// Toggle between login/signup
  void toggleAuthMode() {
    isLogin.value = !isLogin.value;
  }

  /// Sign Up API call
  Future<void> signup() async {
    try {
      isLoading.value = true;

      await _authService.signup(
        fullName: fullName.value,
        phone: phone.value,
        email: email.value,
        password: password.value,
        roleId: roleId.value,
      );

      Get.snackbar("Success", "Account created successfully");
      toggleAuthMode(); // switch to login after signup
    } catch (e) {
      Get.snackbar("Error", e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  /// Login API call
  Future<void> login() async {
    try {
      isLoading.value = true;

      final response = await _authService.login(
        phone: phone.value,
        password: password.value,
      );

      // Save token and user data
      final userData = response["customer"];
      box.write("token", response["token"]);
      box.write("fullName", userData["full_name"]);
      box.write("phone", userData["phone"]);
      box.write("email", userData["email"]);
      box.write("roleId", userData["role_id"]);

      Get.snackbar("Success", "Login successful!");
      Get.offAllNamed("/home"); // navigate to home screen
    } catch (e) {
      Get.snackbar("Error", e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  /// Logout
  Future<void> logout() async {
    box.remove("token");
    box.remove("fullName");
    box.remove("phone");
    box.remove("email");
    box.remove("roleId");
    Get.offAllNamed("/login");
  }

  /// Check if token exists
  Future<bool> isLoggedIn() async {
    String? token = box.read("token");
    return token != null;
  }
}
