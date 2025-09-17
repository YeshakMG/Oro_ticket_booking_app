import 'package:get/get.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../auth_service.dart';

class AuthController extends GetxController {
  final AuthService _authService = AuthService();
  final storage = const FlutterSecureStorage();

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
    if (fullName.value.isEmpty ||
        phone.value.isEmpty ||
        email.value.isEmpty ||
        password.value.isEmpty) {
      Get.snackbar("Error", "All fields are required");
      return;
    }

    try {
      isLoading.value = true;

      final response = await _authService.signup(
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
    if (phone.value.isEmpty || password.value.isEmpty) {
      Get.snackbar("Error", "Phone and password are required");
      return;
    }

    try {
      isLoading.value = true;

      final response = await _authService.login(
        phone: phone.value,
        password: password.value,
      );

      // Save token
      await storage.write(key: "token", value: response["token"]);

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
    await storage.delete(key: "token");
    Get.offAllNamed("/login");
  }

  /// Check if token exists
  Future<bool> isLoggedIn() async {
    String? token = await storage.read(key: "token");
    return token != null;
  }
}
