import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:oro_ticket_booking_app/app/widgets/app_scaffold.dart';
import 'package:oro_ticket_booking_app/core/constants/typography.dart';
import 'package:qr_flutter/qr_flutter.dart';

import '../controllers/myticket_controller.dart';

class MyticketView extends StatelessWidget {
  const MyticketView({super.key});

  @override
  Widget build(BuildContext context) {
    final MyticketController controller = Get.find<MyticketController>();

    return AppScaffold(
      title: "My Tickets",
      currentBottomNavIndex: 1,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("your_booked_tickets".tr, style: AppTextStyles.displayMedium),
            const SizedBox(height: 12),
            Expanded(
              child: Obx(() => controller.bookings.isEmpty
                ? Center(child: Text("no_bookings_found".tr))
                : ListView.builder(
                  itemCount: controller.bookings.length,
                  itemBuilder: (context, index) {
                    final booking = controller.bookings[index];
                    final trip = booking['trip'] is Map ? Map<String, dynamic>.from(booking['trip']) : <String, dynamic>{};
                    final selectedSeats = booking['selectedSeats'] is List ? List<String>.from(booking['selectedSeats']) : <String>[];
                    final bookingId = booking['bookingId']?.toString() ?? 'N/A';

                    return Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("${trip['departure']} → ${trip['destination']}",
                                style: AppTextStyles.displayMedium),
                            const SizedBox(height: 8),
                            Row(
                              children: [
                                Chip(
                                  label: Text(trip['level'] ?? 'Standard'),
                                  backgroundColor: Colors.orange.shade100,
                                ),
                                const SizedBox(width: 8),
                                Chip(
                                  label: Text("Seats: ${selectedSeats.join(', ')}"),
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
                                    "${trip['plateNumber'] ?? 'N/A'} | Total: ${booking['totalAmount'] ?? 'N/A'} ETB",
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),
                            SizedBox(
                              width: double.infinity,
                              child: ElevatedButton(
                                onPressed: () => _showQRCode(context, bookingId, booking),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.green,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                                child: Text(
                                  "show_qr_code".tr,
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

  void _showQRCode(BuildContext context, String bookingId, Map<dynamic, dynamic> booking) {
    final trip = booking['trip'] is Map ? Map<String, dynamic>.from(booking['trip']) : <String, dynamic>{};
    final selectedSeats = booking['selectedSeats'] is List ? List<String>.from(booking['selectedSeats']) : <String>[];
    final totalAmount = booking['totalAmount'] ?? 0;
    final timestamp = booking['timestamp'] ?? DateTime.now().toIso8601String();

    // Get user data from storage
    final box = Hive.box('appBox');
    final userData = box.get("user", defaultValue: {});

    final passengerName = userData is Map<String, dynamic> ? userData['full_name'] ?? 'Unknown User' : 'Unknown User';
    final phone = userData is Map<String, dynamic> ? userData['phone'] ?? 'N/A' : 'N/A';

    // Create comprehensive QR data
    final qrData = {
      'bookingId': bookingId,
      'passengerName': passengerName,
      'phone': phone,
      'departure': trip['departure'] ?? '',
      'destination': trip['destination'] ?? '',
      'plateNumber': trip['plateNumber'] ?? '',
      'level': trip['level'] ?? 'Standard',
      'seats': selectedSeats,
      'totalAmount': totalAmount,
      'paymentStatus': 'Paid', // All bookings are considered paid since payment was processed
      'bookingDate': timestamp,
      'validUntil': DateTime.parse(timestamp).add(const Duration(hours: 24)).toIso8601String(),
    };

    // Convert to JSON string for QR code
    final qrString = qrData.toString();

    showDialog(
      context: context,
      builder: (context) => Dialog(
        child: Container(
          width: MediaQuery.of(context).size.width * 0.9,
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "ticket_qr_code".tr,
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              Container(
                width: 200,
                height: 200,
                child: QrImageView(
                  data: qrString,
                  version: QrVersions.auto,
                  size: 200.0,
                ),
              ),
              const SizedBox(height: 16),
              Text("${"booking_id".tr}: $bookingId", style: const TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 4),
              Text("${"passenger".tr}: $passengerName"),
              const SizedBox(height: 4),
              Text("${"phone".tr}: $phone"),
              const SizedBox(height: 4),
              Text("${"route".tr}: ${trip['departure']} → ${trip['destination']}"),
              const SizedBox(height: 4),
              Text("${"selected_seats".tr}: ${selectedSeats.join(', ')}"),
              const SizedBox(height: 4),
              Text("${"amount".tr}: $totalAmount ETB"),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.green.shade100,
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  "payment_status_paid".tr,
                  style: TextStyle(
                    color: Colors.green,
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: Text("close".tr),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
