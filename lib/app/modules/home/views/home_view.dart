import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/home_controller.dart';
import '../../book/views/book_view.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("OTA", style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.menu),
          onPressed: () {},
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.account_circle, size: 30),
            onPressed: () {},
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Greeting
              Obx(() => Text(
                    "Good Morning,\n${controller.userName.value}",
                    style: const TextStyle(
                        fontSize: 20, fontWeight: FontWeight.bold),
                  )),
              const SizedBox(height: 16),

              // Dropdown: Where From
              Obx(() => DropdownButtonFormField<String>(
                    value: controller.fromLocation.value,
                    decoration: InputDecoration(
                      labelText: "Where from",
                      prefixIcon: const Icon(Icons.place_outlined),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    items: controller.locations
                        .map((loc) =>
                            DropdownMenuItem(value: loc, child: Text(loc)))
                        .toList(),
                    onChanged: (value) {
                      if (value != null) {
                        controller.fromLocation.value = value;
                      }
                    },
                  )),
              const SizedBox(height: 12),

              // Dropdown: Where are you going today?
              Obx(() => DropdownButtonFormField<String>(
                    value: controller.toLocation.value,
                    decoration: InputDecoration(
                      labelText: "Where are you going today?",
                      prefixIcon: const Icon(Icons.place),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    items: controller.locations
                        .map((loc) =>
                            DropdownMenuItem(value: loc, child: Text(loc)))
                        .toList(),
                    onChanged: (value) {
                      if (value != null) {
                        controller.toLocation.value = value;
                      }
                    },
                  )),
              const SizedBox(height: 12),

              // Search Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                      backgroundColor: Colors.green),
                  onPressed: () {
                    Get.to(() => BookView(), arguments: {
                      "from": controller.fromLocation.value,
                      "to": controller.toLocation.value
                    });
                  },
                  child: const Text("Search Bus",
                      style: TextStyle(color: Colors.white, fontSize: 16)),
                ),
              ),
              const SizedBox(height: 20),

              // Active Ticket Section
              const Text("Your Active Ticket",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 12),

              Obx(() => Column(
                    children: controller.tickets.map((ticket) {
                      return Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(ticket["date"]!,
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold)),
                              const SizedBox(height: 8),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Chip(
                                    label: Text(ticket["type"]!),
                                    backgroundColor: Colors.orange.shade100,
                                  ),
                                  Text(ticket["bus"]!,
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold)),
                                ],
                              ),
                              const SizedBox(height: 8),
                              Text("Arrival in ${ticket["time"]} at ${ticket["location"]}"),
                              const SizedBox(height: 8),
                              ElevatedButton(
                                onPressed: () {},
                                style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.green,
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(12))),
                                child: const Text("See Barcode",
                                    style: TextStyle(color: Colors.white)),
                              )
                            ],
                          ),
                        ),
                      );
                    }).toList(),
                  )),
            ],
          ),
        ),
      ),
    );
  }
}
