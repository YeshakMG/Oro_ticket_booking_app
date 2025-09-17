import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../home/controllers/home_controller.dart';
import '../../signup/controllers/signup_controller.dart';

class HomeView extends StatelessWidget {
  final HomeController homeController = Get.put(HomeController());
  final SignUpController signupController = Get.put(SignUpController());

  HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Obx(() {
          final name = signupController.fullNameController.text.isNotEmpty
              ? signupController.fullNameController.text
              : homeController.userName.value;
          return Text("Welcome, $name");
        }),
        backgroundColor: Colors.green,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => homeController.fetchTerminals(),
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Obx(() {
          if (homeController.terminals.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          }

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Select From Terminal:",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              DropdownButton<Map<String, dynamic>>(
                isExpanded: true,
                value: homeController.fromLocation.value,
                items: homeController.terminals
                    .map((terminal) => DropdownMenuItem(
                          value: terminal,
                          child: Text(terminal['name'] ?? ''),
                        ))
                    .toList(),
                onChanged: (val) => homeController.fromLocation.value = val,
              ),
              const SizedBox(height: 20),
              const Text(
                "Select To Terminal:",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              DropdownButton<Map<String, dynamic>>(
                isExpanded: true,
                value: homeController.toLocation.value,
                items: homeController.terminals
                    .map((terminal) => DropdownMenuItem(
                          value: terminal,
                          child: Text(terminal['name'] ?? ''),
                        ))
                    .toList(),
                onChanged: (val) => homeController.toLocation.value = val,
              ),
            ],
          );
        }),
      ),
    );
  }
}
