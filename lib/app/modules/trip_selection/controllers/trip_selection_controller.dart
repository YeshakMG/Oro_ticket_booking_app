import 'package:get/get.dart';

class TripSelectionController extends GetxController {
  var trips = <Map<String, dynamic>>[].obs;
  var from = ''.obs;
  var to = ''.obs;

  @override
  void onInit() {
    super.onInit();
    if (Get.arguments != null) {
      from.value = Get.arguments['from'] ?? '';
      to.value = Get.arguments['to'] ?? '';
      trips.value = List<Map<String, dynamic>>.from(Get.arguments['trips'] ?? []);
    }
  }

  void selectTrip(Map<String, dynamic> trip) {
    Get.toNamed('/book', arguments: trip);
  }
}