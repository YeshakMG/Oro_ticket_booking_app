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
              return Form(
                key: controller.formKey,
                child: Column(
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
                      TextFormField(
                        onChanged: (val) => controller.fullName.value = val,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Full name is required';
                          }
                          if (value.length < 3) {
                            return 'Full name must be at least 3 characters';
                          }
                          return null;
                        },
                        decoration: const InputDecoration(
                          labelText: "Full Name",
                          border: OutlineInputBorder(),
                        ),
                      ),
                    if (!controller.isLogin.value) const SizedBox(height: 16),

                    // Phone Number
                    TextFormField(
                      keyboardType: TextInputType.phone,
                      onChanged: (val) => controller.phone.value = val,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Phone number is required';
                        }
                        final phonePattern = RegExp(r'^(?:\251\d{8}|09\d{8})$');
                        if (!phonePattern.hasMatch(value)) {
                          return "Enter a valid Ethiopian phone number (+2519xxxxxxx or 09xxxxxxx)";
                        }
                        return null;
                      },
                      decoration: const InputDecoration(
                        labelText: "Phone Number",
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Email (Signup only)
                    if (!controller.isLogin.value)
                      TextFormField(
                        keyboardType: TextInputType.emailAddress,
                        onChanged: (val) => controller.email.value = val,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Email is required';
                          }
                          final emailPattern = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
                          if (!emailPattern.hasMatch(value)) {
                            return "Enter a valid email address";
                          }
                          return null;
                        },
                        decoration: const InputDecoration(
                          labelText: "Email Address",
                          border: OutlineInputBorder(),
                        ),
                      ),
                    if (!controller.isLogin.value) const SizedBox(height: 16),

                    // Password
                    TextFormField(
                      obscureText: true,
                      onChanged: (val) => controller.password.value = val,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Password is required';
                        }
                        if (value.length < 6) {
                          return 'Password must be at least 6 characters';
                        }
                        return null;
                      },
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
                                if (controller.formKey.currentState?.validate() ?? false) {
                                  if (controller.isLogin.value) {
                                    controller.login();
                                  } else {
                                    controller.signup();
                                  }
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
                ),
              );
            }),
          ),
        ),
      ),
    );
  }
}
