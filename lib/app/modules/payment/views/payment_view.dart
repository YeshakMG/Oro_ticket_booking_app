import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/payment_controller.dart';

class PaymentView extends GetView<PaymentController> {
  const PaymentView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("confirm_booking".tr),
        backgroundColor: Colors.green,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Obx(() => Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Trip Info
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "${controller.selectedTrip.value?['departure'] ?? 'N/A'} → ${controller.selectedTrip.value?['destination'] ?? 'N/A'}",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    Text("Bus: ${controller.selectedTrip.value?['plateNumber'] ?? 'N/A'}"),
                    Text("Price per seat: ${controller.selectedTrip.value?['price'] ?? 'N/A'} ETB"),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            Text("selected_seats".tr,
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            Wrap(
              spacing: 10,
              runSpacing: 10,
              children: controller.selectedSeats
                  .map((seat) => Chip(
                        label: Text(seat),
                        backgroundColor: Colors.teal,
                        labelStyle: const TextStyle(color: Colors.white),
                      ))
                  .toList(),
            ),
            const SizedBox(height: 16),
            Text(
              "${"total_amount".tr}: ${(controller.selectedSeats.length * (controller.selectedTrip.value?['price'] ?? 0)).toStringAsFixed(2)} ETB",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12))),
                onPressed: () => controller.processPayment(),
                child: Text("pay_now".tr,
                    style: TextStyle(color: Colors.white, fontSize: 16)),
                    
              ),
            )
          ],
        )),
      ),
    );
  }
}
