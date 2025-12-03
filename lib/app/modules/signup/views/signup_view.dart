import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:oro_ticket_booking_app/core/constants/typography.dart';
import '../controllers/signup_controller.dart';

class SignUpView extends GetView<SignUpController> {
  const SignUpView({super.key});

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
              "assets/images/banner.jpg", // Replace with your top background image
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
                          color: Colors.grey.shade200,
                          fontSize: 10,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 20),

                /// Signup card section
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
                              child: GestureDetector(
                                onTap: () => Get.offNamed('/login'),
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 12,
                                  ),
                                  child: Center(
                                    child: Text(
                                      "Log In",
                                      style: AppTextStyles.body1.copyWith(
                                        color: Colors.grey[600],
                                        fontSize: 10,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Expanded(
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 10,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(8),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.05),
                                      blurRadius: 4,
                                      offset: const Offset(0, 2),
                                    ),
                                  ],
                                ),
                                child: Center(
                                  child: Text(
                                    "Sign Up",
                                    style: AppTextStyles.buttonMedium.copyWith(
                                      fontSize: 10,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 30),

                      /// Signup form
                      Expanded(
                        child: SingleChildScrollView(
                          child: _buildSignUpForm(controller, context),
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

  /// ------------------ SIGNUP FORM ------------------
  Widget _buildSignUpForm(
    SignUpController signUpController,
    BuildContext context,
  ) {
    return Form(
      key: signUpController.formKey,
      child: Column(
        children: [
          // Full Name
          TextFormField(
            controller: signUpController.fullNameController,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Full name is required';
              }
              if (value.length < 3) {
                return 'Full name must be at least 3 characters';
              }
              return null;
            },
            decoration: InputDecoration(
              labelText: "Full Name",
              labelStyle: AppTextStyles.caption3.copyWith(
                color: Colors.grey,
                fontSize: 10,
              ),
              prefixIcon: Icon(Iconsax.profile_2user, color: Colors.grey),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: Color(0xFFEDF1F3)),
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(color: Colors.green),
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Phone Number
          TextFormField(
            controller: signUpController.phoneController,
            keyboardType: TextInputType.phone,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Phone number is required';
              }
              final phonePattern = RegExp(r'^(?:\+2519\d{8}|09\d{8})$');
              if (!phonePattern.hasMatch(value)) {
                return "Enter a valid Ethiopian phone number (+2519xxxxxxx or 09xxxxxxx)";
              }
              return null;
            },
            decoration: InputDecoration(
              labelText: "Phone Number",
              labelStyle: AppTextStyles.caption3.copyWith(
                color: Colors.grey,
                fontSize: 10,
              ),
              prefixIcon: const Icon(Iconsax.mobile, color: Colors.grey),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: Color(0xFFEDF1F3)),
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(color: Colors.green),
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Email
          TextFormField(
            controller: signUpController.emailController,
            keyboardType: TextInputType.emailAddress,
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
            decoration: InputDecoration(
              labelText: "Email",
              labelStyle: AppTextStyles.caption3.copyWith(
                color: Colors.grey,
                fontSize: 10,
              ),
              prefixIcon: const Icon(
                Iconsax.sms,
                color: Colors.grey,
                weight: 1,
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: Color(0xFFEDF1F3)),
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(color: Colors.green),
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Password
          Obx(
            () => TextFormField(
              controller: signUpController.passwordController,
              obscureText: signUpController.isPasswordHidden.value,
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
                labelStyle: AppTextStyles.caption3.copyWith(
                  color: Colors.grey,
                  fontSize: 10,
                ),
                prefixIcon: const Icon(
                  Iconsax.password_check,
                  color: Colors.grey,
                ),
                suffixIcon: IconButton(
                  icon: Icon(
                    signUpController.isPasswordHidden.value
                        ? Iconsax.eye_slash
                        : Iconsax.eye,
                    color: Colors.grey,
                  ),
                  onPressed: signUpController.isPasswordHidden.toggle,
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: Color(0xFFEDF1F3)),
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: const BorderSide(color: Colors.green),
                ),
              ),
            ),
          ),
          const SizedBox(height: 24),

          // Sign Up button
          Obx(
            () => SizedBox(
              width: MediaQuery.of(context).size.width * 0.5,
              child: ElevatedButton(
                onPressed: signUpController.isLoading.value
                    ? null
                    : () {
                        if (signUpController.formKey.currentState?.validate() ??
                            false) {
                          signUpController.register();
                        }
                      },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  padding: const EdgeInsets.symmetric(vertical: 5),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  elevation: 3,
                ),
                child: signUpController.isLoading.value
                    ? const CircularProgressIndicator(color: Colors.white)
                    : Text(
                        "Sign Up",
                        style: AppTextStyles.buttonMediumW.copyWith(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
