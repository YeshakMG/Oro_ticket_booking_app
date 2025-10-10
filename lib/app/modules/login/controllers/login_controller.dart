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

      if (rememberMe.value) {
        await box.put("rememberPhone", phone);
        await box.put("rememberPassword", password);
      } else {
        await box.delete("rememberPhone");
        await box.delete("rememberPassword");
      }

      if (kDebugMode) debugPrint("✅ Login successful. Token saved.");
      Get.snackbar("Success", "Login successful");
      Get.offAllNamed(Routes.HOME);
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
}
