import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:get_storage/get_storage.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'package:oro_ticket_booking_app/app/modules/auth/auth_service.dart';
import 'package:oro_ticket_booking_app/app/routes/app_pages.dart';

class LoginController extends GetxController {
  // Read baseUrl from .env
  final String baseUrl = dotenv.env['API_BASE_URL'] ?? "";
  final AuthService _authService = Get.find<AuthService>();

  final formKey = GlobalKey<FormState>();
  final phoneController = TextEditingController();
  final passwordController = TextEditingController();

  final RxBool isPasswordHidden = true.obs;
  final RxBool isLoading = false.obs;
  final RxBool rememberMe = false.obs;

  @override
  void onInit() {
    super.onInit();
  }

  String _formatPhone(String phone) {
    phone = phone.trim();
    if (phone.startsWith("09")) {
      return "+251${phone.substring(1)}";
    }
    return phone;
  }

  void togglePasswordVisibility() {
    isPasswordHidden.value = !isPasswordHidden.value;
  }

  Future<void> login() async {
    final phone = _formatPhone(phoneController.text);
    final password = passwordController.text.trim();

    if (phone.isEmpty || password.isEmpty) {
      Get.snackbar("Error", "Please enter phone and password");
      return;
    }

    try {
      isLoading.value = true;

      final result = await _authService.login(phone: phone, password: password);

      final box = Hive.box('appBox');
      final getStorage = GetStorage();
      await box.put("token", result['token']);
      if (result.containsKey('customer')) {
        final customer = result['customer'];
        await box.put("user", customer);
        // Also save to GetStorage for home controller
        await getStorage.write("fullName", customer['full_name']);
        await getStorage.write("phone", customer['phone']);
        await getStorage.write("email", customer['email']);
      }

      // Note: Removed plaintext password storage for security
      // Only store phone number for convenience, password must be re-entered
      if (rememberMe.value) {
        await box.put("rememberPhone", phone);
      } else {
        await box.delete("rememberPhone");
      }

      if (kDebugMode) debugPrint("✅ Login successful. Token saved.");
      Get.snackbar("Success", "Login successful");
      Get.offAllNamed(Routes.home);
    } catch (e) {
      if (kDebugMode) debugPrint("💥 Exception: $e");
      Get.snackbar("Error", e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onClose() {
    phoneController.dispose();
    passwordController.dispose();
    super.onClose();
  }

  /// Enhanced input validation
  String? validatePhone(String? value) {
    if (value == null || value.isEmpty) {
      return 'Phone number is required';
    }

    // Remove all spaces and non-numeric characters except +
    String cleanValue = value.replaceAll(RegExp(r'[^\d+]'), '');

    // Check length constraints
    if (cleanValue.length < 9 || cleanValue.length > 13) {
      return 'Phone number must be 9-13 digits';
    }

    // Ethiopian phone number validation with specific length limits
    // Format 1: +251XXXXXXXXX (13 chars: +251 + 10 digits)
    // Format 2: 0XXXXXXXXX (10 chars: 0 + 9 digits)
    // Format 3: XXXXXXXXX (9 chars: 9 digits starting with 9 or 7)
    final phoneRegex = RegExp(r'^(\+251[9|7][0-9]{8}|0[9|7][0-9]{8}|[9|7][0-9]{8})$');

    if (!phoneRegex.hasMatch(cleanValue)) {
      return 'Enter valid Ethiopian number: +251XXXXXXXXX, 0XXXXXXXXX, or XXXXXXXXX';
    }

    return null;
  }

  String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password is required';
    }
    if (value.length < 6) {
      return 'Password must be at least 6 characters';
    }
    return null;
  }
}
