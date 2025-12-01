import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:oro_ticket_booking_app/app/widgets/app_scaffold.dart';
import 'package:oro_ticket_booking_app/core/constants/colors.dart';
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
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Ticket Info Card
              Obx(() => Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "trip_details".tr,
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Chip(
                            label: Text(controller.selectedTrip.value?['level'] ?? 'Standard'),
                            backgroundColor: Colors.orange.shade300,
                            labelStyle: const TextStyle(color: Colors.white),
                          ),
                          const SizedBox(width: 8),
                          Chip(label: Text("${"price".tr}: ${controller.selectedTrip.value?['price'] ?? 'N/A'} ETB")),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Icon(Icons.location_on, color: Colors.green),
                          SizedBox(width: 6),
                          Text(controller.selectedTrip.value?['departure'] ?? 'N/A'),
                          Spacer(),
                          Icon(Icons.location_on, color: Colors.red),
                          SizedBox(width: 6),
                          Text(controller.selectedTrip.value?['destination'] ?? 'N/A'),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        "${"bus".tr} ${controller.selectedTrip.value?['plateNumber'] ?? 'N/A'} • ${"seats_available".tr}: ${controller.selectedTrip.value?['seatsAvailable'] ?? 'N/A'}",
                      ),
                      const SizedBox(height: 12),

                      // Legend
                      Row(
                        children: [
                          _legendBox(Colors.blueGrey.shade100, "Available"),
                          const SizedBox(width: 12),
                          _legendBox(Colors.teal, "Selected"),
                          const SizedBox(width: 12),
                          _legendBox(Colors.green, "Booked"),
                        ],
                      ),
                    ],
                  ),
                ),
              )),
              const SizedBox(height: 20),

              // Seat Layout
              Expanded(
                child: Center(
                  child: GetBuilder<BookController>(
                    builder: (ctrl) => SingleChildScrollView(
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image.asset(
                                'assets/images/steering-wheel.png',
                                width: 40,
                                height: 40,
                                color: AppColors.bottomNavUnselected,
                              ), // steering wheel
                              SizedBox(width: 69), // align to aisle spacing
                              SizedBox(width: 45), // placeholder for seat
                              SizedBox(width: 12),
                              SizedBox(width: 45), // placeholder for seat
                            ],
                          ),
                          const SizedBox(height: 12),

                          // rows
                          for (var row in ctrl.seats.keys.map((seat) => seat[0]).toSet().toList()..sort())
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 4),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  // left side
                                  _seatButton(
                                    "${row}1",
                                    ctrl.seats["${row}1"] ?? "available",
                                    () => ctrl.toggleSeat("${row}1"),
                                  ),
                                  const SizedBox(width: 12),
                                  _seatButton(
                                    "${row}2",
                                    ctrl.seats["${row}2"] ?? "available",
                                    () => ctrl.toggleSeat("${row}2"),
                                  ),

                                  // aisle space
                                  const SizedBox(width: 32),

                                  // right side
                                  _seatButton(
                                    "${row}3",
                                    ctrl.seats["${row}3"] ?? "available",
                                    () => ctrl.toggleSeat("${row}3"),
                                  ),
                                  const SizedBox(width: 12),
                                  _seatButton(
                                    "${row}4",
                                    ctrl.seats["${row}4"] ?? "available",
                                    () => ctrl.toggleSeat("${row}4"),
                                  ),
                                ],
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),

              // Buy Button
              SafeArea(
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    onPressed: () {
                      final selected = controller.selectedSeats;
                      if (selected.isEmpty) {
                        Get.snackbar(
                          "No Seat Selected",
                          "Please select at least one seat to continue",
                          snackPosition: SnackPosition.BOTTOM,
                          backgroundColor: Colors.redAccent,
                          colorText: Colors.white,
                        );
                      } else {
                        Get.toNamed('/payment', arguments: {
                          'selectedSeats': selected,
                          'trip': controller.selectedTrip.value,
                        });
                      }
                    },
                    child: Text(
                      "buy_now".tr,
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _seatButton(String seat, String status, VoidCallback onTap) {
    Color color;
    switch (status) {
      case "selected":
        color = Colors.teal;
        break;
      case "booked":
        color = Colors.green;
        break;
      default:
        color = Colors.blueGrey.shade100;
    }
    return GestureDetector(
      onTap: status != "booked" ? onTap : null,
      child: Container(
        width: 45,
        height: 45,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Center(
          child: Text(
            seat,
            style: const TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }

  static Widget _legendBox(Color color, String label) {
    return Row(
      children: [
        Container(
          width: 18,
          height: 18,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(4),
          ),
        ),
        const SizedBox(width: 6),
        Text(label),
      ],
    );
  }
}
