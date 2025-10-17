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
      body: Column(
        children: [
          // Route Visualization Header
          _buildRouteHeader(),
          const SizedBox(height: 8),

          // Trip Count and Filter
          _buildTripHeader(),

          // Trips List
          Expanded(child: Obx(() => _buildTripsList())),
        ],
      ),
    );
  }

  Widget _buildRouteHeader() {
    return Container(
      margin: const EdgeInsets.all(16),
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
      child: Column(
        children: [
          // Route Visualization - Vertical Layout
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Left Icons Column
              Column(
                children: [
                  Icon(
                    Icons.radio_button_checked,
                    color: Colors.white,
                    size: 16,
                  ),
                  Container(
                    width: 2,
                    height: 30,
                    color: Colors.white.withOpacity(0.5),
                  ),
                  Icon(Icons.directions_bus, color: Colors.white, size: 20),
                  Container(
                    width: 2,
                    height: 30,
                    color: Colors.white.withOpacity(0.5),
                  ),
                  Icon(
                    Icons.radio_button_checked,
                    color: Colors.white,
                    size: 16,
                  ),
                ],
              ),

              const SizedBox(width: 12),

              // Locations Column - Full width for long names
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // From Location
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "From",
                          style: AppTextStyles.caption.copyWith(
                            color: Colors.white70,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          controller.from.value,
                          style: AppTextStyles.body1.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),

                    const SizedBox(height: 24), // Space between locations
                    // To Location
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "To",
                          style: AppTextStyles.caption.copyWith(
                            color: Colors.white70,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          controller.to.value,
                          style: AppTextStyles.body1.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                          ),
                          maxLines: 2,
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

          // Divider
          Container(height: 1, color: Colors.white.withOpacity(0.3)),

          const SizedBox(height: 12),

          // Date and Distance
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildInfoItem(Icons.calendar_today, "Today"),
              _buildInfoItem(Icons.schedule, "4-6 hrs"),
              _buildInfoItem(
                Icons.airline_seat_recline_normal,
                "Multiple Seats",
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildInfoItem(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, color: Colors.white70, size: 16),
        const SizedBox(width: 4),
        Text(
          text,
          style: AppTextStyles.caption.copyWith(color: Colors.white70),
        ),
      ],
    );
  }

  Widget _buildTripHeader() {
    final trips = controller.trips.length.obs;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Obx(
            () => Text(
              "$trips Trip${trips > 1 ? 's' : ''} Available",
              style: AppTextStyles.heading3,
            ),
          ),
          // // Filter Button
          // Container(
          //   decoration: BoxDecoration(
          //     color: Colors.grey.shade100,
          //     borderRadius: BorderRadius.circular(8),
          //   ),
          //   child: IconButton(
          //     icon: Icon(Icons.filter_list, color: Colors.green, size: 20),
          //     onPressed: _showFilterDialog,
          //   ),
          // ),
        ],
      ),
    );
  }

  Widget _buildTripsList() {
    if (controller.trips.isEmpty) {
      return _buildEmptyState();
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: controller.trips.length,
      itemBuilder: (context, index) {
        final trip = controller.trips[index];
        return _buildTripCard(trip, index);
      },
    );
  }

  Widget _buildTripCard(Map<String, dynamic> trip, int index) {
    final isStandard = (trip['level'] ?? 'Standard') == 'Standard';
    final seatsAvailable = trip['seatsAvailable'] ?? 0;
    final isAlmostFull = seatsAvailable <= 5;

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
          // Trip Header with Company and Price
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.green.shade50,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(16),
                topRight: Radius.circular(16),
              ),
            ),
            child: Row(
              children: [
                // Company Info
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: Color(0xFF029600),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    trip['company'] ?? 'OTA',
                    style: AppTextStyles.buttonSmall,
                  ),
                ),
                const SizedBox(width: 8),
                // Level Badge
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: isStandard
                        ? Colors.orange.shade100
                        : Colors.blue.shade100,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    trip['level'] ?? 'Standard',
                    style: AppTextStyles.caption.copyWith(
                      color: isStandard
                          ? Colors.orange.shade800
                          : Colors.blue.shade800,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                const Spacer(),
                // Price
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      "${trip['price'] ?? 'N/A'} ETB",
                      style: AppTextStyles.heading3.copyWith(
                        color: Color(0xFF029600),
                      ),
                    ),
                    Text("per person", style: AppTextStyles.caption),
                  ],
                ),
              ],
            ),
          ),

          // Trip Details
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                // Departure and Arrival Times
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildTimeInfo("Departure", "06:30 AM", Icons.pin_drop),
                    _buildRouteLine(),
                    _buildTimeInfo("Arrival", "11:30 AM", Icons.pin_drop_sharp),
                  ],
                ),

                const SizedBox(height: 16),

                // Bus Details
                Row(
                  children: [
                    Icon(Icons.directions_bus, color: Colors.green, size: 20),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        "${trip['plateNumber'] ?? 'N/A'} • ${trip['busModel'] ?? 'Coach Bus'}",
                        style: AppTextStyles.buttonSmall.copyWith(
                          color: Colors.grey[700],
                        ),
                      ),
                    ),
                    // Seats Available
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: isAlmostFull
                            ? Colors.red.shade50
                            : Colors.green.shade50,
                        borderRadius: BorderRadius.circular(6),
                        border: Border.all(
                          color: isAlmostFull
                              ? Colors.red.shade200
                              : Colors.green.shade200,
                        ),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.event_seat,
                            color: isAlmostFull ? Colors.red : Colors.green,
                            size: 14,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            "$seatsAvailable seats",
                            style: AppTextStyles.caption.copyWith(
                              color: isAlmostFull ? Colors.red : Colors.green,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 16),

                // Amenities
                _buildAmenities(trip),

                const SizedBox(height: 16),

                // Select Button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () => controller.selectTrip(trip),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFF029600),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 2,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.confirmation_number, size: 18),
                        const SizedBox(width: 8),
                        Text(
                          "Select This Trip",
                          style: AppTextStyles.buttonMediumW,
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
  }

  Widget _buildTimeInfo(String label, String time, IconData icon) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Icon(icon, color: Colors.green, size: 20),
        const SizedBox(height: 4),
        Text(label, style: AppTextStyles.caption),
        const SizedBox(height: 4),
        Text(
          time,
          style: AppTextStyles.body1.copyWith(fontWeight: FontWeight.w600),
        ),
      ],
    );
  }

  Widget _buildRouteLine() {
    return Expanded(
      child: Column(
        children: [
          Container(
            height: 2,
            margin: const EdgeInsets.symmetric(horizontal: 8),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.green.shade300, Colors.green.shade500],
              ),
            ),
          ),
          const SizedBox(height: 4),
          Icon(Icons.arrow_forward, color: Colors.green, size: 16),
        ],
      ),
    );
  }

  Widget _buildAmenities(Map<String, dynamic> trip) {
    final amenities = [
      if (trip['hasWifi'] == true) Icons.wifi,
      if (trip['hasAC'] == true) Icons.ac_unit,
      if (trip['hasCharging'] == true) Icons.power,
      if (trip['hasRestroom'] == true) Icons.wc,
    ];

    if (amenities.isEmpty) return const SizedBox();

    return Row(
      children: [
        Text("Amenities: ", style: AppTextStyles.caption),
        const SizedBox(width: 8),
        ...amenities
            .map(
              (icon) => Padding(
                padding: const EdgeInsets.only(right: 8),
                child: Icon(icon, color: Colors.green, size: 18),
              ),
            )
            .toList(),
      ],
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.directions_bus, size: 64, color: Colors.grey.shade400),
          const SizedBox(height: 16),
          Text(
            "No Trips Available",
            style: AppTextStyles.heading2.copyWith(color: Colors.grey.shade600),
          ),
          const SizedBox(height: 8),
          Text(
            "We couldn't find any trips for your selected route",
            style: AppTextStyles.body2.copyWith(color: Colors.grey.shade500),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () => Get.back(),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green,
              foregroundColor: Colors.white,
            ),
            child: Text("Change Search", style: AppTextStyles.button),
          ),
        ],
      ),
    );
  }

  void _showFilterDialog() {
    showDialog(
      context: Get.context!,
      builder: (context) => AlertDialog(
        title: Text("Filter Trips", style: AppTextStyles.heading3),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Add filter options here
            _buildFilterOption("Only show available seats", true),
            _buildFilterOption("Express trips only", false),
            _buildFilterOption("Luxury buses", false),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text("Cancel", style: AppTextStyles.body2),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
            child: Text("Apply", style: AppTextStyles.button),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterOption(String text, bool value) {
    return Row(
      children: [
        Checkbox(value: value, onChanged: (val) {}, activeColor: Colors.green),
        Text(text, style: AppTextStyles.body2),
      ],
    );
  }
}
