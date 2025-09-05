import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/book_controller.dart';

class BookView extends GetView<BookController> {
   BookView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("OTA", style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.menu),
          onPressed: () {},
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.account_circle, size: 30),
            onPressed: () {},
          ),
        ],
        backgroundColor: Colors.green,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Ticket Info Card
            Card(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16)),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text("Mon, 19 February 2025",
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Chip(
                          label: const Text("Fastest"),
                          backgroundColor: Colors.orange.shade100,
                        ),
                        const SizedBox(width: 8),
                        const Chip(label: Text("Mix")),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: const [
                        Icon(Icons.location_on, color: Colors.green),
                        SizedBox(width: 6),
                        Text("Halte K. Bali"),
                        Spacer(),
                        Icon(Icons.location_on, color: Colors.red),
                        SizedBox(width: 6),
                        Text("Halte Senen"),
                      ],
                    ),
                    const SizedBox(height: 8),
                    const Text("Bus 01  •  Arrival in 15:30 at Halte Kampung Bali"),
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
            ),
            const SizedBox(height: 20),

            // Seat Layout
            Expanded(
              child: Center(
                child: GetBuilder<BookController>(
                  builder: (ctrl) => Column(
                    children: [
                      const Icon(Icons.directions_bus, size: 40),
                      const SizedBox(height: 16),
                      for (var row in ["A", "B", "C", "D", "E", "F", "G"])
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            for (var col in [1, 2, 3, 4])
                              Padding(
                                padding: const EdgeInsets.all(6.0),
                                  child: _seatButton(
                                    "${row}$col",
                                    ctrl.seats["${row}$col"] ?? "available", // safe
                                    () => ctrl.toggleSeat("${row}$col"),
                                  ),

                              )
                          ],
                        ),
                    ],
                  ),
                ),
              ),
            ),

            // Buy Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12))),
                onPressed: () {
                  final selected = controller.selectedSeats;
                  if (selected.isEmpty) {
                    Get.snackbar("No Seat Selected",
                        "Please select at least one seat to continue",
                        snackPosition: SnackPosition.BOTTOM,
                        backgroundColor: Colors.redAccent,
                        colorText: Colors.white);
                  } else {
                    Get.toNamed('/confirm', arguments: selected);
                  }
                },
                child: const Text("Buy Now",
                    style: TextStyle(color: Colors.white, fontSize: 16)),
              ),
            ),
          ],
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
          borderRadius: BorderRadius.circular(8),
        ),
        child: Center(
            child: Text(seat,
                style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: Colors.white))),
      ),
    );
  }

  Widget _legendBox(Color color, String label) {
    return Row(
      children: [
        Container(
          width: 18,
          height: 18,
          decoration: BoxDecoration(
              color: color, borderRadius: BorderRadius.circular(4)),
        ),
        const SizedBox(width: 6),
        Text(label),
      ],
    );
  }
}
