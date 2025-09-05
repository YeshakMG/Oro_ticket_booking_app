import 'package:get/get.dart';
import '../auth_service.dart';

class AuthController extends GetxController {
  final AuthService _authService = AuthService();

  // Observables
  var isLogin = true.obs;
  var isLoading = false.obs;

  var fullName = ''.obs;
  var phone = ''.obs;
  var email = ''.obs;
  var password = ''.obs;
  var role_id = 2.obs; // default role_id for customers

  /// Toggle between login/signup
  void toggleAuthMode() {
    isLogin.value = !isLogin.value;
  }

  /// Sign Up API call
  Future<void> signup() async {
    if (fullName.isEmpty || phone.isEmpty || email.isEmpty || password.isEmpty) {
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
    if (phone.isEmpty || password.isEmpty) {
      Get.snackbar("Error", "Phone and password are required");
      return;
    }

    try {
      isLoading.value = true;

      final response = await _authService.login(
        phone: phone.value,
        password: password.value,
      );

      Get.snackbar("Success", "Login successful!");
      // TODO: Save token and navigate to home/tickets screen
      // Example: Get.offAllNamed("/tickets");
    } catch (e) {
      Get.snackbar("Error", e.toString());
    } finally {
      isLoading.value = false;
    }
  }
}
