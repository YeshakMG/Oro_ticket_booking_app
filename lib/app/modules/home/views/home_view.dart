import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:oro_ticket_booking_app/app/widgets/app_scaffold.dart';
import 'package:oro_ticket_booking_app/core/constants/typography.dart';
import '../controllers/home_controller.dart';
import '../../book/views/book_view.dart';

class HomeView extends GetView<HomeController> {
  @override
  final HomeController controller = Get.put(HomeController());

  HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: "OTA",
      currentBottomNavIndex: 0,
      actions: [
        IconButton(
          icon: const Icon(Icons.notifications, color: Colors.white),
          onPressed: () {},
        ),
      ],
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Obx(() {
          if (homeController.terminals.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          }

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Greeting
              const Text("Good Morning,", style: AppTextStyles.caption2),
              Obx(
                () => Text(
                  controller.userName.value.isNotEmpty
                      ? controller.userName.value
                      : "Olivia Rhye",
                  style: AppTextStyles.heading3,
                ),
              ),
              const SizedBox(height: 16),

              // Dropdown: From
              Obx(
                () => DropdownButtonFormField<String>(
                  initialValue: controller.fromLocation.value.isNotEmpty
                      ? controller.fromLocation.value
                      : null,
                  decoration: InputDecoration(
                    hintText: "From",
                    hintStyle: AppTextStyles.button,
                    prefixIcon: const Icon(Icons.place_outlined),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  items: controller.locations
                      .map(
                        (loc) => DropdownMenuItem(value: loc, child: Text(loc)),
                      )
                      .toList(),
                  onChanged: (value) {
                    if (value != null) {
                      controller.fromLocation.value = value;
                    }
                  },
                ),
              ),
              const SizedBox(height: 12),

              // Dropdown: Where are you going today?
              Obx(
                () => DropdownButtonFormField<String>(
                  style: AppTextStyles.buttonMedium,
                  initialValue: controller.toLocation.value.isNotEmpty
                      ? controller.toLocation.value
                      : null,
                  decoration: InputDecoration(
                    hintText: "Where are you going today?",
                    hintStyle: AppTextStyles.button,
                    prefixIcon: const Icon(Icons.place),
                    suffixIcon: IconButton(
                      icon: const Icon(Icons.swap_vert, color: Colors.green),
                      onPressed: () {
                        controller.toLocation();
                      },
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  items: controller.locations
                      .map(
                        (loc) => DropdownMenuItem(value: loc, child: Text(loc)),
                      )
                      .toList(),
                  onChanged: (value) {
                    if (value != null) {
                      controller.toLocation.value = value;
                    }
                  },
                ),
              ),
              const SizedBox(height: 12),

              // Search Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: () {
                    Get.to(
                      () => BookView(),
                      arguments: {
                        "from": controller.fromLocation.value,
                        "to": controller.toLocation.value,
                      },
                    );
                  },
                  child: const Text("Search Bus", style: AppTextStyles.button),
                ),
              ),
              const SizedBox(height: 20),

              // Quick Buy Tickets
              Row(
                children: [
                  Expanded(child: _QuickBuyCard("Pantai Idah Kapuk")),
                  const SizedBox(width: 12),
                  Expanded(child: _QuickBuyCard("Central Park Mall")),
                ],
              ),
              const SizedBox(height: 20),

              // Active Ticket Section
              const Text(
                "Your Active Ticket",
                style: AppTextStyles.displayMedium,
              ),
              const SizedBox(height: 12),

              Obx(
                () => Column(
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
                            Text(
                              ticket["date"]!,
                              style: AppTextStyles.displayMedium,
                            ),
                            const SizedBox(height: 8),
                            Row(
                              children: [
                                Chip(
                                  label: Text(ticket["type"]!),
                                  backgroundColor: Colors.orange.shade100,
                                ),
                                const SizedBox(width: 8),
                                const Chip(
                                  label: Text("Mix"),
                                  backgroundColor: Colors.grey,
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Row(
                              children: [
                                const Icon(Icons.directions_bus, size: 18),
                                const SizedBox(width: 6),
                                Expanded(
                                  child: Text(
                                    "${ticket["bus"]} | Arrival in ${ticket["time"]} at ${ticket["location"]}",
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),
                            SizedBox(
                              width: double.infinity,
                              child: ElevatedButton(
                                onPressed: () {},
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.green,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                                child: const Text(
                                  "See Barcode",
                                  style: AppTextStyles.buttonSmall,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
            ],
          );
        }),
      ),
    );
  }
}

// Reusable quick-buy card
class _QuickBuyCard extends StatelessWidget {
  final String title;
  const _QuickBuyCard(this.title);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Center(
        child: Text(
          "Buy ticket to\n$title",
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 14),
        ),
      ),
    );
  }
}

// Reusable quick-buy card
class _QuickBuyCard extends StatelessWidget {
  final String title;
  const _QuickBuyCard(this.title);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Center(
        child: Text(
          "Buy ticket to\n$title",
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 14),
        ),
      ),
    );
  }
}
