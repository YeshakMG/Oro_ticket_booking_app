import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:oro_ticket_booking_app/app/modules/auth/controllers/auth_controller.dart';

class AuthView extends GetView<AuthController> {


  const AuthView({super.key});

  @override
  Widget build(BuildContext context) {


    return Scaffold(
      body: SafeArea(

        child: Center(

          child: SingleChildScrollView(
            
            padding: const EdgeInsets.all(24.0),
            child: Obx(() {
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Title
                  Text(
                    controller.isLogin.value ? "Login" : "Sign Up",
                    style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 20),

                  // Full Name (Signup only)
                  if (!controller.isLogin.value)
                    TextField(
                      onChanged: (val) => controller.fullName.value = val,
                      decoration: const InputDecoration(
                        labelText: "Full Name",
                        border: OutlineInputBorder(),
                      ),
                    ),
                  if (!controller.isLogin.value) const SizedBox(height: 16),

                  // Phone Number
                  TextField(
                    keyboardType: TextInputType.phone,
                    onChanged: (val) => controller.phone.value = val,
                    decoration: const InputDecoration(
                      labelText: "Phone Number",
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Email (Signup only)
                  if (!controller.isLogin.value)
                    TextField(
                      keyboardType: TextInputType.emailAddress,
                      onChanged: (val) => controller.email.value = val,
                      decoration: const InputDecoration(
                        labelText: "Email Address",
                        border: OutlineInputBorder(),
                      ),
                    ),
                  if (!controller.isLogin.value) const SizedBox(height: 16),

                  // Password
                  TextField(
                    obscureText: true,
                    onChanged: (val) => controller.password.value = val,
                    decoration: const InputDecoration(
                      labelText: "Password",
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Submit Button
                  Obx(() {
                    return controller.isLoading.value
                        ? const CircularProgressIndicator()
                        : ElevatedButton(
                            onPressed: () {
                              if (controller.isLogin.value) {
                                controller.login();
                              } else {
                                controller.signup();
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              minimumSize: const Size(double.infinity, 50),
                              backgroundColor: Colors.green,
                            ),
                            child: Text(controller.isLogin.value ? "Login" : "Sign Up"),
                          );
                  }),
                  const SizedBox(height: 16),

                  // Toggle between Login & Signup
                  TextButton(
                    onPressed: controller.toggleAuthMode,
                    child: Text(
                      controller.isLogin.value
                          ? "Don't have an account? Sign Up"
                          : "Already have an account? Login",
                      style: const TextStyle(color: Colors.green),
                    ),
                  ),
                ],
              );
            }),
          ),
        ),
      ),
    );
  }
}
