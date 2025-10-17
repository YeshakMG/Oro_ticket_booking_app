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
    final MyticketController controller = Get.put(MyticketController());

    return AppScaffold(
      title: "My Tickets",
      currentBottomNavIndex: 1,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Your Booked Tickets", style: AppTextStyles.heading2),
            const SizedBox(height: 8),
            Text(
              "Manage and view your upcoming trips",
              style: AppTextStyles.caption.copyWith(
                color: Colors.grey.shade600,
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: Obx(
                () => controller.bookings.isEmpty
                    ? _buildEmptyState()
                    : ListView.builder(
                        itemCount: controller.bookings.length,
                        itemBuilder: (context, index) {
                          final booking = controller.bookings[index];
                          final trip = booking['trip'] is Map
                              ? Map<String, dynamic>.from(booking['trip'])
                              : <String, dynamic>{};
                          final selectedSeats = booking['selectedSeats'] is List
                              ? List<String>.from(booking['selectedSeats'])
                              : <String>[];
                          final bookingId =
                              booking['bookingId']?.toString() ?? 'N/A';
                          final totalAmount = booking['totalAmount'] ?? 0;

                          return Container(
                            margin: const EdgeInsets.only(bottom: 16),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(16),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.1),
                                  blurRadius: 8,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            child: Column(
                              children: [
                                // Ticket Header
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Row(
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 12,
                                          vertical: 6,
                                        ),
                                        decoration: BoxDecoration(
                                          color: Color(
                                            0xFF029600,
                                          ).withOpacity(0.2),
                                          borderRadius: BorderRadius.circular(
                                            8,
                                          ),
                                        ),
                                        child: Text(
                                          "Confirmed",
                                          style: AppTextStyles.buttonSmall
                                              .copyWith(
                                                fontSize: 12,
                                                color: Colors.black,
                                              ),
                                        ),
                                      ),
                                      const Spacer(),
                                      Text(
                                        "$totalAmount ETB",
                                        style: AppTextStyles.body1.copyWith(
                                          color: Colors.black87,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),

                                // Ticket Content
                                Padding(
                                  padding: const EdgeInsets.all(16),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      // Route
                                      Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Row(
                                                  children: [
                                                    Icon(
                                                      Icons.location_on,
                                                      color: Color(0xFF029600),
                                                      size: 20,
                                                    ),
                                                    const SizedBox(width: 12),
                                                    Text(
                                                      trip['departure'] ??
                                                          'N/A',
                                                      style: AppTextStyles.body1
                                                          .copyWith(
                                                            color: Colors.black,
                                                          ),
                                                      maxLines: 1,
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                    ),
                                                  ],
                                                ),
                                                Container(
                                                  padding:
                                                      const EdgeInsets.symmetric(
                                                        vertical: 4,
                                                      ),
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: [
                                                      Icon(
                                                        Icons.arrow_downward,
                                                        color: Colors.blueGrey,
                                                        fontWeight:
                                                            FontWeight.w600,
                                                        size: 20,
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                Row(
                                                  children: [
                                                    Icon(
                                                      Icons.location_on_rounded,
                                                      color: Color(0xFF029600),
                                                      size: 20,
                                                    ),
                                                    const SizedBox(width: 12),
                                                    Text(
                                                      trip['destination'] ??
                                                          'N/A',

                                                      style: AppTextStyles.body1
                                                          .copyWith(
                                                            color: Colors.black,
                                                          ),
                                                      maxLines: 1,
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),

                                      const SizedBox(height: 16),

                                      // Trip Details
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          _buildTicketDetail("Date", "Today"),
                                          _buildTicketDetail(
                                            "Time",
                                            "06:30 AM",
                                          ),
                                          _buildTicketDetail(
                                            "Seats",
                                            selectedSeats.length.toString(),
                                          ),
                                        ],
                                      ),

                                      const SizedBox(height: 16),

                                      // Seats
                                      Wrap(
                                        spacing: 8,
                                        runSpacing: 8,
                                        crossAxisAlignment:
                                            WrapCrossAlignment.end,
                                        children: selectedSeats.map((seat) {
                                          return Container(
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 10,
                                              vertical: 6,
                                            ),
                                            decoration: BoxDecoration(
                                              color: Colors.blue.shade50,
                                              borderRadius:
                                                  BorderRadius.circular(6),
                                              border: Border.all(
                                                color: Colors.blue.shade200,
                                              ),
                                            ),
                                            child: Row(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                Icon(
                                                  Icons.event_seat,
                                                  color: Colors.blue.shade700,
                                                  size: 14,
                                                ),
                                                const SizedBox(width: 4),
                                                Text(
                                                  seat,
                                                  style: AppTextStyles.caption
                                                      .copyWith(
                                                        fontWeight:
                                                            FontWeight.w600,
                                                        color: Colors
                                                            .blue
                                                            .shade800,
                                                      ),
                                                ),
                                              ],
                                            ),
                                          );
                                        }).toList(),
                                      ),

                                      const SizedBox(height: 16),

                                      // View Ticket Button
                                      SizedBox(
                                        width: double.infinity,
                                        child: ElevatedButton(
                                          onPressed: () =>
                                              _showTicketBottomSheet(
                                                context,
                                                bookingId,
                                                booking,
                                              ),
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: Color(0xFF029600),
                                            foregroundColor: Colors.white,
                                            padding: const EdgeInsets.symmetric(
                                              vertical: 12,
                                            ),
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(12),
                                            ),
                                            elevation: 0,
                                          ),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Icon(Icons.qr_code_2, size: 18),
                                              const SizedBox(width: 8),
                                              Text(
                                                "View E-Ticket",
                                                style:
                                                    AppTextStyles.buttonSmall,
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.confirmation_number,
            size: 64,
            color: Colors.grey.shade400,
          ),
          const SizedBox(height: 16),
          Text(
            "No Tickets Yet",
            style: AppTextStyles.heading2.copyWith(color: Colors.grey.shade600),
          ),
          const SizedBox(height: 8),
          Text(
            "Your booked tickets will appear here",
            style: AppTextStyles.body2.copyWith(color: Colors.grey.shade500),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () => Get.offAllNamed('/home'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green,
              foregroundColor: Colors.white,
            ),
            child: Text("Book a Trip", style: AppTextStyles.button),
          ),
        ],
      ),
    );
  }

  Widget _buildTicketDetail(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTextStyles.caption.copyWith(color: Colors.grey.shade600),
        ),
        const SizedBox(height: 2),
        Text(
          value,
          style: AppTextStyles.body2.copyWith(
            fontWeight: FontWeight.w500,
            color: Colors.black87,
          ),
        ),
      ],
    );
  }

  void _showTicketBottomSheet(
    BuildContext context,
    String bookingId,
    Map<dynamic, dynamic> booking,
  ) {
    final trip = booking['trip'] is Map
        ? Map<String, dynamic>.from(booking['trip'])
        : <String, dynamic>{};
    final selectedSeats = booking['selectedSeats'] is List
        ? List<String>.from(booking['selectedSeats'])
        : <String>[];
    final totalAmount = booking['totalAmount'] ?? 0;
    final timestamp = booking['timestamp'] ?? DateTime.now().toIso8601String();

    // Get user data from storage
    final box = Hive.box('appBox');
    final userData = box.get("user", defaultValue: {});

    final passengerName = userData is Map<String, dynamic>
        ? userData['full_name'] ?? 'Unknown User'
        : 'Unknown User';
    final phone = userData is Map<String, dynamic>
        ? userData['phone'] ?? 'N/A'
        : 'N/A';

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
      'paymentStatus': 'Paid',
      'bookingDate': timestamp,
      'validUntil': DateTime.parse(
        timestamp,
      ).add(const Duration(hours: 24)).toIso8601String(),
    };

    final qrString = qrData.toString();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.85,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(24),
            topRight: Radius.circular(24),
          ),
        ),
        child: SingleChildScrollView(
          child: Column(
            children: [
              // Header
              Container(
                padding: const EdgeInsets.all(20),
                decoration: const BoxDecoration(
                  color: Colors.white,

                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(24),
                    topRight: Radius.circular(24),
                  ),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        "Your E-ticket",
                        style: AppTextStyles.heading1.copyWith(
                          fontSize: 16,
                          color: Colors.black,
                        ),
                      ),
                    ),
                    IconButton(
                      icon: Icon(Icons.close, color: Colors.black),
                      onPressed: () => Get.back(),
                    ),
                  ],
                ),
              ),

              // Ticket Content
              Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    // Booking Code
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade50,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.grey.shade300),
                      ),
                      child: Column(
                        children: [
                          Text(
                            "Booking Code",
                            style: AppTextStyles.caption.copyWith(
                              color: Colors.grey.shade600,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            bookingId,
                            style: AppTextStyles.heading1.copyWith(
                              color: Colors.green.shade700,
                              letterSpacing: 2,
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 24),

                    // QR Code
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey.shade300),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Column(
                        children: [
                          QrImageView(
                            data: qrString,
                            version: QrVersions.auto,
                            size: 200.0,
                          ),
                          const SizedBox(height: 16),
                          Text(
                            "Scan the barcode or enter the booking code when getting on the bus.",
                            style: AppTextStyles.body2.copyWith(
                              color: Colors.grey.shade600,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 24),

                    // Trip Details
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade50,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Trip Details", style: AppTextStyles.heading3),
                          const SizedBox(height: 12),
                          _buildDetailRow("Passenger", passengerName),
                          _buildDetailRow("Phone", phone),
                          // _buildDetailRow(
                          //   "Route",
                          //   "${trip['departure']} → ${trip['destination']}",
                          // ),
                          _buildDetailRow(
                            "Bus",
                            "${trip['plateNumber']} • ${trip['level'] ?? 'Standard'}",
                          ),
                          _buildDetailRow("Seats", selectedSeats.join(', ')),
                          _buildDetailRow("Total Amount", "$totalAmount ETB"),
                          _buildDetailRow(
                            "Booking Date",
                            DateTime.parse(timestamp).toString().split(' ')[0],
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 20),

                    // Important Notice
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.orange.shade50,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.orange.shade200),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.info,
                            color: Colors.orange.shade700,
                            size: 20,
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              "Please arrive at the terminal 30 minutes before departure",
                              style: AppTextStyles.caption.copyWith(
                                color: Colors.orange.shade800,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 2,
            child: Text(
              "$label:",
              style: AppTextStyles.body2.copyWith(
                color: Colors.grey.shade600,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: Text(
              value,
              style: AppTextStyles.body2.copyWith(fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }
}
