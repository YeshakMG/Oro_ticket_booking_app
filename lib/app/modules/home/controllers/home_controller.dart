import 'package:get/get.dart';

class HomeController extends GetxController {
  var userName = "Yeshak Mesfin".obs;

  // Static dropdown options
  final List<String> locations = ["Addis Ababa", "Adama", "Bishoftu", "Hawassa"];

  // Selected locations
  var fromLocation = "Addis Ababa".obs;
  var toLocation = "Adama".obs;

  // Example active tickets
  var tickets = [
    {
      "date": "Mon, 19 February 2025",
      "type": "Fastest",
      "bus": "Bus 041",
      "time": "15:30",
      "location": "Halte Kampung Bali"
    }
  ].obs;
}
