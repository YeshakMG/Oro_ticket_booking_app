import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../../auth/authtabs/authtabs_controller.dart';

class SignUpController extends GetxController {
  final formKey = GlobalKey<FormState>();
  // Controllers
  final fullNameController = TextEditingController();
  final phoneController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();


  // Observables
  var isPasswordHidden = true.obs;
  var isLoading = false.obs;

  // Cached controller for performance and maintainability
  late final AuthtabsController _authTabsController = Get.find<AuthtabsController>();

  // -------------------------
  // 🔹 Field Validation
  // -------------------------
  String? validateFields() {
    final fullName = fullNameController.text.trim();
    final phone = phoneController.text.trim();
    final email = emailController.text.trim();
    final password = passwordController.text.trim();

    if (fullName.isEmpty || fullName.length < 3) {
      return "Full name must be at least 3 characters";
    }

    final phonePattern = RegExp(r'^(?:\251\d{8}|09\d{8})$');
    if (!phonePattern.hasMatch(phone)) {
      return "Enter a valid Ethiopian phone number (+2519xxxxxxx or 09xxxxxxx)";
    }

    final emailPattern = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailPattern.hasMatch(email)) {
      return "Enter a valid email address";
    }

    if (password.length < 6) {
      return "Password must be at least 6 characters long";
    }

    return null; // No errors
  }

  // -------------------------
  // 🔹 Format phone number
  // -------------------------
  String formatPhone(String phone) {
    phone = phone.trim();
    if (phone.startsWith("09")) {
      return "+251${phone.substring(1)}"; // Convert 09xxxxxxx → +2519xxxxxxx
    }
    return phone;
  }

  // -------------------------
  // 🔹 Helper method for switching to login tab
  // -------------------------
  void _switchToLogin() {
    try {
      _authTabsController.switchToLogin();
      debugPrint("Successfully switched to login tab"); // Optional logging for debugging
    } catch (e) {
      debugPrint("Error switching to login tab: $e");
      Get.snackbar(
        "Navigation Error",
        "Unable to switch to login. Please try again.",
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  // -------------------------
  // 🔹 Register User
  // -------------------------
  Future<void> register() async {
    try {
      isLoading.value = true;
      final baseUrl = dotenv.env["API_BASE_URL"] ?? "";
      final url = Uri.parse("$baseUrl/customers");

      final formattedPhone = formatPhone(phoneController.text);

      final requestBody = {
        "full_name": fullNameController.text.trim(),
        "email": emailController.text.trim(),
        "phone": formattedPhone,
        "role_id": "8f07f450-2acf-415f-b071-f46b532a079f",
        "password": passwordController.text.trim(),
      };

      debugPrint("Request Body: $requestBody"); // Log the request

      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(requestBody),
      );

      debugPrint("HTTP Status: ${response.statusCode}");
      debugPrint("Response Body: ${response.body}");

      if (response.statusCode == 201 || response.statusCode == 200) {
        Get.snackbar(
          "Success",
          "Account created successfully",
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );

        // Clear form
        fullNameController.clear();
        phoneController.clear();
        emailController.clear();
        passwordController.clear();

        // Switch to Login tab using helper method
        _switchToLogin();
      } else {
        String backendMessage = "Failed to create account";
        try {
          final jsonBody = jsonDecode(response.body);
          if (jsonBody is Map && jsonBody.containsKey("message")) {
            backendMessage = jsonBody["message"];
          }
        } catch (e) {
          debugPrint("Error parsing backend response: $e");
        }

        if (response.statusCode == 409) {
          backendMessage = backendMessage.isNotEmpty
              ? backendMessage
              : "This account already exists. Please log in.";

          Get.snackbar(
            "Already Registered",
            backendMessage,
            backgroundColor: Colors.orange,
            colorText: Colors.white,
          );

          // Switch to Login tab using helper method
          _switchToLogin();
        } else {
          Get.snackbar(
            "Error",
            backendMessage,
            backgroundColor: Colors.red,
            colorText: Colors.white,
          );
        }
      }
    } catch (e) {
      debugPrint("Network or unexpected error: $e");
      Get.snackbar(
        "Error",
        "Something went wrong: $e",
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }
}
