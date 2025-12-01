import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:oro_ticket_booking_app/app/widgets/app_scaffold.dart';
import 'package:oro_ticket_booking_app/core/constants/typography.dart';
import '../controllers/trip_selection_controller.dart';

class TripSelectionView extends GetView<TripSelectionController> {
  const TripSelectionView({super.key});

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: 'Select Trip',
      currentBottomNavIndex: 0,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "${"available_trips_from_to".tr} ${controller.from.value} ${"to".tr} ${controller.to.value}",
              style: AppTextStyles.displayMedium,
            ),
            const SizedBox(height: 16),
            Expanded(
              child: Obx(() => ListView.builder(
                itemCount: controller.trips.length,
                itemBuilder: (context, index) {
                  final trip = controller.trips[index];
                  return Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Chip(
                                label: Text(trip['level'] ?? 'Standard'),
                                backgroundColor: Colors.orange.shade100,
                              ),
                              const SizedBox(width: 8),
                              Chip(
                                label: Text("${"seats".tr}: ${trip['seatsAvailable'] ?? 'N/A'}"),
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
                                  "${trip['plateNumber'] ?? 'N/A'} | Price: ${trip['price'] ?? 'N/A'} ETB",
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: () => controller.selectTrip(trip),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.green,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              child: Text(
                                "select_trip".tr,
                                style: AppTextStyles.buttonSmall,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              )),
            ),
          ],
        ),
      ),
    );
  }
}