import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:iconsax/iconsax.dart';
import 'package:oro_ticket_booking_app/app/widgets/app_scaffold.dart';
import 'package:oro_ticket_booking_app/core/constants/colors.dart';
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
            Text(
              "Your Booked Tickets",
              style: AppTextStyles.heading2.copyWith(fontSize: 14),
            ),
            const SizedBox(height: 8),
            Text(
              "Manage and view your upcoming trips",
              style: AppTextStyles.caption.copyWith(
                color: Colors.grey.shade400,
                fontSize: 10,
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
                          final departure = trip['departure'] ?? 'N/A';
                          final destination = trip['destination'] ?? 'N/A';
                          final plateNumber = trip['plateNumber'] ?? 'N/A';
                          final time = trip['departureTime'] ?? '06:30 AM';
                          final date = trip['departureDate'] ?? 'Today';

                          return Container(
                            margin: const EdgeInsets.only(bottom: 16),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              color: Colors.white,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withValues(alpha: 0.5),
                                  blurRadius: 10,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                              border: Border.all(
                                color: Colors.grey.shade200,
                                width: 1,
                              ),
                            ),
                            child: Column(
                              children: [
                                // Ticket Top Section
                                Container(
                                  padding: const EdgeInsets.all(12),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: const BorderRadius.only(
                                      topLeft: Radius.circular(12),
                                      topRight: Radius.circular(12),
                                    ),
                                    border: Border(
                                      bottom: BorderSide(
                                        color: Colors.grey.shade200,
                                        width: 1,
                                      ),
                                    ),
                                  ),
                                  child: Row(
                                    children: [
                                      // Status Badge
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 10,
                                          vertical: 4,
                                        ),
                                        decoration: BoxDecoration(
                                          color: const Color(
                                            0xFF029600,
                                          ).withValues(alpha: 0.1),
                                          borderRadius: BorderRadius.circular(
                                            8,
                                          ),
                                        ),
                                        child: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Icon(
                                              Iconsax.tick_circle,
                                              size: 12,
                                              color: const Color(0xFF029600),
                                            ),
                                            const SizedBox(width: 4),
                                            Text(
                                              "Confirmed",
                                              style: AppTextStyles.buttonSmall
                                                  .copyWith(
                                                    fontSize: 10,
                                                    color: const Color(
                                                      0xFF029600,
                                                    ),
                                                    fontWeight: FontWeight.w600,
                                                  ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      const Spacer(),
                                      // Amount
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.end,
                                        children: [
                                          Text(
                                            "$totalAmount ETB",
                                            style: AppTextStyles.body1.copyWith(
                                              color: Colors.black,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 12,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),

                                // Main Ticket Content
                                Padding(
                                  padding: const EdgeInsets.all(16),
                                  child: Column(
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 8,
                                          vertical: 12,
                                        ),
                                        decoration: BoxDecoration(
                                          color: Colors.grey.shade50,
                                          borderRadius: BorderRadius.circular(
                                            8,
                                          ),
                                        ),
                                        child: Column(
                                          children: [
                                            // Departure - Top
                                            Row(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Container(
                                                  padding: const EdgeInsets.all(
                                                    6,
                                                  ),
                                                  decoration: BoxDecoration(
                                                    color: const Color(
                                                      0xFF029600,
                                                    ),
                                                    shape: BoxShape.circle,
                                                  ),
                                                  child: const Icon(
                                                    Iconsax.location,
                                                    color: Colors.white,
                                                    size: 14,
                                                  ),
                                                ),
                                                const SizedBox(width: 12),
                                                Expanded(
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Text(
                                                        "From",
                                                        style: AppTextStyles
                                                            .caption
                                                            .copyWith(
                                                              color: Colors
                                                                  .grey
                                                                  .shade600,
                                                              fontSize: 10,
                                                            ),
                                                      ),
                                                      const SizedBox(height: 4),
                                                      Text(
                                                        departure,
                                                        style: AppTextStyles
                                                            .body1
                                                            .copyWith(
                                                              color:
                                                                  Colors.black,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w600,
                                                              fontSize: 10,
                                                            ),
                                                        maxLines: 2,
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),

                                            Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                    vertical: 8,
                                                  ),
                                              child: Row(
                                                children: [
                                                  const SizedBox(width: 21),
                                                  Expanded(
                                                    child: Container(
                                                      height: 1,
                                                      decoration: BoxDecoration(
                                                        gradient:
                                                            LinearGradient(
                                                              colors: [
                                                                Colors
                                                                    .grey
                                                                    .shade300,
                                                                Colors
                                                                    .grey
                                                                    .shade300,
                                                              ],
                                                            ),
                                                      ),
                                                    ),
                                                  ),
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.symmetric(
                                                          horizontal: 8,
                                                        ),
                                                    child: Icon(
                                                      Iconsax.arrow_down,
                                                      color: const Color(
                                                        0xFF029600,
                                                      ),
                                                      size: 18,
                                                    ),
                                                  ),
                                                  Expanded(
                                                    child: Container(
                                                      height: 1,
                                                      decoration: BoxDecoration(
                                                        gradient:
                                                            LinearGradient(
                                                              colors: [
                                                                Colors
                                                                    .grey
                                                                    .shade300,
                                                                Colors
                                                                    .grey
                                                                    .shade300,
                                                              ],
                                                            ),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),

                                            Row(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Container(
                                                  padding: const EdgeInsets.all(
                                                    6,
                                                  ),
                                                  decoration: BoxDecoration(
                                                    color: Colors.red.shade600,
                                                    shape: BoxShape.circle,
                                                  ),
                                                  child: const Icon(
                                                    Iconsax.location,
                                                    color: Colors.white,
                                                    size: 14,
                                                  ),
                                                ),
                                                const SizedBox(width: 12),
                                                Expanded(
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Text(
                                                        "To",
                                                        style: AppTextStyles
                                                            .caption
                                                            .copyWith(
                                                              color: Colors
                                                                  .grey
                                                                  .shade600,
                                                              fontSize: 10,
                                                            ),
                                                      ),
                                                      const SizedBox(height: 4),
                                                      Text(
                                                        destination,
                                                        style: AppTextStyles
                                                            .body1
                                                            .copyWith(
                                                              color:
                                                                  Colors.black,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w600,
                                                              fontSize: 10,
                                                            ),
                                                        maxLines: 2,
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),

                                      const SizedBox(height: 10),

                                      // Trip Details Grid
                                      Container(
                                        padding: const EdgeInsets.all(12),
                                        decoration: BoxDecoration(
                                          color: Colors.grey.shade50,
                                          borderRadius: BorderRadius.circular(
                                            8,
                                          ),
                                        ),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceAround,
                                          children: [
                                            _buildDetailItem(
                                              Iconsax.calendar,
                                              "Date",
                                              date,
                                            ),
                                            _buildDetailItem(
                                              Iconsax.clock,
                                              "Time",
                                              time,
                                            ),
                                            _buildDetailItem(
                                              Iconsax.bus,
                                              "Bus",
                                              plateNumber,
                                            ),
                                            _buildDetailItem(
                                              Icons.event_seat_outlined,
                                              "Seats",
                                              "${selectedSeats.length} seats",
                                            ),
                                          ],
                                        ),
                                      ),

                                      const SizedBox(height: 16),

                                      // // Seat Numbers
                                      // if (selectedSeats.isNotEmpty)
                                      //   Container(
                                      //     padding: const EdgeInsets.all(5),
                                      //     decoration: BoxDecoration(
                                      //       color: Colors.blue.shade50,
                                      //       borderRadius: BorderRadius.circular(
                                      //         8,
                                      //       ),
                                      //       border: Border.all(
                                      //         color: Colors.blue.shade100,
                                      //       ),
                                      //     ),
                                      //     child: Column(
                                      //       crossAxisAlignment:
                                      //           CrossAxisAlignment.start,
                                      //       children: [
                                      //         Row(
                                      //           children: [
                                      //             Icon(
                                      //               Icons.event_seat,
                                      //               color: Colors.blue.shade700,
                                      //               size: 14,
                                      //             ),
                                      //             const SizedBox(width: 6),
                                      //             Text(
                                      //               "Seat Numbers",
                                      //               style: AppTextStyles.caption
                                      //                   .copyWith(
                                      //                     color: Colors
                                      //                         .blue
                                      //                         .shade800,
                                      //                     fontWeight:
                                      //                         FontWeight.w600,
                                      //                     fontSize: 11,
                                      //                   ),
                                      //             ),
                                      //           ],
                                      //         ),
                                      //         const SizedBox(height: 8),
                                      //         Wrap(
                                      //           spacing: 8,
                                      //           runSpacing: 8,
                                      //           children: selectedSeats
                                      //               .map(
                                      //                 (seat) => Container(
                                      //                   padding:
                                      //                       const EdgeInsets.symmetric(
                                      //                         horizontal: 10,
                                      //                         vertical: 6,
                                      //                       ),
                                      //                   decoration: BoxDecoration(
                                      //                     color: Colors.white,
                                      //                     borderRadius:
                                      //                         BorderRadius.circular(
                                      //                           6,
                                      //                         ),
                                      //                     border: Border.all(
                                      //                       color: Colors
                                      //                           .blue
                                      //                           .shade300,
                                      //                     ),
                                      //                   ),
                                      //                   child: Text(
                                      //                     seat,
                                      //                     style: AppTextStyles
                                      //                         .caption
                                      //                         .copyWith(
                                      //                           fontWeight:
                                      //                               FontWeight
                                      //                                   .w600,
                                      //                           color: Colors
                                      //                               .blue
                                      //                               .shade800,
                                      //                           fontSize: 10,
                                      //                         ),
                                      //                   ),
                                      //                 ),
                                      //               )
                                      //               .toList(),
                                      //         ),
                                      //       ],
                                      //     ),
                                      //   ),
                                      // const SizedBox(height: 20),

                                      // Action Buttons
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          SizedBox(
                                            width:
                                                MediaQuery.of(
                                                  context,
                                                ).size.width *
                                                0.5,
                                            child: ElevatedButton(
                                              onPressed: () =>
                                                  _showTicketBottomSheet(
                                                    context,
                                                    bookingId,
                                                    booking,
                                                  ),
                                              style: ElevatedButton.styleFrom(
                                                backgroundColor: const Color(
                                                  0xFF029600,
                                                ),
                                                foregroundColor: Colors.white,
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(8),
                                                ),
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                      vertical: 12,
                                                    ),
                                              ),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  Icon(
                                                    Iconsax.scan_barcode,
                                                    size: 16,
                                                  ),
                                                  const SizedBox(width: 8),
                                                  Text(
                                                    "View Ticket",
                                                    style: AppTextStyles
                                                        .buttonSmall
                                                        .copyWith(fontSize: 11),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ],
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

  Widget _buildDetailItem(IconData icon, String label, String value) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.1),
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Icon(icon, size: 16, color: const Color(0xFF029600)),
        ),
        const SizedBox(height: 6),
        Text(
          label,
          style: AppTextStyles.caption.copyWith(
            color: Colors.grey.shade600,
            fontSize: 9,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          value,
          style: AppTextStyles.body2.copyWith(
            fontWeight: FontWeight.w600,
            fontSize: 10,
            color: Colors.black87,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ],
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
            style: AppTextStyles.heading2.copyWith(
              color: Colors.grey.shade600,
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            "Your booked tickets will appear here",
            style: AppTextStyles.body2.copyWith(
              color: Colors.grey.shade500,
              fontSize: 12,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () => Get.offAllNamed('/home'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green,
              foregroundColor: Colors.white,
            ),
            child: Text(
              "Book a Trip",
              style: AppTextStyles.button.copyWith(fontSize: 10),
            ),
          ),
        ],
      ),
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
    final departure = trip['departure'] ?? 'N/A';
    final destination = trip['destination'] ?? 'N/A';
    final plateNumber = trip['plateNumber'] ?? 'N/A';
    final time = trip['departureTime'] ?? '06:30 AM';
    final date = trip['departureDate'] ?? 'Today';

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
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        child: Column(
          children: [
            // Header with drag handle
            Container(
              padding: const EdgeInsets.only(top: 12, bottom: 12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.1),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                children: [
                  // Drag handle
                  Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade300,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            "E-Ticket Details",
                            style: AppTextStyles.heading2.copyWith(
                              fontSize: 16,
                              color: Colors.black,
                            ),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.all(6),
                          decoration: BoxDecoration(
                            color: Colors.grey.shade100,
                            shape: BoxShape.circle,
                          ),
                          child: GestureDetector(
                            onTap: () => Get.back(),
                            child: Icon(
                              Icons.close,
                              color: Colors.grey.shade700,
                              size: 20,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    // Booking Status & Amount Card
                    Column(
                      children: [
                        // Status Badge
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Booking ID",
                              style: AppTextStyles.body2.copyWith(
                                color: Colors.grey.shade600,
                                fontSize: 12,
                              ),
                            ),
                            Text(
                              bookingId,
                              style: AppTextStyles.body2.copyWith(
                                fontWeight: FontWeight.w600,
                                fontSize: 12,
                                color: const Color(0xFF029600),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    // QR Code Card
                    const SizedBox(height: 16),
                    Column(
                      children: [
                        // Text(
                        //   "Scan QR Code",
                        //   style: AppTextStyles.heading3.copyWith(
                        //     fontSize: 14,
                        //     color: Colors.black,
                        //   ),
                        // ),
                        // const SizedBox(height: 16),
                        Column(
                          children: [
                            QrImageView(
                              data: qrString,
                              version: QrVersions.auto,
                              size: 100.0,
                            ),
                            const SizedBox(height: 12),
                            Text(
                              "Show this QR code to the bus conductor",
                              style: AppTextStyles.caption.copyWith(
                                color: Colors.grey.shade600,
                                fontSize: 10,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ],
                    ),
                    SizedBox(height: 16),
                    // Trip Details Card
                    Column(
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: Colors.blue.shade100,
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                Iconsax.profile_2user,
                                color: Colors.blue.shade800,
                                size: 16,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Passenger",
                                    style: AppTextStyles.caption.copyWith(
                                      color: Colors.blue.shade800,
                                      fontSize: 10,
                                    ),
                                  ),
                                  Text(
                                    passengerName,
                                    style: AppTextStyles.body2.copyWith(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 12,
                                      color: Colors.blue.shade900,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: Colors.blue.shade100,
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                Iconsax.mobile,
                                color: Colors.blue.shade800,
                                size: 16,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Phone",
                                    style: AppTextStyles.caption.copyWith(
                                      color: Colors.blue.shade800,
                                      fontSize: 10,
                                    ),
                                  ),
                                  Text(
                                    phone,
                                    style: AppTextStyles.body2.copyWith(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 12,
                                      color: Colors.blue.shade900,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    // Seat Numbers Card
                    if (selectedSeats.isNotEmpty)
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: Colors.blue.shade100,
                                  shape: BoxShape.circle,
                                ),
                                child: Icon(
                                  Icons.event_seat_outlined,
                                  color: Colors.blue.shade700,
                                  size: 16,
                                ),
                              ),
                              const SizedBox(width: 8),
                              Text(
                                "Seat Numbers",
                                style: AppTextStyles.caption.copyWith(
                                  color: Colors.blue.shade800,
                                  fontSize: 10,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          Wrap(
                            spacing: 10,
                            runSpacing: 10,
                            children: selectedSeats
                                .map(
                                  (seat) => Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 14,
                                      vertical: 8,
                                    ),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(8),
                                      border: Border.all(
                                        color: Colors.blue.shade300,
                                        width: 1.5,
                                      ),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.blue.shade100,
                                          blurRadius: 4,
                                          offset: const Offset(0, 2),
                                        ),
                                      ],
                                    ),
                                    child: Text(
                                      seat,
                                      style: AppTextStyles.body2.copyWith(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 13,
                                        color: Colors.blue.shade800,
                                      ),
                                    ),
                                  ),
                                )
                                .toList(),
                          ),
                        ],
                      ),

                    SizedBox(height: 16),
                    Container(
                      margin: const EdgeInsets.only(bottom: 10),
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color: Colors.orange.shade50,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.orange.withOpacity(0.1),
                            blurRadius: 8,
                            offset: const Offset(0, 4),
                          ),
                        ],
                        border: Border.all(
                          color: Colors.orange.shade200,
                          width: 1,
                        ),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: Colors.orange.shade100,
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              Iconsax.info_circle,
                              color: Colors.orange.shade700,
                              size: 18,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Important Information",
                                  style: AppTextStyles.body2.copyWith(
                                    fontWeight: FontWeight.w700,
                                    color: Colors.orange.shade800,
                                    fontSize: 14,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    _buildBulletPoint(
                                      "Arrive at the terminal at least 30 minutes before departure",
                                    ),
                                    _buildBulletPoint(
                                      "Bring a valid ID for verification",
                                    ),
                                    _buildBulletPoint(
                                      "Keep this e-ticket accessible during the journey",
                                    ),
                                    _buildBulletPoint(
                                      "Seats are non-transferable",
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBulletPoint(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: const EdgeInsets.only(top: 4),
            height: 5,
            width: 5,
            decoration: BoxDecoration(
              color: Colors.orange.shade700,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              style: AppTextStyles.caption.copyWith(
                color: Colors.orange.shade700,
                fontSize: 10,
                height: 1.3,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
