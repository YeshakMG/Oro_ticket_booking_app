import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:oro_ticket_booking_app/app/widgets/app_scaffold.dart';
import 'package:oro_ticket_booking_app/core/constants/typography.dart';
import '../controllers/payment_controller.dart';

class PaymentView extends GetView<PaymentController> {
  const PaymentView({super.key});

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: "Confirm Booking",
      body: SafeArea(
        child: Column(
          children: [
            // Progress Indicator
            // _buildProgressIndicator(),

            // Content
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    // Trip Info Card
                    _buildTripInfoCard(),
                    const SizedBox(height: 20),

                    // Selected Seats Section
                    _buildSelectedSeatsSection(),
                    const SizedBox(height: 20),

                    // Price Breakdown
                    _buildPriceBreakdown(),
                  ],
                ),
              ),
            ),

            // Payment Button
            _buildPaymentButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildProgressIndicator() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.green.shade50,
        border: Border(
          bottom: BorderSide(color: Colors.green.shade100, width: 1),
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.green,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text("Step 2 of 2", style: AppTextStyles.buttonSmall),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              "Confirm & Pay",
              style: AppTextStyles.body1.copyWith(
                fontWeight: FontWeight.w600,
                color: Colors.green.shade800,
              ),
            ),
          ),
          Icon(Icons.lock, color: Colors.green, size: 16),
          const SizedBox(width: 4),
          Text(
            "Secure",
            style: AppTextStyles.caption.copyWith(color: Colors.green),
          ),
        ],
      ),
    );
  }

  Widget _buildTripInfoCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF029600), Color(0xFF029600)],
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Obx(
        () => Column(
          children: [
            // Route with arrow
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.location_on,
                            color: Colors.white,
                            size: 20,
                          ),
                          const SizedBox(width: 12),
                          Text(
                            controller.selectedTrip.value?['departure'] ??
                                'N/A',
                            style: AppTextStyles.body1.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(vertical: 4),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
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
                      Row(
                        children: [
                          Icon(
                            Icons.location_on_rounded,
                            color: Colors.white,
                            size: 20,
                          ),
                          const SizedBox(width: 12),
                          Text(
                            controller.selectedTrip.value?['destination'] ??
                                'N/A',
                            style: AppTextStyles.body1.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: 16),
            Container(height: 1, color: Colors.white.withOpacity(0.3)),
            const SizedBox(height: 12),

            // Trip Details
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildTripDetail(
                  "Bus Number",
                  controller.selectedTrip.value?['plateNumber'] ?? 'N/A',
                ),
                _buildTripDetail("Date", "Today"),
                _buildTripDetail("Time", "06:30 AM"),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTripDetail(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTextStyles.caption.copyWith(color: Colors.white70),
        ),
        const SizedBox(height: 2),
        Text(
          value,
          style: AppTextStyles.body2.copyWith(
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  Widget _buildSelectedSeatsSection() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade300),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.event_seat, color: Colors.green, size: 20),
              const SizedBox(width: 8),
              Text(
                "Selected Seats",
                style: AppTextStyles.heading3.copyWith(
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                  fontSize: 14,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Obx(
            () => Wrap(
              spacing: 8,
              runSpacing: 8,
              children: controller.selectedSeats.map((seat) {
                return Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.blue.shade50,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.blue.shade200),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.chair, color: Colors.blue.shade700, size: 16),
                      const SizedBox(width: 6),
                      Text(
                        seat,
                        style: AppTextStyles.body2.copyWith(
                          fontWeight: FontWeight.w600,
                          color: Colors.blue.shade800,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPriceBreakdown() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade300),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Obx(() {
        final seatPrice = controller.selectedTrip.value?['price'] ?? 0;
        final totalSeats = controller.selectedSeats.length;
        final totalAmount = totalSeats * seatPrice;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.receipt, color: Colors.green, size: 20),
                const SizedBox(width: 8),
                Text(
                  "Price Breakdown",
                  style: AppTextStyles.heading3.copyWith(
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Seat Cost
            _buildPriceRow(
              "${totalSeats} Seat${totalSeats != 1 ? 's' : ''} × $seatPrice ETB",
              "$totalAmount ETB",
            ),
            const SizedBox(height: 8),

            // Service Fee
            _buildPriceRow("Service Fee", "0 ETB", isSecondary: true),
            const SizedBox(height: 8),

            // Tax
            _buildPriceRow("Tax", "0 ETB", isSecondary: true),

            const SizedBox(height: 12),
            Divider(color: Colors.grey.shade300),
            const SizedBox(height: 8),

            // Total
            _buildPriceRow("Total Amount", "$totalAmount ETB", isTotal: true),
          ],
        );
      }),
    );
  }

  Widget _buildPriceRow(
    String label,
    String value, {
    bool isSecondary = false,
    bool isTotal = false,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: isTotal
              ? AppTextStyles.heading3.copyWith(
                  color: Color(0xFF029600),
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                )
              : isSecondary
              ? AppTextStyles.body2.copyWith(color: Colors.grey.shade600)
              : AppTextStyles.body1.copyWith(
                  fontSize: 14,
                  fontWeight: FontWeight.w200,
                ),
        ),
        Text(
          value,
          style: isTotal
              ? AppTextStyles.heading2.copyWith(color: Colors.green.shade700)
              : isSecondary
              ? AppTextStyles.body2.copyWith(color: Colors.grey.shade600)
              : AppTextStyles.body1.copyWith(fontWeight: FontWeight.w600),
        ),
      ],
    );
  }

  Widget _buildPaymentButton() {
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
        child: Obx(() {
          final totalAmount =
              controller.selectedSeats.length *
              (controller.selectedTrip.value?['price'] ?? 0);

          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Total Amount
              Container(
                width: double.infinity,
                padding: const EdgeInsets.only(bottom: 12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Total to Pay:",
                      style: AppTextStyles.body1.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      "$totalAmount ETB",
                      style: AppTextStyles.heading2.copyWith(
                        color: Colors.green.shade700,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),

              // Pay Button
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
                  onPressed: () => controller.processPayment(),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.lock_outline, size: 20),
                      const SizedBox(width: 8),
                      Text("Pay Now", style: AppTextStyles.button),
                    ],
                  ),
                ),
              ),
            ],
          );
        }),
      ),
    );
  }
}
