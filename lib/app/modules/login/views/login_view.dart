import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../login/controllers/login_controller.dart';
import '../../settings/controllers/settings_controller.dart';

class LoginView extends GetView<LoginController> {
  const LoginView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('login'.tr),
        backgroundColor: Colors.green,
        actions: [
          Get.isRegistered<SettingsController>()
              ? Obx(() {
                  final settings = Get.find<SettingsController>();
                  final items = settings.languages;
                  final selected = settings.selectedLanguageCode.value;
                  return PopupMenuButton<String>(
                    tooltip: 'Language',
                    icon: const Icon(Icons.language),
                    onSelected: (code) => settings.changeLanguage(code),
                    itemBuilder: (context) => items
                        .map((lang) => PopupMenuItem<String>(
                              value: lang['code']!,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text('${lang['code']} - ${lang['nativeName']}'),
                                  if (lang['code'] == selected)
                                    const Icon(Icons.check, size: 16),
                                ],
                              ),
                            ))
                        .toList(),
                  );
                })
              : const SizedBox.shrink(),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // Logo and title
            Column(
              children: [
                Image.asset(
                  "assets/logo/OTA_logo.png",
                  height: 80,
                  width: 80,
                ),
                const SizedBox(height: 10),
                Text(
                  "oromia_transport_agency".tr,
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.green,
                  ),
                ),
                const SizedBox(height: 20),
              ],
            ),
            _buildLoginForm(controller),
          ],
        ),
      ),
    );
  }

  /// ------------------ LOGIN FORM ------------------
  Widget _buildLoginForm(LoginController loginController) {
    return Form(
      key: loginController.formKey,
      child: Column(
        children: [
          // Phone number input
          TextFormField(
            controller: loginController.phoneController,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Phone number is required';
              }
              if (value.length < 10) {
                return 'Phone number must be at least 10 digits';
              }
              return null;
            },
            decoration: InputDecoration(
              labelText: "Phone Number",
              prefixIcon: const Icon(Icons.phone, color: Colors.green),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
            ),
          ),
          const SizedBox(height: 15),

          // Password input wrapped with Obx
          Obx(() => TextFormField(
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
                  prefixIcon: const Icon(Icons.lock, color: Colors.green),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                  suffixIcon: IconButton(
                    icon: Icon(loginController.isPasswordHidden.value
                        ? Icons.visibility_off
                        : Icons.visibility),
                    onPressed: loginController.togglePasswordVisibility,
                  ),
                ),
              )),
          const SizedBox(height: 15),

          // Login button wrapped with Obx
          Obx(() => SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: loginController.isLoading.value
                      ? null
                      : () {
                          if (loginController.formKey.currentState
                                  ?.validate() ??
                              false) {
                            debugPrint("Login button clicked");
                            loginController.login();
                          }
                        },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: loginController.isLoading.value
                      ? const CircularProgressIndicator(color: Colors.white)
                      : Text(
                          "login".tr,
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                ),
              )),

          const SizedBox(height: 20),

          // Redirect to SignUp
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("dont_have_account".tr),
              TextButton(
                onPressed: () {
                  Get.toNamed('/signup');
                },
                child: Text(
                  "sign_up".tr,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.green,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
