import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:oro_ticket_booking_app/app/widgets/app_scaffold.dart';
import 'package:oro_ticket_booking_app/core/constants/colors.dart';
import 'package:oro_ticket_booking_app/core/constants/typography.dart';
import '../controllers/book_controller.dart';

class BookView extends GetView<BookController> {
  @override
  BookController controller = Get.put(BookController());
  BookView({super.key});

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: 'Book Ticket',
      currentBottomNavIndex: 0,

      body: SafeArea(
        child: Column(
          children: [
            // Compact Trip Header
            // _buildCompactTripHeader(),
            SizedBox(height: 16),

            // Seat Selection Section
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  children: [
                    // Legend
                    _buildSeatLegend(),
                    const SizedBox(height: 16),

                    // Seat Grid
                    Expanded(child: _buildSeatGrid()),

                    // Selected Seats Summary
                    _buildSelectedSeatsSummary(),
                  ],
                ),
              ),
            ),

            // Buy Button
            _buildBuyButton(),
          ],
        ),
      ),
    );
  }

  /* Widget _buildCompactTripHeader() {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF029600), Color(0xFF029600)],
        ),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Obx(
        () => Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Locations - Vertical layout
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Departure at top
                  Text(
                    controller.selectedTrip.value?['departure'] ?? 'N/A',
                    style: AppTextStyles.body1.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),

                  // Downward arrow in the middle
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Align(
                        alignment: Alignment.center,
                        child: Row(
                          children: [
                            Icon(
                              Icons.arrow_downward,
                              color: Colors.white70,
                              fontWeight: FontWeight.w600,
                              size: 20,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),

                  // Arrival at bottom
                  Text(
                    controller.selectedTrip.value?['destination'] ?? 'N/A',
                    style: AppTextStyles.body1.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 8),
                  // Price and selected seats
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "${controller.selectedTrip.value?['price'] ?? '0'} ETB",
                        style: AppTextStyles.caption.copyWith(
                          color: Colors.white70,
                        ),
                      ),
                      Text(
                        "${controller.selectedSeats.length} seat${controller.selectedSeats.length != 1 ? 's' : ''} selected",
                        style: AppTextStyles.caption.copyWith(
                          color: Colors.white70,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
*/
  Widget _buildSeatLegend() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildLegendItem(Color(0xFF10B981), "Available", Icons.event_seat),
          _buildLegendItem(Color(0xFF3B82F6), "Selected", Icons.check_circle),
          _buildLegendItem(Color(0xFF6B7280), "Booked", Icons.block),
        ],
      ),
    );
  }

  Widget _buildLegendItem(Color color, String label, IconData icon) {
    return Row(
      children: [
        Container(
          width: 20,
          height: 20,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(4),
          ),
          child: Icon(icon, color: Colors.white, size: 12),
        ),
        const SizedBox(width: 6),
        Text(label, style: AppTextStyles.caption),
      ],
    );
  }

  Widget _buildSeatGrid() {
    return GetBuilder<BookController>(
      builder: (ctrl) {
        // Calculate dynamic seat layout based on bus capacity
        final totalSeats = ctrl.selectedTrip.value?['seatsAvailable'] ?? 0;
        final seatsPerRow = 4; // Standard bus layout
        final totalRows = (totalSeats / seatsPerRow).ceil();

        return SingleChildScrollView(
          child: Column(
            children: [
              // Steering Wheel
              Container(
                margin: const EdgeInsets.only(bottom: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      'assets/images/steering-wheel.png',
                      width: 40,
                      height: 40,
                      color: AppColors.bottomNavUnselected,
                    ),
                    const SizedBox(width: 100),
                    // Text(
                    //   "Driver",
                    //   style: AppTextStyles.caption.copyWith(color: Colors.grey),
                    // ),
                  ],
                ),
              ),

              // Seat Grid
              Column(
                children: List.generate(totalRows, (rowIndex) {
                  final rowLetter = String.fromCharCode(
                    65 + rowIndex,
                  ); // A, B, C, etc.
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 6),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Row Label
                        Container(
                          width: 24,
                          child: Text(
                            rowLetter,
                            style: AppTextStyles.caption.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        const SizedBox(width: 8),

                        // Left Side Seats (1-2)
                        _buildSeatButton("${rowLetter}1", ctrl),
                        const SizedBox(width: 8),
                        _buildSeatButton("${rowLetter}2", ctrl),

                        // Aisle
                        Container(
                          width: 40,
                          margin: const EdgeInsets.symmetric(horizontal: 12),
                          child: Divider(
                            color: Colors.grey.shade300,
                            thickness: 1,
                          ),
                        ),

                        // Right Side Seats (3-4)
                        _buildSeatButton("${rowLetter}3", ctrl),
                        const SizedBox(width: 8),
                        _buildSeatButton("${rowLetter}4", ctrl),
                      ],
                    ),
                  );
                }),
              ),

              // Back of Bus Indicator
              Container(
                margin: const EdgeInsets.only(top: 20),
                padding: const EdgeInsets.symmetric(
                  vertical: 8,
                  horizontal: 16,
                ),
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text("Back of Bus", style: AppTextStyles.caption),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildSeatButton(String seatNumber, BookController ctrl) {
    final status = ctrl.seats[seatNumber] ?? "available";
    final isSelected = status == "selected";
    final isBooked = status == "booked";
    final isAvailable = status == "available";

    Color backgroundColor;
    Color borderColor;
    IconData? icon;

    if (isBooked) {
      backgroundColor = Color(0xFF6B7280);
      borderColor = Color(0xFF6B7280);
      icon = Icons.block;
    } else if (isSelected) {
      backgroundColor = Color(0xFF3B82F6);
      borderColor = Color(0xFF3B82F6);
      icon = Icons.check;
    } else {
      backgroundColor = Color(0xFF10B981);
      borderColor = Color(0xFF10B981).withOpacity(0.3);
    }

    return GestureDetector(
      onTap: () {
        if (isAvailable) {
          ctrl.toggleSeat(seatNumber);
        } else if (isSelected) {
          // Allow deselection
          ctrl.toggleSeat(seatNumber);
        }
      },
      child: Container(
        width: 36,
        height: 36,
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: borderColor, width: 2),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: backgroundColor.withOpacity(0.3),
                    blurRadius: 6,
                    offset: const Offset(0, 2),
                  ),
                ]
              : null,
        ),
        child: Center(
          child: isBooked
              ? Icon(icon, color: Colors.white, size: 16)
              : Text(
                  seatNumber.substring(1), // Show only the number part (A1 → 1)
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
        ),
      ),
    );
  }

  Widget _buildSelectedSeatsSummary() {
    return Obx(
      () => AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: controller.selectedSeats.isEmpty
              ? Colors.transparent
              : Colors.blue.shade50,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: controller.selectedSeats.isEmpty
                ? Colors.transparent
                : Colors.blue.shade200,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Selected Seats",
                  style: AppTextStyles.caption.copyWith(
                    color: Colors.grey.shade600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  controller.selectedSeats.isEmpty
                      ? "No seats selected"
                      : controller.selectedSeats.join(", "),
                  style: AppTextStyles.body1.copyWith(
                    fontWeight: FontWeight.w600,
                    color: controller.selectedSeats.isEmpty
                        ? Colors.grey
                        : Colors.blue.shade800,
                  ),
                ),
              ],
            ),
            // if (controller.selectedSeats.isNotEmpty)
            //   Text(
            //     "${controller.selectedSeats.length} × ${controller.selectedTrip.value?['price'] ?? 0} ETB",
            //     style: AppTextStyles.heading3.copyWith(
            //       color: Colors.green.shade700,
            //     ),
            //   ),
          ],
        ),
      ),
    );
  }

  Widget _buildBuyButton() {
    return SafeArea(
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 8,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: Obx(
          () => Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (controller.selectedSeats.isNotEmpty) ...[
                // Total Price Row
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.only(bottom: 12),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Total Amount:",
                        style: AppTextStyles.body1.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        "${controller.selectedSeats.length * (controller.selectedTrip.value?['price'] ?? 0)} ETB",
                        style: AppTextStyles.heading3.copyWith(
                          color: Colors.green.shade700,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
              // Continue Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 2,
                  ),
                  onPressed: controller.selectedSeats.isNotEmpty
                      ? () {
                          Get.toNamed(
                            '/payment',
                            arguments: {
                              'selectedSeats': controller.selectedSeats,
                              'trip': controller.selectedTrip.value,
                            },
                          );
                        }
                      : null,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(width: 8),
                      Text("Continue to Payment", style: AppTextStyles.button),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
