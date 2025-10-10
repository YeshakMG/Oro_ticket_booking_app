import 'package:get/get.dart';

class BookController extends GetxController {
  // Observable seat map
  var seats = <String, String>{}.obs;
  var selectedTrip = Rxn<Map<String, dynamic>>();

  @override
  void onInit() {
    super.onInit();
    if (Get.arguments != null) {
      selectedTrip.value = Get.arguments is Map
          ? Map<String, dynamic>.from(Get.arguments)
          : <String, dynamic>{};
      _generateSeats();
    }
  }

  /// Generate seats dynamically based on trip's seatsAvailable
  void _generateSeats() {
    if (selectedTrip.value == null) return;

    int totalSeats = selectedTrip.value!['seatsAvailable'] ?? 28;
    seats.clear();

    // Assume 4 seats per row, calculate rows needed
    int seatsPerRow = 4;
    int rowsNeeded = (totalSeats / seatsPerRow).ceil();
    List<String> rowLabels = List.generate(rowsNeeded, (index) => String.fromCharCode(65 + index)); // A, B, C, ...

    for (var row in rowLabels) {
      for (int col = 1; col <= seatsPerRow; col++) {
        String seatId = "$row$col";
        seats[seatId] = "available";
      }
    }

    // Example: pre-booked seats (in real app, this would come from API)
    if (seats.containsKey("C2")) seats["C2"] = "booked";
    if (seats.containsKey("D4")) seats["D4"] = "booked";
    if (seats.containsKey("E4")) seats["E4"] = "booked";
    if (seats.containsKey("G4")) seats["G4"] = "booked";
  }

  /// Toggle seat selection
  void toggleSeat(String seat) {
    if (seats[seat] == "available") {
      seats[seat] = "selected";
    } else if (seats[seat] == "selected") {
      seats[seat] = "available";
    }
    update();
  }

  /// Get list of selected seats
  List<String> get selectedSeats =>
      seats.entries.where((e) => e.value == "selected").map((e) => e.key).toList();
}
