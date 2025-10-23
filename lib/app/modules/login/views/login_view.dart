import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:oro_ticket_booking_app/core/constants/typography.dart';
import '../../login/controllers/login_controller.dart';

class LoginView extends GetView<LoginController> {
  const LoginView({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: Stack(
        children: [
          /// Top banner image
          SizedBox(
            height: size.height * 0.35,
            width: double.infinity,
            child: Image.asset(
              "assets/images/banner.jpg", // replace with your image
              fit: BoxFit.cover,
            ),
          ),
          Container(
            height: size.height * 0.4,
            width: double.infinity,
            color: Colors.black.withValues(alpha: 0.3),
          ),

          /// Scrollable content
          SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(height: size.height * 0.09),

                /// Logo at top center
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 30),
                  child: Align(
                    alignment: Alignment.topLeft,
                    child: Image.asset("assets/logo/OTA_logo.png", height: 70),
                  ),
                ),
                const SizedBox(height: 10),

                /// Title text
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 30),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Get Started now",
                        style: AppTextStyles.heading1.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 26,
                        ),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        "Create an account or log in to explore about our app",
                        style: AppTextStyles.caption.copyWith(
                          color: Colors.white.withValues(alpha: 0.9),
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 20),

                /// Login Card filling bottom section
                Container(
                  width: double.infinity,
                  height: size.height * 0.70,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30),
                      topRight: Radius.circular(30),
                    ),
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 20,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      /// Tabs
                      Container(
                        decoration: BoxDecoration(
                          color: const Color(0xFFF5F6F9),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 12,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(10),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withValues(alpha: 0.05),
                                      blurRadius: 4,
                                      offset: const Offset(0, 2),
                                    ),
                                  ],
                                ),
                                child: Center(
                                  child: Text(
                                    "Log In",
                                    style: AppTextStyles.buttonMedium,
                                  ),
                                ),
                              ),
                            ),
                            Expanded(
                              child: GestureDetector(
                                onTap: () => Get.offNamed('/signup'),
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 12,
                                  ),
                                  child: Center(
                                    child: Text(
                                      "Sign Up",
                                      style: AppTextStyles.buttonMedium
                                          .copyWith(color: Colors.grey[600]),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 25),

                      /// Login Form
                      Expanded(
                        child: SingleChildScrollView(
                          child: _buildLoginForm(controller),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// ------------------ LOGIN FORM ------------------
  Widget _buildLoginForm(LoginController loginController) {
    return Form(
      key: loginController.formKey,
      child: Column(
        children: [
          // Phone number
          TextFormField(
            controller: controller.phoneController,
            keyboardType: TextInputType.phone,
            maxLength: 13,
            validator: controller.validatePhone,
            decoration: InputDecoration(
              labelText: "Phone Number",
              labelStyle: AppTextStyles.caption3.copyWith(color: Colors.grey),
              hintText: "9xxxxxxxx or +2519xxxxxxxxx",
              hintStyle: AppTextStyles.caption3.copyWith(color: Colors.grey),
              prefixIcon: const Icon(Icons.phone, color: Colors.grey),
              // Removed prefixStyle to allow flexible input
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: Color(0xFFEDF1F3)),
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 14,
              ),
              counterText: "", // Hide character counter
            ),
          ),
          const SizedBox(height: 20),

          // Password
          Obx(
            () => TextFormField(
              controller: loginController.passwordController,
              obscureText: loginController.isPasswordHidden.value,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Password is required';
                }
                if (value.length < 6) {
                  return 'Password must be at least 6 characters';
                }
                return null;
              },
              decoration: InputDecoration(
                labelText: "Password",
                labelStyle: AppTextStyles.caption3.copyWith(color: Colors.grey),
                prefixIcon: const Icon(Icons.lock, color: Colors.grey),
                suffixIcon: IconButton(
                  icon: Icon(
                    loginController.isPasswordHidden.value
                        ? Icons.visibility_off
                        : Icons.visibility,
                    color: Colors.grey,
                  ),
                  onPressed: loginController.togglePasswordVisibility,
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: Color(0xFFEDF1F3)),
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: Colors.green),
                ),
              ),
            ),
          ),

          const SizedBox(height: 10),

          // Remember me & Forgot Password
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Obx(
                    () => Checkbox(
                      value: loginController.rememberMe.value,
                      activeColor: Colors.green,
                      onChanged: (val) =>
                          loginController.rememberMe.value = val ?? false,
                    ),
                  ),
                  Text(
                    "Remember me",
                    style: AppTextStyles.caption3.copyWith(
                      color: Colors.black87,
                    ),
                  ),
                ],
              ),
              TextButton(
                onPressed: () => Get.toNamed('/forgot-password'),
                child: Text(
                  "Forgot Password?",
                  style: AppTextStyles.caption3.copyWith(
                    color: Colors.green,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),

          // Login button
          Obx(
            () => SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: loginController.isLoading.value
                    ? null
                    : () {
                        if (loginController.formKey.currentState?.validate() ??
                            false) {
                          loginController.login();
                        }
                      },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 3,
                ),
                child: loginController.isLoading.value
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text("Login", style: AppTextStyles.buttonMediumW),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
