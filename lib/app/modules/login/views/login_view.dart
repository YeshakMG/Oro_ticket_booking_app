import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../login/controllers/login_controller.dart';
import '../../signup/controllers/signup_controller.dart';
import '../../auth/authtabs/authtabs_controller.dart';

class LoginView extends GetView<LoginController> {
  const LoginView({super.key});

  @override
  Widget build(BuildContext context) {
    // Access other controllers via Get.find()
    final signUpController = Get.find<SignUpController>();
    final tabController = Get.find<AuthtabsController>();

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Background with logo
            Stack(
              children: [
                Container(
                  height: 250,
                  width: double.infinity,
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage("assets/images/bus_bg.jpg"),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Positioned(
                  top: 60,
                  left: 0,
                  right: 0,
                  child: Column(
                    children: const [
                      CircleAvatar(
                        radius: 40,
                        backgroundColor: Colors.white,
                        child: Icon(Icons.directions_bus,
                            size: 40, color: Colors.green),
                      ),
                      SizedBox(height: 10),
                      Text(
                        "Oro Ticket Booking",
                        style: TextStyle(
                            fontSize: 24, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        "Create an account or log in to explore our app",
                        style: TextStyle(color: Colors.white70, fontSize: 14),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                )
              ],
            ),

            // Form container
            Container(
              padding: const EdgeInsets.all(20),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
              ),
              child: Column(
                children: [
                  // Tabs
                  Obx(() => Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          TextButton(
                            onPressed: () => tabController.changeTab(0),
                            child: Text(
                              "Log In",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: tabController.selectedTab.value == 0
                                    ? Colors.green
                                    : Colors.grey,
                              ),
                            ),
                          ),
                          const SizedBox(width: 20),
                          TextButton(
                            onPressed: () => tabController.changeTab(1),
                            child: Text(
                              "Sign Up",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: tabController.selectedTab.value == 1
                                    ? Colors.green
                                    : Colors.grey,
                              ),
                            ),
                          ),
                        ],
                      )),

                  const SizedBox(height: 20),

                  // Switch forms
                  Obx(() => tabController.selectedTab.value == 0
                      ? _buildLoginForm(controller)
                      : _buildSignUpForm(signUpController)),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  /// ------------------ LOGIN FORM ------------------
  Widget _buildLoginForm(LoginController loginController) {
    return Column(
      children: [
        TextField(
          controller: loginController.phoneController,
          decoration: InputDecoration(
            labelText: "Phone Number",
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
        const SizedBox(height: 15),
        Obx(() => TextField(
              controller: loginController.passwordController,
              obscureText: loginController.isPasswordHidden.value,
              decoration: InputDecoration(
                labelText: "Password",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                suffixIcon: IconButton(
                  icon: Icon(loginController.isPasswordHidden.value
                      ? Icons.visibility_off
                      : Icons.visibility),
                  onPressed: () => loginController.isPasswordHidden.value =
                      !loginController.isPasswordHidden.value,
                ),
              ),
            )),
        const SizedBox(height: 15),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: loginController.login,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green,
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
            ),
            child: const Text(
              "Login",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),
        ),
      ],
    );
  }

  /// ------------------ SIGN UP FORM ------------------
  Widget _buildSignUpForm(SignUpController signUpController) {
    return Column(
      children: [
        TextField(
          controller: signUpController.fullNameController,
          decoration: InputDecoration(
            labelText: "Full Name",
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
        const SizedBox(height: 15),
        TextField(
          controller: signUpController.phoneController,
          decoration: InputDecoration(
            labelText: "Phone Number",
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
        const SizedBox(height: 15),
        TextField(
          controller: signUpController.emailController,
          decoration: InputDecoration(
            labelText: "Email",
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
        const SizedBox(height: 15),
        Obx(() => TextField(
              controller: signUpController.passwordController,
              obscureText: signUpController.isPasswordHidden.value,
              decoration: InputDecoration(
                labelText: "Password",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                suffixIcon: IconButton(
                  icon: Icon(signUpController.isPasswordHidden.value
                      ? Icons.visibility_off
                      : Icons.visibility),
                  onPressed: () =>
                      signUpController.isPasswordHidden.value =
                          !signUpController.isPasswordHidden.value,
                ),
              ),
            )),
        const SizedBox(height: 20),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: signUpController.register,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green,
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
            ),
            child: const Text(
              "Sign Up",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),
        ),
      ],
    );
  }
}
