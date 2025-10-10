import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';

class PaymentController extends GetxController {
  var selectedSeats = <String>[].obs;
  var selectedTrip = Rxn<Map<String, dynamic>>();
  late Box bookingsBox;

  @override
  void onInit() {
    super.onInit();
    _initBoxes();
    if (Get.arguments != null) {
      selectedSeats.value = Get.arguments['selectedSeats'] is List
          ? List<String>.from(Get.arguments['selectedSeats'])
          : <String>[];
      selectedTrip.value = Get.arguments['trip'] is Map
          ? Map<String, dynamic>.from(Get.arguments['trip'])
          : null;
    }
  }

  Future<void> _initBoxes() async {
    bookingsBox = await Hive.openBox('bookingsBox');
  }

  void processPayment() {
    // Mock payment processing
    Get.snackbar(
      "Payment Processing",
      "Processing your payment...",
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.blue,
      colorText: Colors.white,
    );

    // Simulate payment delay
    Future.delayed(const Duration(seconds: 2), () {
      // Save booking
      _saveBooking();

      Get.snackbar(
        "Payment Successful",
        "Your booking has been confirmed!",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );

      // Navigate to my ticket
      Get.offAllNamed('/home'); // Go back to home, user can navigate to myticket
    });
  }

  void _saveBooking() {
    final booking = {
      'trip': selectedTrip.value,
      'selectedSeats': selectedSeats,
      'bookingId': DateTime.now().millisecondsSinceEpoch.toString(),
      'timestamp': DateTime.now().toIso8601String(),
      'totalAmount': selectedSeats.length * (selectedTrip.value?['price'] ?? 0),
    };

    bookingsBox.add(booking);
  }
}
