import 'package:get/get.dart';

class BookController extends GetxController {
  // Observable seat map
  var seats = <String, String>{}.obs;

  @override
  void onInit() {
    super.onInit();
    _generateSeats();
  }

  /// Generate seats A–G and 1–4, all initially "available"
  void _generateSeats() {
    const rows = ["A", "B", "C", "D", "E", "F", "G"];
    const cols = [1, 2, 3, 4];

    for (var row in rows) {
      for (var col in cols) {
        seats["$row$col"] = "available";
      }
    }

    // Example: pre-booked or pre-selected seats
    seats["C2"] = "selected";
    seats["D4"] = "booked";
    seats["E1"] = "selected";
    seats["E2"] = "selected";
    seats["E4"] = "booked";
    seats["G4"] = "booked";
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
