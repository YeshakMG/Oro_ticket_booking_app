import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:oro_ticket_booking_app/app/modules/login/controllers/login_controller.dart';

class LoginView extends GetView<LoginController> {
  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Background image with logo
            Stack(
              children: [
                Container(
                  height: 250,
                  width: double.infinity,
                  decoration: BoxDecoration(
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
                    children: [
                      CircleAvatar(
                        radius: 40,
                        backgroundColor: Colors.white,
                        child: Icon(Icons.directions_bus,
                            size: 40, color: Colors.green),
                      ),
                      SizedBox(height: 10),
                      Text("Get Started now",
                          style: TextStyle(
                              fontSize: 24, fontWeight: FontWeight.bold)),
                      Text(
                        "Create an account or log in to explore about our app",
                        style: TextStyle(color: Colors.grey[200], fontSize: 14),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                )
              ],
            ),

            // Login form
            Container(
              padding: EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius:
                    BorderRadius.vertical(top: Radius.circular(24)),
              ),
              child: Column(
                children: [
                  // Tabs (Login / Sign Up)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      TextButton(
                          onPressed: () {},
                          child: Text("Log In",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.green))),
                      SizedBox(width: 20),
                      TextButton(
                          onPressed: () {},
                          child: Text("Sign Up",
                              style: TextStyle(color: Colors.grey))),
                    ],
                  ),

                  SizedBox(height: 20),

                  // Email / phone field
                  TextField(
                    controller: controller.phoneController,
                    decoration: InputDecoration(
                      labelText: "Phone Number",
                      hintText: "example@email.com",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                  SizedBox(height: 15),

                  // Password field
                  Obx(() => TextField(
                        controller: controller.passwordController,
                        obscureText: controller.isPasswordHidden.value,
                        decoration: InputDecoration(
                          labelText: "Password",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          suffixIcon: IconButton(
                            icon: Icon(controller.isPasswordHidden.value
                                ? Icons.visibility_off
                                : Icons.visibility),
                            onPressed: () {
                              controller.isPasswordHidden.value =
                                  !controller.isPasswordHidden.value;
                            },
                          ),
                        ),
                      )),
                  SizedBox(height: 10),

                  // Remember me + Forgot Password
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Obx(() => Row(
                            children: [
                              Checkbox(
                                value: controller.rememberMe.value,
                                onChanged: (value) =>
                                    controller.rememberMe.value = value ?? false,
                              ),
                              Text("Remember me"),
                            ],
                          )),
                      TextButton(
                        onPressed: () {
                          // TODO: Forgot password navigation
                        },
                        child: Text("Forgot Password ?",
                            style: TextStyle(color: Colors.green)),
                      )
                    ],
                  ),

                  SizedBox(height: 15),

                  // Login button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: controller.login,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        padding: EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12)),
                      ),
                      child: Text("Login",
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold)),
                    ),
                  ),

                  
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

}
